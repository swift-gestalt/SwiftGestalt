/// Demangler.swift
///
/// Copyright 2019, The SwiftGestalt Project.
///
/// This project is released under the MIT license, a copy of which is
/// available in the repository.

import SwiftMetadata

public enum Demangler {
  public static func demangleSymbol(_ symbol: String) -> String {
    return _stdlib_demangleName(symbol)
  }
}
