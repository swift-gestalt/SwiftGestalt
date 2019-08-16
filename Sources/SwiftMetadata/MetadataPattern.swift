/// MetadataPattern.swift
///
/// Copyright 2019, The SwiftGestalt Project.
///
/// This project is released under the MIT license, a copy of which is
/// available in the repository.

/// The instantiation cache for generic metadata.  This must be guaranteed
/// to zero-initialized before it is first accessed.  Its contents are private
/// to the runtime.
struct GenericMetadataInstantiationCacheLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      /// Data that the runtime can use for its own purposes.  It is guaranteed
      /// to be zero-filled by the compiler.
      WordBuffer16Layout()
    }
  }
}

//using GenericMetadataInstantiationCache =
//  TargetGenericMetadataInstantiationCache<InProcess>

/// A function that instantiates metadata.  This function is required
/// to succeed.
///
/// In general, the metadata returned by this function should have all the
/// basic structure necessary to identify itself: that is, it must have a
/// type descriptor and generic arguments.  However, it does not need to be
/// fully functional as type metadata for example, it does not need to have
/// a meaningful value witness table, v-table entries, or a superclass.
///
/// Operations which may fail (due to e.g. recursive dependencies) but which
/// must be performed in order to prepare the metadata object to be fully
/// functional as type metadata should be delayed until the completion
/// function.
//using MetadataInstantiator =
//  Metadata *(const TargetTypeContextDescriptor<InProcess> *type,
//             const void *arguments,
//             const TargetGenericMetadataPattern<InProcess> *pattern)

/// The opaque completion context of a metadata completion function.
/// A completion function that needs to report a completion dependency
/// can use this to figure out where it left off and thus avoid redundant
/// work when re-invoked.  It will be zero on first entry for a type, and
/// the runtime is free to copy it to a different location between
/// invocations.
struct MetadataCompletionContextLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      WordBuffer4Layout()
    }
  }
}

/// Flags used by generic metadata patterns.
struct GenericMetadataPatternFlags : OptionSet {
  var rawValue: UInt32

  // All of these values are bit offsets or widths.
  // General flags build up from 0.
  // Kind-specific flags build down from 31.

  /// Does this pattern have an extra-data pattern?
  static let HasExtraDataPattern = GenericMetadataPatternFlags(rawValue: 0)

  // Class-specific flags.

  /// Does this pattern have an immediate-members pattern?
  static let Class_HasImmediateMembersPattern = GenericMetadataPatternFlags(rawValue: 31)

  // Value-specific flags.

  /// For value metadata: the metadata kind of the type.
  static let Value_MetadataKind = GenericMetadataPatternFlags(rawValue: 21)
  static let Value_MetadataKind_width = GenericMetadataPatternFlags(rawValue: 11)
}

/// A function which attempts to complete the given metadata.
///
/// This function may fail due to a dependency on the completion of some
/// other metadata object.  It can indicate this by returning the metadata
/// on which it depends.  In this case, the function will be invoked again
/// when the dependency is resolved.  The function must be careful not to
/// indicate a completion dependency on a type that has always been
/// completed the runtime cannot reliably distinguish this sort of
/// programming failure from a race in which the dependent type was
/// completed immediately after it was observed to be incomplete, and so
/// the function will be repeatedly re-invoked.
///
/// The function will never be called multiple times simultaneously, but
/// it may be called many times as successive dependencies are resolved.
/// If the function ever completes successfully (by returning null), it
/// will not be called again for the same type.
//using MetadataCompleter =
//  SWIFT_CC(swift)
//  MetadataDependency(const Metadata *type,
//                     MetadataCompletionContext *context,
//                     const TargetGenericMetadataPattern<InProcess> *pattern)
typealias MetadataCompleter = FunctionPointer<(OpaquePointer, OpaquePointer, OpaquePointer), MetadataDependencyLayout>

/// An instantiation pattern for type metadata.
struct GenericMetadataPatternLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      /// The function to call to instantiate the template.
      ///
      /// using MetadataInstantiator =
      //  Metadata *(const TargetTypeContextDescriptor<InProcess> *type,
      //             const void *arguments,
      //             const TargetGenericMetadataPattern<InProcess> *pattern)
      RelativeDirectPointerLayout<FunctionPointer<(OpaquePointer, OpaquePointer, OpaquePointer), OpaquePointer>>()
      /// The function to call to complete the instantiation.  If this is null,
      /// the instantiation function must always generate complete metadata.
      ///
      /// using MetadataCompleter =
      //  SWIFT_CC(swift)
      //  MetadataDependency(const Metadata *type,
      //                     MetadataCompletionContext *context,
      //                     const TargetGenericMetadataPattern<InProcess> *pattern)
      RelativeDirectPointerLayout<MetadataCompleter>()
      /// Flags describing the layout of this instantiation pattern.
      Flags<GenericMetadataPatternFlags>()
    }
  }
}

/// Part of a generic metadata instantiation pattern.
struct GenericMetadataPartialPatternLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      /// A reference to the pattern.  The pattern must always be at least
      /// word-aligned.
      RelativeDirectPointerLayout<Int>()

      /// The offset into the section into which to copy this pattern, in words.
      Constant<UInt16>()

      /// The size of the pattern, in words.
      Constant<UInt16>()
    }
  }
}

struct ClassFlags : OptionSet {
  var rawValue: UInt32
  /// Is this a Swift class from the Darwin pre-stable ABI?
  /// This bit is clear in stable ABI Swift classes.
  /// The Objective-C runtime also reads this bit.
  static let IsSwiftPreStableABI = ClassFlags(rawValue: 1 << 0)

  /// Does this class use Swift refcounting?
  static let UsesSwiftRefcounting = ClassFlags(rawValue: 1 << 1)

  /// Has this class a custom name, specified with the @objc attribute?
  static let HasCustomObjCName = ClassFlags(rawValue: 1 << 2)
}

/// An instantiation pattern for generic class metadata.
struct GenericClassMetadataPattern : MetadataLayout {
  static func deserialize() -> ByteReader<Never> {
    fatalError("FIXME: Need to do this custom for the trailing objects")
  }

  var layout: some MetadataLayout {
    Metadata {
      GenericMetadataPatternLayout()
      /// The heap-destructor function.
      ///
      /// using HeapObjectDestroyer =
      ///     SWIFT_CC(swift) void(SWIFT_CONTEXT HeapObject *)
      RelativeDirectPointerLayout<FunctionPointer<(OpaquePointer), ()>>()

      /// The ivar-destructor function.
      /// ///
      /// using ClassIVarDestroyer =
      ///   SWIFT_CC(swift) void(SWIFT_CONTEXT HeapObject *)
      RelativeDirectPointerLayout<FunctionPointer<OpaquePointer, ()>>()

      /// The class flags.
      Flags<ClassFlags>()

      // The following fields are only present in ObjC interop.

      /// The offset of the class RO-data within the extra data pattern,
      /// in words.
      Constant<UInt16>()

      /// The offset of the metaclass object within the extra data pattern,
      /// in words.
      Constant<UInt16>()

      /// The offset of the metaclass RO-data within the extra data pattern,
      /// in words.
      Constant<UInt16>()

      Constant<UInt16>()
    }
    .withTrailingObjects {
      GenericMetadataPartialPatternLayout()
    }
  }
}

/// An instantiation pattern for generic value metadata.
struct GenericValueMetadataPattern : MetadataLayout {
  static func deserialize() -> ByteReader<Never> {
    fatalError("FIXME: Need to do this custom for the trailing objects")
  }

  var layout: some MetadataLayout {
    Metadata {
      GenericMetadataPatternLayout()

      /// The value-witness table.  Indirectable so that we can re-use tables
      /// from other libraries if that seems wise.
      RelativeIndirectablePointerLayout<ValueWitnessTableLayout>()
    }
    .withTrailingObjects {
      GenericMetadataPartialPatternLayout()
    }
  }
}

struct TypeGenericContextDescriptorHeaderLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout { 
    Metadata {
      /// The metadata instantiation cache.
      RelativeDirectPointerLayout<GenericMetadataInstantiationCacheLayout>()
      /// The default instantiation pattern.
      RelativeDirectPointerLayout<GenericMetadataPatternLayout>()
      /// The base header.  Must always be the final member.
      GenericContextDescriptorHeaderLayout()
    }
  }
}
