/// ForeignMetadata.swift
///
/// Copyright 2019, The SwiftGestalt Project.
///
/// This project is released under the MIT license, a copy of which is
/// available in the repository.

/// The structure of metadata for foreign types where the source
/// language doesn't provide any sort of more interesting metadata for
/// us to use.
struct ForeignTypeMetadataLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      SwiftMetadataLayout()
    }
  }
}

/// The structure of metadata objects for foreign class types.
/// A foreign class is a foreign type with reference semantics and
/// Swift-supported reference counting.  Generally this requires
/// special logic in the importer.
///
/// We assume for now that foreign classes are entirely opaque
/// to Swift introspection.
struct ForeignClassMetadataLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout { 
    Metadata {
      ForeignTypeMetadataLayout()
      /// An out-of-line description of the type.
      DirectPointer<ClassDescriptorLayout>()

      /// The superclass of the foreign class, if any.
      DirectPointer<ForeignClassMetadataLayout>()

      /// Reserved space.  For now, this should be zero-initialized.
      /// If this is used for anything in the future, at least some of these
      /// first bits should be flags.
      WordBufferLayout()
    }
  }
}
