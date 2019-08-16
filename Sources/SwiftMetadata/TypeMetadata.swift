/// TypeMetadata.swift
///
/// Copyright 2019, The SwiftGestalt Project.
///
/// This project is released under the MIT license, a copy of which is
/// available in the repository.

/// Kinds of type metadata/protocol conformance records.
enum TypeReferenceKind : UInt32 {
  /// The conformance is for a nominal type referenced directly
  /// getTypeDescriptor() points to the type context descriptor.
  case DirectTypeDescriptor = 0x00

  /// The conformance is for a nominal type referenced indirectly
  /// getTypeDescriptor() points to the type context descriptor.
  case IndirectTypeDescriptor = 0x01

  /// The conformance is for an Objective-C class that should be looked up
  /// by class name.
  case DirectObjCClassName = 0x02

  /// The conformance is for an Objective-C class that has no nominal type
  /// descriptor.
  /// getIndirectObjCClass() points to a variable that contains the pointer to
  /// the class object, which then requires a runtime call to get metadata.
  ///
  /// On platforms without Objective-C interoperability, this case is
  /// unused.
  case IndirectObjCClass = 0x03
}

struct TypeMetadataHeaderLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      ValueWitnessTableLayout()
    }
  }
}

struct TypeMetadataRecordLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout { 
    Metadata {
      Union {
        /// A direct reference to a nominal type descriptor.
        RelativeDirectPointerIntPairLayout<ContextDescriptorLayout, TypeReferenceKind>()
        /// An indirect reference to a nominal type descriptor.
        RelativeDirectPointerIntPairLayout<DirectPointer<ContextDescriptorLayout>, TypeReferenceKind>()
      }
    }
  }
}
