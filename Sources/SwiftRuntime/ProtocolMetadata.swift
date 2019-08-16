/// ProtocolMetadata.swift
///
/// Copyright 2019, The SwiftGestalt Project.
///
/// This project is released under the MIT license, a copy of which is
/// available in the repository.

/// Layout of a small prefix of an Objective-C protocol, used only to
/// directly extract the name of the protocol.
struct ObjCProtocolPrefixLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      /// Unused by the Swift runtime.
      WordBufferLayout()

      /// The mangled name of the protocol.
      DirectPointer<CString>()
    }
  }
}

/// A reference to a protocol within the runtime, which may be either
/// a Swift protocol or (when Objective-C interoperability is enabled) an
/// Objective-C protocol.
///
/// This type always contains a single target pointer, whose lowest bit is
/// used to distinguish between a Swift protocol referent and an Objective-C
/// protocol referent.
struct ProtocolDescriptorRefLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      /// A direct pointer to a protocol descriptor for either an Objective-C
      /// protocol (if the low bit is set) or a Swift protocol (if the low bit
      /// is clear).
      Constant<UInt>()
    }
  }
}

struct ProtocolRequirementFlags: OptionSet {
  var rawValue: UInt32

  enum Kind: UInt8 {
    case baseProtocol                         = 0
    case nethod                               = 1
    case initializer                          = 2
    case getter                               = 3
    case setter                               = 4
    case readCoroutine                        = 5
    case modifyCoroutine                      = 6
    case associatedTypeAccessFunction         = 7
    case associatedConformanceAccessFunction  = 8
  }


  static let kindMask = ProtocolRequirementFlags(rawValue: 0x0F)
  static let isInstanceMask = ProtocolRequirementFlags(rawValue: 0x10)
}

/// A protocol requirement descriptor. This describes a single protocol
/// requirement in a protocol descriptor. The index of the requirement in
/// the descriptor determines the offset of the witness in a witness table
/// for this protocol.
struct ProtocolRequirementLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      Flags<ProtocolRequirementFlags>()

      /// The optional default implementation of the protocol.
      OpaqueRelativeDirectPointerLayout()
    }
  }
}

/// A witness table for a protocol.
///
/// With the exception of the initial protocol conformance descriptor,
/// the layout of a witness table is dependent on the protocol being
/// represented.
struct WitnessTableLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      /// The protocol conformance descriptor from which this witness table
      /// was generated.
      DirectPointer<ProtocolConformanceDescriptorLayout>()
    }
  }
}

/// The control structure of a generic or resilient protocol
/// conformance witness.
///
/// Resilient conformances must use a pattern where new requirements
/// with default implementations can be added and the order of existing
/// requirements can be changed.
///
/// This is accomplished by emitting an order-independent series of
/// relative pointer pairs, consisting of a protocol requirement together
/// with a witness. The requirement is identified by an indirectable relative
/// pointer to the protocol requirement descriptor.
struct ResilientWitnessLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      // Requirement
      RelativeIndirectablePointerLayout<ProtocolRequirementLayout>()
      // Witness
      OpaqueRelativeDirectPointerLayout()
    }
  }
}

struct ResilientWitnessTableLayout: MetadataLayout {
  static func deserialize() -> ByteReader<Never> {
    fatalError("FIXME: Need to do this custom for the trailing objects")
  }
  
  var layout: some MetadataLayout {
    Metadata {
      // NumWitnesses
      Constant<UInt32>()
    }
    .withTrailingObjects {
      ResilientWitnessTableLayout()
      ResilientWitnessLayout()
    }
  }
}

/// The control structure of a generic or resilient protocol
/// conformance, which is embedded in the protocol conformance descriptor.
///
/// Witness tables need to be instantiated at runtime in these cases:
/// - For a generic conforming type, associated type requirements might be
///   dependent on the conforming type.
/// - For a type conforming to a resilient protocol, the runtime size of
///   the witness table is not known because default requirements can be
///   added resiliently.
///
/// One per conformance.
struct GenericWitnessTableLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout { 
    Metadata {
      /// The size of the witness table in words.  This amount is copied from
      /// the witness table template into the instantiated witness table.
      Constant<UInt16>()

      /// The amount of private storage to allocate before the address point,
      /// in words. This memory is zeroed out in the instantiated witness table
      /// template.
      ///
      /// The low bit is used to indicate whether this witness table is known
      /// to require instantiation.
      Constant<UInt16>()

      /// Private data for the instantiator.  Out-of-line so that the rest
      /// of this structure can be constant.
      RelativeDirectPointerLayout<WordBuffer16Layout>()
    }
  }
}
