/// MetadataBounds.swift
///
/// Copyright 2019, The SwiftGestalt Project.
///
/// This project is released under the MIT license, a copy of which is
/// available in the repository.

/// Bounds for metadata objects.
struct MetadataBoundsLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout { 
    Metadata {
      /// The negative extent of the metadata, in words.
      Constant<UInt32>()

      /// The positive extent of the metadata, in words.
      Constant<UInt32>()
    }
  }
}
