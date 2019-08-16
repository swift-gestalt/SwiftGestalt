/// Metadata.swift
///
/// Copyright 2019, The SwiftGestalt Project.
///
/// This project is released under the MIT license, a copy of which is
/// available in the repository.

protocol SwiftMetadata {
  associatedtype Layout
}

struct SwiftMetadataLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      ValueWitnessTableLayout()
      /// The kind. Only valid for non-class metadata.
      Constant<UInt>()
    }
  }
}

/// The public state of a metadata.
enum MetadataState : Int {
  // The values of this enum are set up to give us some future flexibility
  // in adding states.  The compiler emits unsigned comparisons against
  // these values, so adding states that aren't totally ordered with at
  // least the existing values will pose a problem but we also use a
  // gradually-shrinking bitset in case it's useful to track states as
  // separate capabilities.  Specific values have been chosen so that a
  // MetadataRequest of 0 represents a blocking complete request, which
  // is the most likely request from ordinary code.  The total size of a
  // state is kept to 8 bits so that a full request, even with additional
  // flags, can be materialized as a single immediate on common ISAs, and
  // so that the state can be extracted with a byte truncation.
  // The spacing between states reflects guesswork about where new
  // states/capabilities are most likely to be added.

  /// The metadata is fully complete.  By definition, this is the
  /// end-state of all metadata.  Generally, metadata is expected to be
  /// complete before it can be passed to arbitrary code, e.g. as
  /// a generic argument to a function or as a metatype value.
  ///
  /// In addition to the requirements of NonTransitiveComplete, certain
  /// transitive completeness guarantees must hold.  Most importantly,
  /// complete nominal type metadata transitively guarantee the completion
  /// of their stored generic type arguments and superclass metadata.
  case complete = 0x00

  /// The metadata is fully complete except for any transitive completeness
  /// guarantees.
  ///
  /// In addition to the requirements of LayoutComplete, metadata in this
  /// state must be prepared for all basic type operations.  This includes:
  ///
  ///   - any sort of internal layout necessary to allocate and work
  ///     with concrete values of the type, such as the instance layout
  ///     of a class
  ///
  ///   - any sort of external dynamic registration that might be required
  ///     for the type, such as the realization of a class by the Objective-C
  ///     runtime and
  ///
  ///   - the initialization of any other information kept in the metadata
  ///     object, such as a class's v-table.
  case nonTransitiveComplete = 0x01

  /// The metadata is ready for the layout of other types that store values
  /// of this type.
  ///
  /// In addition to the requirements of Abstract, metadata in this state
  /// must have a valid value witness table, meaning that its size,
  /// alignment, and basic type properties (such as POD-ness) have been
  /// computed.
  case layoutComplete = 0x3F

  /// The metadata has its basic identity established.  It is possible to
  /// determine what formal type it corresponds to.  Among other things, it
  /// is possible to use the runtime mangling facilities with the type.
  ///
  /// For example, a metadata for a generic struct has a metadata kind,
  /// a type descriptor, and all of its type arguments.  However, it does not
  /// necessarily have a meaningful value-witness table.
  ///
  /// References to other types that are not part of the type's basic identity
  /// may not yet have been established.  Most crucially, this includes the
  /// superclass pointer.
  case abstract = 0xFF
}

/// The result of requesting type metadata.  Generally the return value of
/// a function.
///
/// For performance and ABI matching across Swift/C++, functions returning
/// this type must use SWIFT_CC so that the components are returned as separate
/// values.
struct MetadataResponseLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      /// The requested metadata.
      SwiftMetadataLayout()
      /// The current state of the metadata returned.  Always use this
      /// instead of trying to inspect the metadata directly to see if it
      /// satisfies the request.  An incomplete metadata may be getting
      /// initialized concurrently.  But this can generally be ignored if
      /// the metadata request was for abstract metadata or if the request
      /// is blocking.
      NewTypeConstant<MetadataState>()
    }
  }
}

/// A dependency on the metadata progress of other type, indicating that
/// initialization of a metadata cannot progress until another metadata
/// reaches a particular state.
///
/// For performance, functions returning this type should use SWIFT_CC so
/// that the components are returned as separate values.
struct MetadataDependencyLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      /// Either null, indicating that initialization was successful, or
      /// a metadata on which initialization depends for further progress.
      SwiftMetadataLayout()

      /// The state that Metadata needs to be in before initialization
      /// can continue.
      NewTypeConstant<MetadataState>()
    }
  }
}
