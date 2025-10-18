// swift-tools-version:6.2
import PackageDescription

let package = Package(
    name: "appleMyCore",
    platforms: [
        .macOS(.v13),
        .iOS(.v16),
    ],
    products: [
        .library(
            name: "appleMyCore",
            targets: ["appleMyCore"]
        ),
    ],
    dependencies: [
        // inga externa dependencies ännu
    ],
    targets: [
        .target(
            name: "appleMyCore",
            dependencies: [],  // Alla filer under Sources/appleMyCore inkluderas
            path: "Sources/appleMyCore"
        ),
        .testTarget(
            name: "appleMyCoreTests",
            dependencies: ["appleMyCore"],
            path: "Tests/appleMyCoreTests"
        ),
    ]
)
