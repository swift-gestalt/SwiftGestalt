/// ValueTypeDescriptor.swift
///
/// Copyright 2019, The SwiftGestalt Project.
///
/// This project is released under the MIT license, a copy of which is
/// available in the repository.

struct ValueTypeDescriptorLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      TypeContextDescriptorLayout()

    }
  }
}

struct StructDescriptorLayout: MetadataLayout {
  static func deserialize() -> ByteReader<Never> {
    fatalError("FIXME: Need to do this custom for the trailing objects")
  }

  var layout: some MetadataLayout {
    Metadata {
      ValueTypeDescriptorLayout()
      /// The number of stored properties in the struct.
      /// If there is a field offset vector, this is its length.
      Constant<UInt32>()

      /// The offset of the field offset vector for this struct's stored
      /// properties in its metadata, if any. 0 means there is no field offset
      /// vector.
      Constant<UInt32>()
    }
    .withTrailingObjects {
      StructDescriptorLayout()
      TypeGenericContextDescriptorHeaderLayout()
      ForeignMetadataInitializationLayout()
      SingletonMetadataInitializationLayout()
    }
  }
}

struct EnumDescriptorLayout: MetadataLayout {
  static func deserialize() -> ByteReader<Never> {
    fatalError("FIXME: Need to do this custom for the trailing objects")
  }

  var layout: some MetadataLayout {
    Metadata {
      ValueTypeDescriptorLayout()

      /// The number of non-empty cases in the enum are in the low 24 bits
      /// the offset of the payload size in the metadata record in words,
      /// if any, is stored in the high 8 bits.
      Constant<UInt32>()

      /// The number of empty cases in the enum.
      Constant<UInt32>()
    }
    .withTrailingObjects {
      GenericContextDescriptorHeaderLayout()
      /*additional trailing objects*/
      ForeignMetadataInitializationLayout()
      SingletonMetadataInitializationLayout()
    }
  }
}
