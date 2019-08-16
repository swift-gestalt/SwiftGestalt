/// LayoutDSL.swift
///
/// Copyright 2019, The SwiftGestalt Project.
///
/// This project is released under the MIT license, a copy of which is
/// available in the repository.

@_functionBuilder
public struct MetadataDescriptionBuilder { }

extension MetadataDescriptionBuilder {
  public static func buildBlock<Content>(_ content: Content) -> Content where Content : MetadataLayout {
    return content
  }
}

extension MetadataDescriptionBuilder {

  public static func buildBlock<C0, C1>(_ c0: C0, _ c1: C1) -> TupleMetadataLayout<C0, C1>
    where C0 : MetadataLayout , C1 : MetadataLayout
  {
    return TupleMetadataLayout((c0, c1))
  }
}

extension MetadataDescriptionBuilder {

  public static func buildBlock<C0, C1, C2>(_ c0: C0, _ c1: C1, _ c2: C2) -> TripleMetadataLayout<C0, C1, C2>
    where C0 : MetadataLayout , C1 : MetadataLayout , C2 : MetadataLayout
  {
    return TripleMetadataLayout((c0, c1, c2))
  }
}

extension MetadataDescriptionBuilder {

  public static func buildBlock<C0, C1, C2, C3>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3) -> QuadrupleMetadataLayout<C0, C1, C2, C3>
    where C0 : MetadataLayout , C1 : MetadataLayout , C2 : MetadataLayout , C3 : MetadataLayout
  {
    return QuadrupleMetadataLayout((c0, c1, c2, c3))
  }
}

extension MetadataDescriptionBuilder {

  public static func buildBlock<C0, C1, C2, C3, C4>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4) -> QuintupleMetadataLayout<C0, C1, C2, C3, C4>
    where C0 : MetadataLayout , C1 : MetadataLayout , C2 : MetadataLayout , C3 : MetadataLayout , C4 : MetadataLayout
  {
    return QuintupleMetadataLayout((c0, c1, c2, c3, c4))
  }
}

extension MetadataDescriptionBuilder {

  public static func buildBlock<C0, C1, C2, C3, C4, C5>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5) -> SextupleMetadataLayout<C0, C1, C2, C3, C4, C5>
    where C0 : MetadataLayout , C1 : MetadataLayout , C2 : MetadataLayout , C3 : MetadataLayout , C4 : MetadataLayout , C5 : MetadataLayout
  {
    return SextupleMetadataLayout((c0, c1, c2, c3, c4, c5))
  }
}

extension MetadataDescriptionBuilder {

  public static func buildBlock<C0, C1, C2, C3, C4, C5, C6>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6) -> SeptupleMetadataLayout<C0, C1, C2, C3, C4, C5, C6>
    where C0 : MetadataLayout , C1 : MetadataLayout , C2 : MetadataLayout , C3 : MetadataLayout , C4 : MetadataLayout , C5 : MetadataLayout , C6 : MetadataLayout
  {
    return SeptupleMetadataLayout((c0, c1, c2, c3, c4, c5, c6))
  }
}

extension MetadataDescriptionBuilder {

  public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7) -> OctupleMetadataLayout<C0, C1, C2, C3, C4, C5, C6, C7>
    where C0 : MetadataLayout , C1 : MetadataLayout , C2 : MetadataLayout , C3 : MetadataLayout , C4 : MetadataLayout , C5 : MetadataLayout , C6 : MetadataLayout , C7 : MetadataLayout
  {
    return OctupleMetadataLayout((c0, c1, c2, c3, c4, c5, c6, c7))
  }
}

extension MetadataDescriptionBuilder {

  public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8) -> NontupleMetadataLayout<C0, C1, C2, C3, C4, C5, C6, C7, C8>
    where C0 : MetadataLayout , C1 : MetadataLayout , C2 : MetadataLayout , C3 : MetadataLayout , C4 : MetadataLayout , C5 : MetadataLayout , C6 : MetadataLayout , C7 : MetadataLayout , C8 : MetadataLayout
  {
    return NontupleMetadataLayout((c0, c1, c2, c3, c4, c5, c6, c7, c8))
  }
}

extension MetadataDescriptionBuilder {

  public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9) -> DectupleMetadataLayout<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9>
    where C0 : MetadataLayout , C1 : MetadataLayout , C2 : MetadataLayout , C3 : MetadataLayout , C4 : MetadataLayout , C5 : MetadataLayout , C6 : MetadataLayout , C7 : MetadataLayout , C8 : MetadataLayout , C9 : MetadataLayout
  {
    return DectupleMetadataLayout((c0, c1, c2, c3, c4, c5, c6, c7, c8, c9))
  }
}

extension MetadataDescriptionBuilder {

  public static func buildBlock<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10>(_ c0: C0, _ c1: C1, _ c2: C2, _ c3: C3, _ c4: C4, _ c5: C5, _ c6: C6, _ c7: C7, _ c8: C8, _ c9: C9, _ c10: C10) -> UndecupleMetadataLayout<C0, C1, C2, C3, C4, C5, C6, C7, C8, C9, C10>
    where C0 : MetadataLayout , C1 : MetadataLayout , C2 : MetadataLayout , C3 : MetadataLayout , C4 : MetadataLayout , C5 : MetadataLayout , C6 : MetadataLayout , C7 : MetadataLayout , C8 : MetadataLayout , C9 : MetadataLayout , C10 : MetadataLayout
  {
    return UndecupleMetadataLayout((c0, c1, c2, c3, c4, c5, c6, c7, c8, c9, c10))
  }
}

public protocol MetadataLayout {
  associatedtype Body: MetadataLayout

  var layout: Self.Body { get }

  associatedtype Output

  static func deserialize() -> ByteReader<Self.Output>
}

public protocol _MetadataRoot {
  associatedtype Content
}

public struct Metadata<Content>: _MetadataRoot
  where Content: MetadataLayout
{
  public var layout: some MetadataLayout {
    return self
  }

  public init(@MetadataDescriptionBuilder content: () -> Content) {
    fatalError()
  }

  func withTrailingObjects<Trailing: MetadataLayout>(@MetadataDescriptionBuilder content: () -> Trailing) -> TrailingMetadata<Metadata<Content>, Trailing> {
    return TrailingMetadata(self, trail: content)
  }
}

public struct TrailingMetadata<Content, TrailingContent>
  where Content: MetadataLayout , TrailingContent: MetadataLayout
{
  public var layout: Never {
    fatalError()
  }

  public init(_ content: Content, trail: () -> TrailingContent) {
    fatalError()
  }
}

public struct FunctionPointer<In, Out> {
  public var layout: Never {
    fatalError()
  }
}

public struct Constant<Value>
  where Value: BinaryInteger
{
  public var layout: Never {
    fatalError()
  }
}

public struct NewTypeConstant<Value>
  where Value: RawRepresentable, Value.RawValue: BinaryInteger
{
  public var layout: Never {
    fatalError()
  }
}

public struct Flags<Interpreted: OptionSet>
  where Interpreted.RawValue: BinaryInteger
{
  public var layout: Never {
    fatalError()
  }
}

public struct DirectPointer<Pointee>
  where Pointee: MetadataLayout
{
  public init() {}

  public var layout: Never {
    fatalError()
  }
}

public struct WordBufferLayout {
  public init() {}

  public var layout: Never {
    fatalError()
  }
}

public struct WordBuffer2Layout {
  public init() {}

  public var layout: Never {
    fatalError()
  }
}

public struct WordBuffer4Layout {
  public init() {}

  public var layout: Never {
    fatalError()
  }
}

public struct WordBuffer16Layout {
  public init() {}

  public var layout: Never {
    fatalError()
  }
}

public struct Union<Content>
  where Content: MetadataLayout
{
  public var layout: Never {
    fatalError()
  }

  public init(@MetadataDescriptionBuilder content: () -> Content) {
    fatalError()
  }
}

extension Never {
  public var layout: Never {
    fatalError()
  }
}

public struct CString {
  public var layout: Never {
    fatalError()
  }
}

struct RelativeDirectPointerLayout<Pointee> {
//  public typealias Output = UnsafePointer<Pointee>

  public var layout: Never {
    fatalError()
  }
  //  var relativeOffset: OffsetType
  //
  //  mutating func get() -> Pointee {
  //    let rawOffset = Int(self.relativeOffset)
  //    return withUnsafePointer(to: &self) { fieldPtr in
  //      return UnsafeRawPointer(fieldPtr).advanced(by: rawOffset).assumingMemoryBound(to: Pointee.self)
  //    } .pointee
  //  }
}

struct OpaqueRelativeDirectPointerLayout {
//  public typealias Output = OpaquePointer

  public var layout: Never {
    fatalError()
  }
}


struct RelativeIndirectablePointerLayout<Pointee> {
//  public typealias Output = UnsafePointer<Pointee>

  public var layout: Never {
    fatalError()
  }
}

struct RelativeDirectPointerIntPairLayout<Pointee, IntType> {
//  public typealias Output = UnsafePointer<Pointee>

  public var layout: Never {
    fatalError()
  }
}

struct RelativeIndirectablePointerIntPairLayout<Pointee, IntType> {
  public var layout: Never {
    fatalError()
  }
}

public struct TupleMetadataLayout<T, U>
  where T: MetadataLayout , U: MetadataLayout
{
  public var value: (T, U)

  public init(_ value: (T, U)) {
    self.value = value
  }

  public var layout: Never {
    fatalError()
  }
}


public struct TripleMetadataLayout<T, U, V>
  where T: MetadataLayout , U: MetadataLayout , V: MetadataLayout
{
  public var value: (T, U, V)

  public init(_ value: (T, U, V)) {
    self.value = value
  }

  public var layout: Never {
    fatalError()
  }
}



public struct QuadrupleMetadataLayout<T, U, V, W>
  where T: MetadataLayout , U: MetadataLayout , V: MetadataLayout , W: MetadataLayout
{
  public var value: (T, U, V, W)

  public init(_ value: (T, U, V, W)) {
    self.value = value
  }

  public var layout: Never {
    fatalError()
  }
}



public struct QuintupleMetadataLayout<T, U, V, W, X>
  where T: MetadataLayout , U: MetadataLayout , V: MetadataLayout , W: MetadataLayout , X: MetadataLayout
{
  public var value: (T, U, V, W, X)

  public init(_ value: (T, U, V, W, X)) {
    self.value = value
  }

  public var layout: Never {
    fatalError()
  }
}



public struct SextupleMetadataLayout<T, U, V, W, X, Y>
  where T: MetadataLayout, U: MetadataLayout, V: MetadataLayout, W: MetadataLayout, X: MetadataLayout, Y: MetadataLayout
{
  public var value: (T, U, V, W, X, Y)

  public init(_ value: (T, U, V, W, X, Y)) {
    self.value = value
  }

  public var layout: Never {
    fatalError()
  }
}


public struct SeptupleMetadataLayout<T, U, V, W, X, Y, Z>
  where T: MetadataLayout, U: MetadataLayout, V: MetadataLayout, W: MetadataLayout, X: MetadataLayout, Y: MetadataLayout, Z: MetadataLayout
{
  public var value: (T, U, V, W, X, Y, Z)

  public init(_ value: (T, U, V, W, X, Y, Z)) {
    self.value = value
  }

  public var layout: Never {
    fatalError()
  }
}

public struct OctupleMetadataLayout<T, U, V, W, X, Y, Z, A>
  where T: MetadataLayout , U: MetadataLayout , V: MetadataLayout , W: MetadataLayout , X: MetadataLayout , Y: MetadataLayout , Z: MetadataLayout , A: MetadataLayout
{
  public var value: (T, U, V, W, X, Y, Z, A)

  public init(_ value: (T, U, V, W, X, Y, Z, A)) {
    self.value = value
  }

  public var layout: Never {
    fatalError()
  }
}

public struct NontupleMetadataLayout<T, U, V, W, X, Y, Z, A, B>
  where T: MetadataLayout , U: MetadataLayout , V: MetadataLayout , W: MetadataLayout , X: MetadataLayout , Y: MetadataLayout , Z: MetadataLayout , A: MetadataLayout , B: MetadataLayout
{
  public var value: (T, U, V, W, X, Y, Z, A, B)

  public init(_ value: (T, U, V, W, X, Y, Z, A, B)) {
    self.value = value
  }

  public var layout: Never {
    fatalError()
  }
}

public struct DectupleMetadataLayout<T, U, V, W, X, Y, Z, A, B, C>
  where T: MetadataLayout , U: MetadataLayout , V: MetadataLayout , W: MetadataLayout , X: MetadataLayout , Y: MetadataLayout , Z: MetadataLayout , A: MetadataLayout , B: MetadataLayout , C: MetadataLayout
{
  public var value: (T, U, V, W, X, Y, Z, A, B, C)

  public init(_ value: (T, U, V, W, X, Y, Z, A, B, C)) {
    self.value = value
  }

  public var layout: Never {
    fatalError()
  }
}

public struct UndecupleMetadataLayout<T, U, V, W, X, Y, Z, A, B, C, D>
  where T: MetadataLayout , U: MetadataLayout , V: MetadataLayout , W: MetadataLayout , X: MetadataLayout , Y: MetadataLayout , Z: MetadataLayout , A: MetadataLayout , B: MetadataLayout , C: MetadataLayout , D: MetadataLayout
{
  public var value: (T, U, V, W, X, Y, Z, A, B, C, D)

  public init(_ value: (T, U, V, W, X, Y, Z, A, B, C, D)) {
    self.value = value
  }

  public var layout: Never {
    fatalError()
  }
}
