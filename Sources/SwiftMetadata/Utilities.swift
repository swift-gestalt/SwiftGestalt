/// Utilities.swift
///
/// Copyright 2019, The SwiftGestalt Project.
///
/// This project is released under the MIT license, a copy of which is
/// available in the repository.

import func Foundation.free
import SwiftDemangleShims

func _stdlib_demangleTypeName(_ mangledName: UnsafePointer<Int8>, _ count: Int) -> String {
  var outLen = 0
  guard let ptr = SDSDemangleTypeAsString(mangledName, count, &outLen) else {
    return ""
  }
  defer { free(UnsafeMutablePointer(mutating: ptr)) }
  return String(cString: ptr)
}


// This is, objectively, a terrible idea.
@_silgen_name("swift_demangle")
public
func _stdlib_demangleImpl(
  mangledName: UnsafePointer<CChar>?,
  mangledNameLength: UInt,
  outputBuffer: UnsafeMutablePointer<CChar>?,
  outputBufferSize: UnsafeMutablePointer<UInt>?,
  flags: UInt32
) -> UnsafeMutablePointer<CChar>?

public func _stdlib_demangleName(_ mangledName: String) -> String {
  return mangledName.utf8CString.withUnsafeBufferPointer {
    (mangledNameUTF8CStr) in

    let demangledNamePtr = _stdlib_demangleImpl(
      mangledName: mangledNameUTF8CStr.baseAddress,
      mangledNameLength: UInt(mangledNameUTF8CStr.count - 1),
      outputBuffer: nil,
      outputBufferSize: nil,
      flags: 0)

    if let demangledNamePtr = demangledNamePtr {
      let demangledName = String(cString: demangledNamePtr)
      free(demangledNamePtr)
      return demangledName
    }
    return mangledName
  }
}

func relativePointer<T, U, V>(base: UnsafePointer<T>, offset: U) -> UnsafePointer<V> where U : BinaryInteger {
  return UnsafeRawPointer(base).advanced(by: Int(integer: offset)).assumingMemoryBound(to: V.self)
}

func extentOfSymbolicMangledName(_ ptr: UnsafePointer<Int8>) -> Int {
  var end = 0
  while ptr[end] != UInt8(ascii: "\0") {
    if ptr[end] >= UInt8(ascii: "\u{1}") && ptr[end] <= UInt8(ascii: "\u{17}") {
      end += MemoryLayout<UInt32>.size
    } else if ptr[end] >= UInt8(ascii: "\u{18}") && ptr[end] <= UInt8(ascii: "\u{1f}") {
      end += MemoryLayout<UInt>.size
    }
    end += 1
  }
  return end
}

extension Int {
  fileprivate init<T : BinaryInteger>(integer: T) {
    switch integer {
    case let value as Int: self = value
    case let value as Int32: self = Int(value)
    case let value as Int16: self = Int(value)
    case let value as Int8: self = Int(value)
    default: self = 0
    }
  }
}
