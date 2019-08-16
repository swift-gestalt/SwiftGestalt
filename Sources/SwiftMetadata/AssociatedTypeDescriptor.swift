/// AssociatedTypeDescriptor.swift
///
/// Copyright 2019, The SwiftGestalt Project.
///
/// This project is released under the MIT license, a copy of which is
/// available in the repository.

public struct AssociatedTypeRecord: SwiftMetadata {
  typealias Layout = AssociatedTypeRecordLayout

  public let name: String
  public let substitutedTypeName: String

  private init(name: String, substitutedTypeName: String) {
    self.name = name
    self.substitutedTypeName = substitutedTypeName
  }

//  public static func from(raw ptr: UnsafePointer<RawAssociatedTypeRecord>) -> AssociatedTypeRecord {
//    let nameBuf = relativePointer(base: ptr, offset: ptr.pointee.name) as UnsafePointer<Int8>
//    let name = String(cString: nameBuf)
//
//    let subNameBuf = relativePointer(base: ptr, offset: ptr.pointee.substitutedTypeName + 4) as UnsafePointer<Int8>
//    let extent = extentOfSymbolicMangledName(subNameBuf)
//    let subName = _stdlib_demangleTypeName(subNameBuf, extent)
//    return AssociatedTypeRecord(name: name, substitutedTypeName: subName)
//  }
}

public struct AssociatedTypeDescriptor: SwiftMetadata {
  typealias Layout = AssociatedTypeDescriptorLayout

  public let conformingTypeName: String
  public let protocolTypeName: String
  public let associatedTypeCount: Int
  public let associatedTypeRecordSize: Int
  public let records: [AssociatedTypeRecord]

  private init(
    conformingTypeName: String,
    protocolTypeName: String,
    associatedTypeCount: Int,
    associatedTypeRecordSize: Int,
    records: [AssociatedTypeRecord]
  ) {
    self.conformingTypeName = conformingTypeName
    self.protocolTypeName = protocolTypeName
    self.associatedTypeCount = associatedTypeCount
    self.associatedTypeRecordSize = associatedTypeRecordSize
    self.records = records
  }

  public static func from(raw: UnsafeBufferPointer<Int8>) -> AssociatedTypeDescriptor {
    let t = Self.Layout.deserialize().run(on: raw)
    print(t.1)
    fatalError()
  }
}

struct AssociatedTypeDescriptorLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      // ConformingTypeName
      RelativeDirectPointerLayout<CString>()
      // ProtocolTypeName
      RelativeDirectPointerLayout<CString>()
      // NumAssociatedTypes
      Constant<UInt32>()
      // AssociatedTypeRecordSize
      Constant<UInt32>()
    }
  }
}

// Associated type records describe the mapping from an associated
// type to the type witness of a conformance.
struct AssociatedTypeRecordLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout {
    Metadata {
      // Name
      RelativeDirectPointerLayout<CString>()
      // SubstitutedTypeName
      RelativeDirectPointerLayout<CString>()
    }
  }
}

/*

public struct AssociatedTypeDescriptor {
  public struct RawAssociatedTypeDescriptor {
    var conformingTypeName: Int32
    var protocolTypeName: Int32
    var associatedTypeCount: UInt32
    var associatedTypeRecordSize: UInt32
  }

  public typealias Raw = RawAssociatedTypeDescriptor

  public let conformingTypeName: String
  public let protocolTypeName: String
  public let associatedTypeCount: Int
  public let associatedTypeRecordSize: Int
  public let records: [AssociatedTypeRecord]

  private init(
    conformingTypeName: String,
    protocolTypeName: String,
    associatedTypeCount: Int,
    associatedTypeRecordSize: Int,
    records: [AssociatedTypeRecord]
  ) {
    self.conformingTypeName = conformingTypeName
    self.protocolTypeName = protocolTypeName
    self.associatedTypeCount = associatedTypeCount
    self.associatedTypeRecordSize = associatedTypeRecordSize
    self.records = records
  }

  public static func from(raw: UnsafePointer<Int8>) -> AssociatedTypeDescriptor {
    return raw.withMemoryRebound(to: RawAssociatedTypeDescriptor.self, capacity: 1, { (ptr) -> AssociatedTypeDescriptor in
      let buf = relativePointer(base: ptr, offset: ptr.pointee.conformingTypeName) as UnsafePointer<Int8>
      let extent = extentOfSymbolicMangledName(buf)
      let conformingTypeName = _stdlib_demangleTypeName(buf, extent)

      let buf2 = relativePointer(base: ptr, offset: ptr.pointee.protocolTypeName + 4) as UnsafePointer<Int8>
      let extent2 = extentOfSymbolicMangledName(buf2)
      let protocolTypeName = _stdlib_demangleTypeName(buf2, extent2)
      let associatedTypeCount = ptr.pointee.associatedTypeCount
      let recordSize = ptr.pointee.associatedTypeRecordSize

      let fields = ptr.advanced(by: 1).withMemoryRebound(to: AssociatedTypeRecord.RawAssociatedTypeRecord.self, capacity: Int(recordSize)) { (fieldPtr) -> [AssociatedTypeRecord] in
        var fields = [AssociatedTypeRecord]()
        for i in 0..<associatedTypeCount {
//          fields.append(AssociatedTypeRecord.from(raw: fieldPtr.advanced(by: Int(i))))
        }
        return fields
      }

      return AssociatedTypeDescriptor(
        conformingTypeName: conformingTypeName,
        protocolTypeName: protocolTypeName,
        associatedTypeCount: Int(associatedTypeCount),
        associatedTypeRecordSize: Int(recordSize),
        records: fields)
    })
  }
}

*/
