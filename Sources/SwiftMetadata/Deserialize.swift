/// Deserialize.swift
///
/// Copyright 2019, The SwiftGestalt Project.
///
/// This project is released under the MIT license, a copy of which is
/// available in the repository.

import Foundation

public typealias ByteString = UnsafeBufferPointer<Int8>

public final class Composer {
  public func deserialize<A>(using gen : ByteReader<A>) -> A {
    fatalError()
  }
}

public struct ByteReader<A> {
  enum Command {
    case readBytes(Int, (ByteString) -> A)
  }

  let command: Command

  func run(on buffer: ByteString) -> (ByteString, A) {
    switch self.command {
    case let .readBytes(n, act):
      precondition(buffer.count >= n)
      let val = act(ByteString(start: buffer.baseAddress, count: n))
      let rebase = ByteString(start: buffer.baseAddress?.advanced(by: n), count: buffer.count - n)
      return (rebase, val)
    }
  }

  public static func byReadingBytes(_ n : Int, _ f : @escaping (ByteString) -> A) -> ByteReader<A> {
    return ByteReader(command: .readBytes(n, f))
  }

  public static func compose(build: @escaping (Composer) -> A) -> ByteReader<A> {
    fatalError()
  }

  /// Applies a function to the result of deserializing a value.
  public func map<B>(_ f : @escaping (A) -> B) -> ByteReader<B> {
    fatalError()
  }
}

protocol DerivedMetadataLayout: MetadataLayout & _MetadataRoot {}

extension Metadata: DerivedMetadataLayout {}

extension MetadataLayout
  where Self.Body: _MetadataRoot, Self.Body: MetadataLayout, Self.Output == Self.Body.Output
{
  static func deserialize() -> ByteReader<Self.Body.Output> {
    return Self.Body.deserialize()
  }
}

extension Metadata: MetadataLayout {
  public typealias Output = Content.Output

  public static func deserialize() -> ByteReader<Self.Output> {
    return Self.Content.deserialize()
  }
}

extension TrailingMetadata: MetadataLayout
  where Content: MetadataLayout, TrailingContent: MetadataLayout
{
  public typealias Output = (Content.Output, TrailingContent.Output)

  public static func deserialize() -> ByteReader<Output> {
    return ByteReader.compose { builder in
      let left = builder.deserialize(using: Content.deserialize())
      let right = builder.deserialize(using: TrailingContent.deserialize())
      return (left, right)
    }
  }
}

extension FunctionPointer: MetadataLayout {
  public typealias Output = (In) -> Out

  public static func deserialize() -> ByteReader<Output> {
    fatalError()
  }
}

extension Int8 : MetadataLayout {
  public var layout: Never {
    fatalError()
  }

  public static func deserialize() -> ByteReader<Int8> {
    return ByteReader.byReadingBytes(1) { uu in uu[0] }
  }
}

extension Int16 : MetadataLayout {
  public var layout: Never {
    fatalError()
  }

  public static func deserialize() -> ByteReader<Int16> {
    return ByteReader.byReadingBytes(2) { (uu : ByteString) in
      return Int16(uu[0]) << 8
          |  Int16(uu[1])
    }
  }
}

extension Int32 : MetadataLayout {
  public var layout: Never {
    fatalError()
  }

  public static func deserialize() -> ByteReader<Int32> {
    return ByteReader.byReadingBytes(4) { (uu : ByteString) in
      return (Int32(uu[0]) << 24) as Int32
          |  (Int32(uu[1]) << 16) as Int32
          |  (Int32(uu[2]) << 8) as Int32
          |  Int32(uu[3])
    }
  }
}

extension Int64 : MetadataLayout {
  public var layout: Never {
    fatalError()
  }

  public static func deserialize() -> ByteReader<Int64> {
    return ByteReader.byReadingBytes(8) { (uu : ByteString) in
      return (Int64(uu[0]) << 56) as Int64
          |  (Int64(uu[1]) << 48) as Int64
          |  (Int64(uu[2]) << 40) as Int64
          |  (Int64(uu[3]) << 32) as Int64
          |  (Int64(uu[4]) << 24) as Int64
          |  (Int64(uu[5]) << 16) as Int64
          |  (Int64(uu[6]) << 8) as Int64
          |  Int64(uu[7])
    }
  }
}

extension Int : MetadataLayout {
  public var layout: Never {
    fatalError()
  }

  public static func deserialize() -> ByteReader<Int> {
    if MemoryLayout<Int>.size == 8 {
      return Int64.deserialize().map(Int.init)
    } else if MemoryLayout<Int>.size == 4 {
      return Int32.deserialize().map(Int.init)
    } else {
      fatalError()
    }
  }
}

extension UInt8 : MetadataLayout {
  public var layout: Never {
    fatalError()
  }

  public static func deserialize() -> ByteReader<UInt8> {
    return ByteReader.byReadingBytes(1) { uu in UInt8(bitPattern: uu[0]) }
  }
}

extension UInt16 : MetadataLayout {
  public var layout: Never {
    fatalError()
  }

  public static func deserialize() -> ByteReader<UInt16> {
    return ByteReader.byReadingBytes(2) { (uu : ByteString) in
      return UInt16(uu[0]) << 8
          |  UInt16(uu[1])
    }
  }
}

extension UInt32 : MetadataLayout {
  public var layout: Never {
    fatalError()
  }

  public static func deserialize() -> ByteReader<UInt32> {
    return ByteReader.byReadingBytes(4) { (uu : ByteString) in
      return (UInt32(uu[0]) << 24) as UInt32
          |  (UInt32(uu[1]) << 16) as UInt32
          |  (UInt32(uu[2]) << 8) as UInt32
          |  UInt32(uu[3])
    }
  }
}

extension UInt64 : MetadataLayout {
  public var layout: Never {
    fatalError()
  }

  public static func deserialize() -> ByteReader<UInt64> {
    return ByteReader.byReadingBytes(8) { (uu : ByteString) in
      return (UInt64(uu[0]) << 56) as UInt64
          |  (UInt64(uu[1]) << 48) as UInt64
          |  (UInt64(uu[2]) << 40) as UInt64
          |  (UInt64(uu[3]) << 32) as UInt64
          |  (UInt64(uu[4]) << 24) as UInt64
          |  (UInt64(uu[5]) << 16) as UInt64
          |  (UInt64(uu[6]) << 8) as UInt64
          |  UInt64(uu[7])
    }
  }
}

extension UInt : MetadataLayout {
  public var layout: Never {
    fatalError()
  }

  public static func deserialize() -> ByteReader<UInt> {
    if MemoryLayout<UInt>.size == 8 {
      return UInt64.deserialize().map(UInt.init)
    } else if MemoryLayout<UInt>.size == 4 {
      return UInt32.deserialize().map(UInt.init)
    } else {
      fatalError()
    }
  }
}

extension Float : MetadataLayout {
  public var layout: Never {
    fatalError()
  }

  public static func deserialize() -> ByteReader<Float> {
    return UInt32.deserialize().map(Float.init(bitPattern:))
  }
}

extension Double : MetadataLayout {
  public var layout: Never {
    fatalError()
  }

  public static func deserialize() -> ByteReader<Double> {
    return UInt64.deserialize().map(Double.init(bitPattern:))
  }
}

extension Constant: MetadataLayout
  where Value: MetadataLayout
{
  public typealias Output = Value.Output

  public static func deserialize() -> ByteReader<Output> {
    return Value.deserialize()
  }
}

extension NewTypeConstant: MetadataLayout
  where Value.RawValue: MetadataLayout, Value.RawValue == Value.RawValue.Output
{
  public typealias Output = Value

  public static func deserialize() -> ByteReader<Output> {
    return ByteReader.compose { builder in
      let value = builder.deserialize(using: Value.RawValue.deserialize())
      return Value.init(rawValue: value)!
    }
  }
}

extension Flags: MetadataLayout
  where Interpreted.RawValue: MetadataLayout, Interpreted.RawValue == Interpreted.RawValue.Output
{
  public typealias Output = Interpreted

  public static func deserialize() -> ByteReader<Output> {
    return ByteReader.compose { builder in
      let value = builder.deserialize(using: Interpreted.RawValue.deserialize())
      return Interpreted.init(rawValue: value)!
    }
  }
}

extension DirectPointer: MetadataLayout {
  public typealias Output = UnsafePointer<Pointee>

  public static func deserialize() -> ByteReader<Output> {
    fatalError()
  }
}

extension WordBufferLayout: MetadataLayout {
  public typealias Output = UnsafeRawPointer

  public static func deserialize() -> ByteReader<Output> {
    fatalError()
  }
}

extension WordBuffer2Layout: MetadataLayout {
  public typealias Output = (UnsafeRawPointer, UnsafeRawPointer)

  public static func deserialize() -> ByteReader<Output> {
    fatalError()
  }
}

extension WordBuffer4Layout: MetadataLayout {
  public typealias Output = (UnsafeRawPointer, UnsafeRawPointer, UnsafeRawPointer, UnsafeRawPointer)

  public static func deserialize() -> ByteReader<Output> {
    fatalError()
  }
}

extension WordBuffer16Layout: MetadataLayout {
  public typealias Output = (
    UnsafeRawPointer, UnsafeRawPointer, UnsafeRawPointer, UnsafeRawPointer,
    UnsafeRawPointer, UnsafeRawPointer, UnsafeRawPointer, UnsafeRawPointer,
    UnsafeRawPointer, UnsafeRawPointer, UnsafeRawPointer, UnsafeRawPointer,
    UnsafeRawPointer, UnsafeRawPointer, UnsafeRawPointer, UnsafeRawPointer
  )

  public static func deserialize() -> ByteReader<Output> {
    fatalError()
  }
}

extension Never: MetadataLayout {
  public static func deserialize() -> ByteReader<Never> {
    fatalError()
  }
}

extension CString: MetadataLayout {
  public typealias Output = String

  public static func deserialize() -> ByteReader<Output> {
    fatalError()
  }
}

extension RelativeDirectPointerLayout: MetadataLayout {
  public typealias Output = UnsafePointer<Pointee>

  public static func deserialize() -> ByteReader<Output> {
    fatalError()
  }
}

extension RelativeIndirectablePointerLayout: MetadataLayout {
  public typealias Output = UnsafePointer<Pointee>

  public static func deserialize() -> ByteReader<Output> {
    fatalError()
  }
}

extension RelativeDirectPointerIntPairLayout: MetadataLayout {
  public typealias Output = UnsafePointer<Pointee>

  public static func deserialize() -> ByteReader<Output> {
    fatalError()
  }
}

extension RelativeIndirectablePointerIntPairLayout: MetadataLayout {
  public typealias Output = UnsafePointer<Pointee>

  public static func deserialize() -> ByteReader<Output> {
    fatalError()
  }
}

extension OpaqueRelativeDirectPointerLayout: MetadataLayout {
  public typealias Output = OpaquePointer

  public static func deserialize() -> ByteReader<Output> {
    fatalError()
  }
}

public struct UnionView<T> {

}

extension Union: MetadataLayout {
  public typealias Output = UnionView<Content.Output>


  public static func deserialize() -> ByteReader<Output> {
    fatalError()
  }
}

extension TupleMetadataLayout: MetadataLayout
  where T: MetadataLayout, U: MetadataLayout
{
  public typealias Output = (T.Output, U.Output)

  public static func deserialize() -> ByteReader<(T.Output, U.Output)> {
    return ByteReader.compose { builder in
      let one = builder.deserialize(using: T.deserialize())
      let two = builder.deserialize(using: U.deserialize())
      return (one, two)
    }
  }
}


extension TripleMetadataLayout: MetadataLayout
  where T: MetadataLayout, U: MetadataLayout, V: MetadataLayout
{
  public typealias Output = (T.Output, U.Output, V.Output)

  public static func deserialize() -> ByteReader<(T.Output, U.Output, V.Output)> {
    return ByteReader.compose { builder in
      let one = builder.deserialize(using: T.deserialize())
      let two = builder.deserialize(using: U.deserialize())
      let three = builder.deserialize(using: V.deserialize())
      return (one, two, three)
    }
  }
}



extension QuadrupleMetadataLayout: MetadataLayout
  where T: MetadataLayout, U: MetadataLayout, V: MetadataLayout, W: MetadataLayout
{
  public typealias Output = (T.Output, U.Output, V.Output, W.Output)

  public static func deserialize() -> ByteReader<(T.Output, U.Output, V.Output, W.Output)> {
    return ByteReader.compose { builder in
      let one = builder.deserialize(using: T.deserialize())
      let two = builder.deserialize(using: U.deserialize())
      let three = builder.deserialize(using: V.deserialize())
      let four = builder.deserialize(using: W.deserialize())
      return (one, two, three, four)
    }
  }
}



extension QuintupleMetadataLayout: MetadataLayout
  where T: MetadataLayout, U: MetadataLayout, V: MetadataLayout, W: MetadataLayout, X: MetadataLayout
{
  public typealias Output = (T.Output, U.Output, V.Output, W.Output, X.Output)


  public static func deserialize() -> ByteReader<(T.Output, U.Output, V.Output, W.Output, X.Output)> {
    return ByteReader.compose { builder in
      let one = builder.deserialize(using: T.deserialize())
      let two = builder.deserialize(using: U.deserialize())
      let three = builder.deserialize(using: V.deserialize())
      let four = builder.deserialize(using: W.deserialize())
      let five = builder.deserialize(using: X.deserialize())

      return (one, two, three, four, five)
    }
  }

}



extension SextupleMetadataLayout: MetadataLayout
  where T: MetadataLayout, U: MetadataLayout, V: MetadataLayout, W: MetadataLayout, X: MetadataLayout, Y: MetadataLayout
{
  public typealias Output = (T.Output, U.Output, V.Output, W.Output, X.Output, Y.Output)


  public static func deserialize() -> ByteReader<(T.Output, U.Output, V.Output, W.Output, X.Output, Y.Output)> {
    return ByteReader.compose { builder in
      let one = builder.deserialize(using: T.deserialize())
      let two = builder.deserialize(using: U.deserialize())
      let three = builder.deserialize(using: V.deserialize())
      let four = builder.deserialize(using: W.deserialize())
      let five = builder.deserialize(using: X.deserialize())
      let six = builder.deserialize(using: Y.deserialize())

      return (one, two, three, four, five, six)
    }
  }

}


extension SeptupleMetadataLayout: MetadataLayout
  where T: MetadataLayout, U: MetadataLayout, V: MetadataLayout, W: MetadataLayout, X: MetadataLayout, Y: MetadataLayout, Z: MetadataLayout
{
  public typealias Output = (T.Output, U.Output, V.Output, W.Output, X.Output, Y.Output, Z.Output)


  public static func deserialize() -> ByteReader<(T.Output, U.Output, V.Output, W.Output, X.Output, Y.Output, Z.Output)> {
    return ByteReader.compose { builder in
      let one = builder.deserialize(using: T.deserialize())
      let two = builder.deserialize(using: U.deserialize())
      let three = builder.deserialize(using: V.deserialize())
      let four = builder.deserialize(using: W.deserialize())
      let five = builder.deserialize(using: X.deserialize())
      let six = builder.deserialize(using: Y.deserialize())
      let seven = builder.deserialize(using: Z.deserialize())

      return (one, two, three, four, five, six, seven)
    }
  }

}

extension OctupleMetadataLayout: MetadataLayout
  where T: MetadataLayout, U: MetadataLayout, V: MetadataLayout, W: MetadataLayout, X: MetadataLayout, Y: MetadataLayout, Z: MetadataLayout, A: MetadataLayout
{
  public typealias Output = (T.Output, U.Output, V.Output, W.Output, X.Output, Y.Output, Z.Output, A.Output)


  public static func deserialize() -> ByteReader<(T.Output, U.Output, V.Output, W.Output, X.Output, Y.Output, Z.Output, A.Output)> {
    return ByteReader.compose { builder in
      let one = builder.deserialize(using: T.deserialize())
      let two = builder.deserialize(using: U.deserialize())
      let three = builder.deserialize(using: V.deserialize())
      let four = builder.deserialize(using: W.deserialize())
      let five = builder.deserialize(using: X.deserialize())
      let six = builder.deserialize(using: Y.deserialize())
      let seven = builder.deserialize(using: Z.deserialize())
      let eight = builder.deserialize(using: A.deserialize())

      return (one, two, three, four, five, six, seven, eight)
    }
  }
}

extension NontupleMetadataLayout: MetadataLayout
  where T: MetadataLayout, U: MetadataLayout, V: MetadataLayout, W: MetadataLayout, X: MetadataLayout, Y: MetadataLayout, Z: MetadataLayout, A: MetadataLayout, B: MetadataLayout
{
  public typealias Output = (T.Output, U.Output, V.Output, W.Output, X.Output, Y.Output, Z.Output, A.Output, B.Output)


  public static func deserialize() -> ByteReader<(T.Output, U.Output, V.Output, W.Output, X.Output, Y.Output, Z.Output, A.Output, B.Output)> {
    return ByteReader.compose { builder in
      let one = builder.deserialize(using: T.deserialize())
      let two = builder.deserialize(using: U.deserialize())
      let three = builder.deserialize(using: V.deserialize())
      let four = builder.deserialize(using: W.deserialize())
      let five = builder.deserialize(using: X.deserialize())
      let six = builder.deserialize(using: Y.deserialize())
      let seven = builder.deserialize(using: Z.deserialize())
      let eight = builder.deserialize(using: A.deserialize())
      let nine = builder.deserialize(using: B.deserialize())

      return (one, two, three, four, five, six, seven, eight, nine)
    }
  }
}

extension DectupleMetadataLayout: MetadataLayout
  where T: MetadataLayout, U: MetadataLayout, V: MetadataLayout, W: MetadataLayout, X: MetadataLayout, Y: MetadataLayout, Z: MetadataLayout, A: MetadataLayout, B: MetadataLayout, C: MetadataLayout
{
  public typealias Output = (T.Output, U.Output, V.Output, W.Output, X.Output, Y.Output, Z.Output, A.Output, B.Output, C.Output)


  public static func deserialize() -> ByteReader<(T.Output, U.Output, V.Output, W.Output, X.Output, Y.Output, Z.Output, A.Output, B.Output, C.Output)> {
    return ByteReader.compose { builder in
      let one = builder.deserialize(using: T.deserialize())
      let two = builder.deserialize(using: U.deserialize())
      let three = builder.deserialize(using: V.deserialize())
      let four = builder.deserialize(using: W.deserialize())
      let five = builder.deserialize(using: X.deserialize())
      let six = builder.deserialize(using: Y.deserialize())
      let seven = builder.deserialize(using: Z.deserialize())
      let eight = builder.deserialize(using: A.deserialize())
      let nine = builder.deserialize(using: B.deserialize())
      let ten = builder.deserialize(using: C.deserialize())

      return (one, two, three, four, five, six, seven, eight, nine, ten)
    }
  }
}

extension UndecupleMetadataLayout: MetadataLayout
  where T: MetadataLayout, U: MetadataLayout, V: MetadataLayout, W: MetadataLayout, X: MetadataLayout, Y: MetadataLayout, Z: MetadataLayout, A: MetadataLayout, B: MetadataLayout, C: MetadataLayout, D: MetadataLayout
{
  public typealias Output = (T.Output, U.Output, V.Output, W.Output, X.Output, Y.Output, Z.Output, A.Output, B.Output, C.Output, D.Output)


  public static func deserialize() -> ByteReader<(T.Output, U.Output, V.Output, W.Output, X.Output, Y.Output, Z.Output, A.Output, B.Output, C.Output, D.Output)> {
    return ByteReader.compose { builder in
      let one = builder.deserialize(using: T.deserialize())
      let two = builder.deserialize(using: U.deserialize())
      let three = builder.deserialize(using: V.deserialize())
      let four = builder.deserialize(using: W.deserialize())
      let five = builder.deserialize(using: X.deserialize())
      let six = builder.deserialize(using: Y.deserialize())
      let seven = builder.deserialize(using: Z.deserialize())
      let eight = builder.deserialize(using: A.deserialize())
      let nine = builder.deserialize(using: B.deserialize())
      let ten = builder.deserialize(using: C.deserialize())
      let eleven = builder.deserialize(using: D.deserialize())

      return (one, two, three, four, five, six, seven, eight, nine, ten, eleven)
    }
  }
}
