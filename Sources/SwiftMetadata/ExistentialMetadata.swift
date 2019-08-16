/// ExistentialMetadata.swift
///
/// Copyright 2019, The SwiftGestalt Project.
///
/// This project is released under the MIT license, a copy of which is
/// available in the repository.

/// The possible physical representations of existential types.
enum ExistentialTypeRepresentation {
  /// The type uses an opaque existential representation.
  case opaque
  /// The type uses a class existential representation.
  case `class`
  /// The type uses the Error boxed existential representation.
  case error
}

struct ExistentialTypeFlags: OptionSet {
  var rawValue: UInt32

  static let numWitnessTablesMask  = ExistentialTypeFlags(rawValue: 0x00FFFFFF)
  static let classConstraintMask   = ExistentialTypeFlags(rawValue: 0x80000000)
  static let hasSuperclassMask     = ExistentialTypeFlags(rawValue: 0x40000000)
  static let specialProtocolMask   = ExistentialTypeFlags(rawValue: 0x3F000000)
  static let specialProtocolShift  = ExistentialTypeFlags(rawValue: 24)
}

/// The structure of existential type metadata.
struct ExistentialTypeMetadataLayout: MetadataLayout {
  static func deserialize() -> ByteReader<Never> {
    fatalError("FIXME: Need to do this custom for the trailing objects")
  }
  
  var layout: some MetadataLayout {
    Metadata {
      SwiftMetadataLayout()
      /// The number of witness tables and class-constrained-ness of the type.
      Flags<ExistentialTypeFlags>()

      /// The number of protocols.
      Constant<UInt32>()
    }
    .withTrailingObjects {
      ExistentialTypeMetadataLayout()
      DirectPointer<SwiftMetadataLayout>()
      ProtocolDescriptorRefLayout()
    }
  }
}

/// The basic layout of an existential metatype type.
struct ExistentialMetatypeContainerLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      DirectPointer<SwiftMetadataLayout>()
    }
  }
}

/// The structure of metadata for existential metatypes.
struct ExistentialMetatypeMetadataLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout { 
    Metadata {
      SwiftMetadataLayout()
      /// The type metadata for the element.
      DirectPointer<SwiftMetadataLayout>()

      /// The number of witness tables and class-constrained-ness of the
      /// underlying type.
      Flags<ExistentialTypeFlags>()
    }
  }
}
