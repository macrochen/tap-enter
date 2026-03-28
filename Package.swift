// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "tap-enter",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "TapEnter", targets: ["TapEnter"])
    ],
    targets: [
        .executableTarget(
            name: "TapEnter",
            path: "Sources/TapEnter"
        )
    ]
)
