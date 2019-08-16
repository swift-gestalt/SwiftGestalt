/// ValueMetadata.swift
///
/// Copyright 2019, The SwiftGestalt Project.
///
/// This project is released under the MIT license, a copy of which is
/// available in the repository.

/// The common structure of metadata for structs and enums.
struct ValueMetadataLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      SwiftMetadataLayout()
      /// An out-of-line description of the type.
      DirectPointer<ValueTypeDescriptorLayout>()
    }
  }
}

/// The structure of type metadata for structs.
struct StructMetadataLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      ValueMetadataLayout()

      // The first trailing field of struct metadata is always the generic
      // argument array.
    }
  }
}

/// The structure of type metadata for enums.
struct EnumMetadataLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout { 
    Metadata {
      ValueMetadataLayout()
    }
  }
}
