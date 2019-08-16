/// TupleMetadata.swift
///
/// Copyright 2019, The SwiftGestalt Project.
///
/// This project is released under the MIT license, a copy of which is
/// available in the repository.

/// The structure of tuple type metadata.
struct TupleTypeMetadataLayout : MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      SwiftMetadataLayout()

      /// The number of elements.
      Constant<Int>()

      /// The labels string  see swift_getTupleTypeMetadata.
      DirectPointer<CString>()
    }
  }


  struct ElementLayout: MetadataLayout {
    var layout: some DerivedMetadataLayout {
      Metadata {
        /// The type of the element.
        DirectPointer<SwiftMetadataLayout>()

        /// The offset of the tuple element within the tuple.
        Constant<Int>()
      }
    }
  }
}
