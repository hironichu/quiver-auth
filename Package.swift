// swift-tools-version: 6.2

import Foundation
import PackageDescription

let packageDirectory = URL(fileURLWithPath: #filePath).deletingLastPathComponent()
let localQuiverPackagesRoot = Context.environment["QUIVER_PACKAGES_PATH"]

func quiverPackage(_ repository: String) -> Package.Dependency {
    if let localQuiverPackagesRoot {
        let localURL = URL(fileURLWithPath: localQuiverPackagesRoot, relativeTo: packageDirectory)
            .appendingPathComponent(repository)
            .standardizedFileURL
        let manifestURL = localURL.appendingPathComponent("Package.swift")

        if FileManager.default.fileExists(atPath: manifestURL.path) {
            return .package(path: localURL.path)
        }
    }

    return .package(url: "https://github.com/hironichu/\(repository).git", branch: "experimental/runtime")
}

let package = Package(
    name: "quiver-auth",
    platforms: [
        .macOS(.v15),
        .iOS(.v18),
        .tvOS(.v18),
        .watchOS(.v11),
        .visionOS(.v2),
    ],
    products: [
        .library(name: "QuiverAuth", targets: ["QuiverAuth"]),
    ],
    dependencies: [
        quiverPackage("quiver-http3"),
        quiverPackage("quiver-quic"),
        .package(url: "https://github.com/apple/swift-crypto.git", "3.0.0"..<"4.5.0"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.12.0"),
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.30.0"),
        .package(url: "https://github.com/vapor/jwt-kit.git", from: "5.5.0"),
    ],
    targets: [
        .target(
            name: "QuiverAuth",
            dependencies: [
                .product(name: "HTTP3", package: "quiver-http3"),
                .product(name: "QUICCore", package: "quiver-quic"),
                .product(name: "Crypto", package: "swift-crypto"),
                .product(name: "Logging", package: "swift-log"),
                .product(name: "AsyncHTTPClient", package: "async-http-client"),
                .product(name: "JWTKit", package: "jwt-kit"),
            ],
            path: "Sources/QuiverAuth"
        ),
        .testTarget(
            name: "QuiverAuthTests",
            dependencies: [
                "QuiverAuth",
                .product(name: "HTTP3", package: "quiver-http3"),
                .product(name: "Crypto", package: "swift-crypto"),
            ],
            path: "Tests/QuiverAuthTests"
        ),
    ]
)
