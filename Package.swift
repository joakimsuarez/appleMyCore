// swift-tools-version:6.2
import PackageDescription

let package = Package(
    name: "applemycore",
    platforms: [
        .iOS(.v16),
        .watchOS(.v10),
        .macOS(.v13)
    ],
    products: [
        .library(name: "appleMyCore", targets: ["appleMyCore"]),
        // CLI endast på Windows
        .executable(name: "appleMyCoreCLI", targets: ["appleMyCoreCLI"])
    ],
    dependencies: [
        .package(url: "https://github.com/drmohundro/SWXMLHash.git", from: "7.0.0")
        //.package(url: "https://github.com/drmohundro/SWXMLHash.git", from: "6.0.0")
    ],
    targets: [
        .target(
            name: "appleMyCore",
            dependencies: ["SWXMLHash"],
            path: "Sources/appleMyCore",
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "appleMyCoreTests",
            dependencies: ["appleMyCore"],
            path: "Tests/appleMyCoreTests"
        ),
        // CLI endast på Windows
        .executableTarget(
            name: "appleMyCoreCLI",
                dependencies: ["appleMyCore", "SWXMLHash"],
            path: "Sources/appleMyCoreCLI",
            swiftSettings: [
                .define("WINDOWS", .when(platforms: [.windows]))
            ],
            linkerSettings: [
                .unsafeFlags(["-Xlinker", "-subsystem:console"])
            ]
        )
    ]
)
