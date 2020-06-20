// swift-tools-version:5.0

import PackageDescription

let package = Package(
  name: "SavannaKit",
  platforms: [
    .macOS(.v10_14)
  ],
  products: [
    .library(name: "SavannaKit", type: .dynamic, targets: ["SavannaKit"])
  ],
  targets: [
    .target(name: "SavannaKit")
  ]
)
