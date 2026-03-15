// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ImageFixer",
    platforms: [
        .macOS(.v14)
    ],
    products: [
        .executable(name: "ImageFixer", targets: ["ImageFixer"])
    ],
    targets: [
        .executableTarget(
            name: "ImageFixer",
            dependencies: [],
            path: "Sources"
        )
    ]
)
