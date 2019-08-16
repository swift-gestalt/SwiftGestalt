/// MetatypeMetadata.swift
///
/// Copyright 2019, The SwiftGestalt Project.
///
/// This project is released under the MIT license, a copy of which is
/// available in the repository.

/// The structure of metadata for metatypes.
struct MetatypeMetadata : MetadataLayout {
  var layout: some DerivedMetadataLayout { 
    Metadata {
      SwiftMetadataLayout()
      /// The type metadata for the element.
      DirectPointer<SwiftMetadataLayout>()
    }
  }
}
