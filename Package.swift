// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftZMQ",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "ZeroMQ",
            targets: ["ZeroMQ"]),
        .executable(
            name: "Example",
            targets: ["Example"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .systemLibrary(
            name: "CZeroMQ",
            pkgConfig: "libzmq",
            providers: [
                .brew(["zeromq"]),
                .apt(["libzmq-dev"])
            ]),
        .target(
            name: "ZeroMQ",
            dependencies: ["CZeroMQ"]),
        .target(
            name: "Example",
            dependencies: [ "ZeroMQ"]),
        .testTarget(
            name: "ZeroMQTests",
            dependencies: ["ZeroMQ"]),
    ]
)
