/// ProtocolDescriptor.swift
///
/// Copyright 2019, The SwiftGestalt Project.
///
/// This project is released under the MIT license, a copy of which is
/// available in the repository.

/// A protocol descriptor.
///
/// Protocol descriptors contain information about the contents of a protocol:
/// it's name, requirements, requirement signature, context, and so on. They
/// are used both to identify a protocol and to reason about its contents.
///
/// Only Swift protocols are defined by a protocol descriptor, whereas
/// Objective-C (including protocols defined in Swift as @objc) use the
/// Objective-C protocol layout.
struct ProtocolDescriptorLayout: MetadataLayout {
  static func deserialize() -> ByteReader<Never> {
    fatalError("FIXME: Need to do this custom for the trailing objects")
  }
  
  var layout: some MetadataLayout {
    Metadata {
      ContextDescriptorLayout()
      /// The name of the protocol.
      RelativeDirectPointerLayout<CString>()

      /// The number of generic requirements in the requirement signature of the
      /// protocol.
      Constant<UInt32>()

      /// The number of requirements in the protocol.
      /// If any requirements beyond MinimumWitnessTableSizeInWords are present
      /// in the witness table template, they will be not be overwritten with
      /// defaults.
      Constant<UInt32>()

      /// Associated type names, as a space-separated list in the same order
      /// as the requirements.
      RelativeDirectPointerLayout<CString>()
    }
    .withTrailingObjects {
      ProtocolDescriptorLayout()
      GenericRequirementDescriptorLayout()
      ProtocolRequirementLayout()
    }
  }
}

/// The structure of a protocol reference record.
struct ProtocolRecordLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      /// The protocol referenced.
      ///
      /// The remaining low bit is reserved for future use.
      RelativeIndirectablePointerIntPairLayout<ProtocolDescriptorLayout, Bool>()
    }
  }
}

/// Header containing information about the resilient witnesses in a
/// protocol conformance descriptor.
struct ResilientWitnessesHeaderLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      // NumWitnesses
      Constant<UInt32>()
    }
  }
}

/// A reference to a type.
struct TypeReferenceLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      Union {
        /// A direct reference to a TypeContextDescriptor or ProtocolDescriptor.
        RelativeDirectPointerLayout<ContextDescriptorLayout>()

        /// An indirect reference to a TypeContextDescriptor or ProtocolDescriptor.
        RelativeDirectPointerLayout<DirectPointer<ContextDescriptorLayout>>()

        /// An indirect reference to an Objective-C class.
        RelativeDirectPointerLayout<DirectPointer<ClassMetadataLayout>>()

        /// A direct reference to an Objective-C class name.
        RelativeDirectPointerLayout<CString>()
      }
    }
  }
}

struct ConformanceFlags: OptionSet {
  var rawValue: UInt32

  static let UnusedLowBits = ConformanceFlags(rawValue: 0x07)
  static let TypeMetadataKindMask = ConformanceFlags(rawValue: 0x7 << 3)
  static let TypeMetadataKindShift = ConformanceFlags(rawValue: 3)
  static let IsRetroactiveMask = ConformanceFlags(rawValue: 0x01 << 6)
  static let IsSynthesizedNonUniqueMask = ConformanceFlags(rawValue: 0x01 << 7)
  static let NumConditionalRequirementsMask = ConformanceFlags(rawValue: 0xFF << 8)
  static let NumConditionalRequirementsShift = ConformanceFlags(rawValue: 8)
  static let HasResilientWitnessesMask = ConformanceFlags(rawValue: 0x01 << 16)
  static let HasGenericWitnessTableMask = ConformanceFlags(rawValue: 0x01 << 17)
}

/// The structure of a protocol conformance.
///
/// This contains enough static information to recover the witness table for a
/// type's conformance to a protocol.
struct ProtocolConformanceDescriptorLayout: MetadataLayout {
  static func deserialize() -> ByteReader<Never> {
    fatalError("FIXME: Need to do this custom for the trailing objects")
  }
  
  var layout: some MetadataLayout {
    Metadata {
      /// The protocol being conformed to.
      RelativeIndirectablePointerLayout<ProtocolDescriptorLayout>()

      // Some description of the type that conforms to the protocol.
      TypeReferenceLayout()

      /// The witness table pattern, which may also serve as the witness table.
      RelativeDirectPointerLayout<WitnessTableLayout>()

      /// Various flags, including the kind of conformance.
      Flags<ConformanceFlags>()
    }
    .withTrailingObjects {
      ProtocolConformanceDescriptorLayout()
      RelativeIndirectablePointerLayout<ContextDescriptorLayout>()
      GenericRequirementDescriptorLayout()
      ResilientWitnessesHeaderLayout()
      ResilientWitnessLayout()
      GenericWitnessTableLayout()
    }
  }
}
