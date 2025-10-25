// swift-tools-version:6.2
import PackageDescription

var products: [Product] = [
    .library(name: "appleMyCore", targets: ["appleMyCore"])
]

var targets: [Target] = [
    .target(
        name: "appleMyCore",
        path: "Sources/appleMyCore"
    ),
    .testTarget(
        name: "appleMyCoreTests",
        dependencies: ["appleMyCore"],
        path: "Tests/appleMyCoreTests"
    )
]

// Lägg till CLI endast på Windows
#if os(Windows)
products += [
    .executable(name: "appleMyCoreCLI", targets: ["appleMyCoreCLI"])
]

targets += [
    .executableTarget(
        name: "appleMyCoreCLI",
        dependencies: ["appleMyCore"],
        path: "Sources/appleMyCoreCLI",
        swiftSettings: [
            .define("WINDOWS", .when(platforms: [.windows]))
        ],
        linkerSettings: [
            .unsafeFlags(["-Xlinker", "-subsystem:console"])
        ]
    )
]
#endif

let package = Package(
    name: "applemycore",
    platforms: [
        .iOS(.v16),
        .watchOS(.v10),
        .macOS(.v13)
    ],
    products: products,
    targets: targets
)

