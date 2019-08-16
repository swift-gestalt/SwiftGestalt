/// MetadataInitialization.swift
///
/// Copyright 2019, The SwiftGestalt Project.
///
/// This project is released under the MIT license, a copy of which is
/// available in the repository.

/// The control structure for performing non-trivial initialization of
/// singleton foreign metadata.
struct ForeignMetadataInitializationLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      /// The completion function.  The pattern will always be null.
      RelativeDirectPointerLayout<MetadataCompleter>()
    }
  }
}


/// The cache structure for non-trivial initialization of singleton value
/// metadata.
struct SingletonMetadataCacheLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      /// Metadata
      DirectPointer<SwiftMetadataLayout>()

      /// The private cache data.
      WordBufferLayout()
    }
  }
}

/// A function for allocating metadata for a resilient class, calculating
/// the correct metadata size at runtime.
// using MetadataRelocator =
//   Metadata *(const TargetTypeContextDescriptor<InProcess> *type,
//              const TargetResilientClassMetadataPattern<InProcess> *pattern)
typealias MetadataRelocator = FunctionPointer<(TypeContextDescriptorLayout, ResilientClassMetadataPatternLayout), SwiftMetadataLayout>

/// An instantiation pattern for non-generic resilient class metadata.
///
/// Used for classes with resilient ancestry, that is, where at least one
/// ancestor is defined in a different resilience domain.
///
/// The hasResilientSuperclass() flag in the class context descriptor is
/// set in this case, and hasSingletonMetadataInitialization() must be
/// set as well.
///
/// The pattern is referenced from the SingletonMetadataInitialization
/// record in the class context descriptor.
struct ResilientClassMetadataPatternLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      /// A function that allocates metadata with the correct size at runtime.
      ///
      /// If this is null, the runtime instead calls swift_relocateClassMetadata(),
      /// passing in the class descriptor and this pattern.
      RelativeDirectPointerLayout<MetadataRelocator>()

      /// The heap-destructor function.
      RelativeDirectPointerLayout<HeapObjectDestroyer>()

      /// The ivar-destructor function.
      RelativeDirectPointerLayout<ClassIVarDestroyer>()

      /// The class flags.
      Flags<ClassFlags>()

      // The following fields are only present in ObjC interop.

      /// Our ClassROData.
      OpaqueRelativeDirectPointerLayout()

      /// Our metaclass.
      RelativeDirectPointerLayout<AnyClassMetadataLayout>()
    }
  }
}

/// The control structure for performing non-trivial initialization of
/// singleton value metadata, which is required when e.g. a non-generic
/// value type has a resilient component type.
struct SingletonMetadataInitializationLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout { 
    Metadata {

      /// The initialization cache.  Out-of-line because mutable.
      RelativeDirectPointerLayout<SingletonMetadataCacheLayout>()

      Union {
        /// The incomplete metadata, for structs, enums and classes without
        /// resilient ancestry.
        RelativeDirectPointerLayout<SwiftMetadataLayout>()

        /// If the class descriptor's hasResilientSuperclass() flag is set,
        /// this field instead points at a pattern used to allocate and
        /// initialize metadata for this class, since it's size and contents
        /// is not known at compile time.
        RelativeDirectPointerLayout<ResilientClassMetadataPatternLayout>()
      }

      /// The completion function.  The pattern will always be null, even
      /// for a resilient class.
      RelativeDirectPointerLayout<MetadataCompleter>()
    }
  }
}
