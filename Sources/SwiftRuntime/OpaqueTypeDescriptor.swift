/// OpaqueTypeDescriptor.swift
///
/// Copyright 2019, The SwiftGestalt Project.
///
/// This project is released under the MIT license, a copy of which is
/// available in the repository.

struct OpaqueTypeDescriptorLayout: MetadataLayout {
  static func deserialize() -> ByteReader<Never> {
    fatalError("FIXME: Need to do this custom for the trailing objects")
  }
  
  var layout: some MetadataLayout {
    Metadata {
      ContextDescriptorLayout()
    }.withTrailingObjects {
      GenericContextDescriptorHeaderLayout()
      RelativeDirectPointerLayout<CChar>()
    }
  }
}

