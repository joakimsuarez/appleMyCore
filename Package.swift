// swift-tools-version:5.9
import PackageDescription

var products: [Product] = [
    .library(name: "appleMyCore", targets: ["appleMyCore"]),
    .executable(name: "appleMyCoreCLI", targets: ["appleMyCoreCLI"])
]

var targets: [Target] = [
    .target(
        name: "appleMyCore",
        path: "Sources/appleMyCore"
    ),
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
    ),
    .testTarget(
        name: "appleMyCoreTests",
        dependencies: ["appleMyCore"],
        path: "Tests/appleMyCoreTests"
    )
]

// Lägg till Apple-specifika targets om vi inte är på Windows
#if !os(Windows)
products += [
    .executable(name: "iPhoneApp", targets: ["iPhoneApp"]),
    .executable(name: "WatchApp", targets: ["WatchApp"]),
    .executable(name: "WatchHRVComplication", targets: ["WatchHRVComplication"])
]

targets += [
    .executableTarget(
        name: "iPhoneApp",
        dependencies: ["appleMyCore"],
        path: "Sources/iPhoneApp"
    ),
    .executableTarget(
        name: "WatchApp",
        dependencies: ["appleMyCore"],
        path: "Sources/WatchApp"
    ),
    .executableTarget(
        name: "WatchHRVComplication",
        dependencies: ["appleMyCore"],
        path: "Sources/WatchHRVComplication"
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
