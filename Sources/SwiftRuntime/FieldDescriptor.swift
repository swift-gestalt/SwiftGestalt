/// FieldDescriptor.swift
///
/// Copyright 2019, The SwiftGestalt Project.
///
/// This project is released under the MIT license, a copy of which is
/// available in the repository.

public enum FieldDescriptorKind: Int16 {
  // Swift nominal types.
  case `struct` = 0
  case `class`
  case `enum`

  // Fixed-size multi-payload enums have a special descriptor format that
  // encodes spare bits.
  //
  // FIXME: Actually implement this. For now, a descriptor with this kind
  // just means we also have a builtin descriptor from which we get the
  // size and alignment.
  case multiPayloadEnum

  // A Swift opaque protocol. There are no fields, just a record for the
  // type itself.
  case `protocol`

  // A Swift class-bound protocol.
  case classProtocol

  // An Objective-C protocol, which may be imported or defined in Swift.
  case objCProtocol

  // An Objective-C class, which may be imported or defined in Swift.
  // In the former case, field type metadata is not emitted, and
  // must be obtained from the Objective-C runtime.
  case objCClass
}

struct FieldDescriptorLayout: MetadataLayout {
  var layout: some DerivedMetadataLayout { 
    Metadata {
      // MangledTypeName
      RelativeDirectPointerLayout<CString>()
      // Superclass
      RelativeDirectPointerLayout<CString>()
      NewTypeConstant<FieldDescriptorKind>()
      // FieldRecordSize
      Constant<UInt16>()
      // NumFields
      Constant<UInt32>()
    }
  }
}

public struct FieldDescriptor: SwiftMetadata {
  typealias Layout = FieldDescriptorLayout


  public let mangledTypeName: String
  public let superclass: String
  public let kind: FieldDescriptorKind
  public let fieldRecordSize: Int
  public let numFields: Int
  public let fields: [FieldRecord]

  private init(
    mangledTypeName: String,
    superclass: String,
    kind: FieldDescriptorKind,
    fieldRecordSize: Int,
    numFields: Int,
    fields: [FieldRecord]
  ) {
    self.mangledTypeName = mangledTypeName
    self.superclass = superclass
    self.kind = kind
    self.fieldRecordSize = fieldRecordSize
    self.numFields = numFields
    self.fields = fields
  }

  public static func from(raw: UnsafeBufferPointer<Int8>) -> FieldDescriptor {
    fatalError()
    /*
    return raw.withMemoryRebound(to: RawFieldDescriptor.self, capacity: 1, { (ptr) -> FieldDescriptor in
      let buf = relativePointer(base: ptr, offset: ptr.pointee.mangledName) as UnsafePointer<Int8>
      let extent = extentOfSymbolicMangledName(buf)
      let mangledTypeName = _stdlib_demangleTypeName(buf, extent)
      let superclass = String(cString: relativePointer(base: ptr, offset: ptr.pointee.superclass + 4) as UnsafePointer<Int8>)
      let kind = Kind(rawValue: ptr.pointee.kind)!
      let fieldRecordSize = ptr.pointee.size
      let numFields = ptr.pointee.numberOfFields

      let fields = ptr.advanced(by: 1).withMemoryRebound(to: FieldRecord.RawFieldRecord.self, capacity: Int(numFields)) { (fieldPtr) -> [FieldRecord] in
        var fields = [FieldRecord]()
        for i in 0..<numFields {
          fields.append(FieldRecord.from(raw: fieldPtr.advanced(by: Int(i))))
        }
        return fields
      }

      return FieldDescriptor(
        mangledTypeName: mangledTypeName,
        superclass: superclass,
        kind: kind,
        fieldRecordSize: Int(fieldRecordSize),
        numFields: Int(numFields),
        fields: fields)
    })*/
  }
}

public struct FieldRecord {
  public struct Flags: OptionSet {
    public let rawValue: UInt32
    public init(rawValue: UInt32) {
      self.rawValue = rawValue
    }

    public typealias RawValue = UInt32

    public static let IsIndirectCase = Flags(rawValue: 1 << 0)
    public static let IsVar = Flags(rawValue: 1 << 1)
  }

  struct RawFieldRecord {
    var flags: UInt32
    var MangledTypeName: Int32
    var FieldName: Int32
  }

  public let flags: Flags
  public let mangledTypeName: String
  public let fieldName: String

  private init(flags: Flags, mangledTypeName: String, fieldName: String) {
    self.flags = flags
    self.mangledTypeName = mangledTypeName
    self.fieldName = fieldName
  }

  /*
  static func from(raw ptr: UnsafePointer<RawFieldRecord>) -> FieldRecord {
    let flags = Flags(rawValue: ptr.pointee.flags)
    let mangledTypeName: String
    if ptr.pointee.MangledTypeName == 0 {
      mangledTypeName = ""
    } else {
      let buf = relativePointer(base: ptr, offset: ptr.pointee.MangledTypeName + 4) as UnsafePointer<Int8>
      let off = extentOfSymbolicMangledName(buf)
      mangledTypeName = _stdlib_demangleTypeName(buf, off)
    }
    let nameBuf = relativePointer(base: ptr, offset: ptr.pointee.FieldName + 8) as UnsafePointer<Int8>
    let fieldName = String(cString: nameBuf)
    return FieldRecord(flags: flags, mangledTypeName: mangledTypeName, fieldName: fieldName)
  }*/
}

