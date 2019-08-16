// swift-tools-version:5.1

import PackageDescription

let package = Package(
  name: "SwiftGestalt",
  platforms: [
    .macOS(.v10_15),
  ],
  products: [
    .executable(
      name: "swift-gestalt",
      targets: ["swift-gestalt"]),
    .library(
      name: "SwiftMetadata",
      targets: ["SwiftMetadata"]),
    .library(
      name: "SwiftRuntime",
      targets: ["SwiftRuntime"]),
  ],
  dependencies: [
    .package(url: "https://github.com/apple/swift-package-manager.git", from: "0.1.0"),
    .package(url: "https://github.com/llvm-swift/LLVMSwift.git", .branch("master")),
  ],
  targets: [
    .target(
      name: "swift-gestalt",
      dependencies: ["SwiftGestalt", "SPMUtility"]),
    .target(
      name: "SwiftMetadata",
      dependencies: ["SwiftDemangleShims"]),
    .target(
      name: "SwiftRuntime",
      dependencies: ["SwiftDemangleShims"]),
    .target(
      name: "SwiftGestalt",
      dependencies: ["LLVM", "SwiftMetadata"]),
    .target(
      name: "SwiftDemangleShims",
      dependencies: ["SwiftGestaltShims"]),
    .systemLibrary(
      name: "SwiftGestaltShims",
      pkgConfig: "SwiftGestalt"),
    .testTarget(
      name: "SwiftGestaltTests",
      dependencies: ["SwiftGestalt"]),
    .testTarget(
      name: "SwiftMetadataTests",
      dependencies: ["SwiftMetadata"]),
  ],
  cxxLanguageStandard: .cxx14
)
