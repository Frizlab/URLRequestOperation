// swift-tools-version:5.10
import PackageDescription


let swiftSettings: [SwiftSetting] = [
	.enableExperimentalFeature("StrictConcurrency")
]

let package = Package(
	name: "URLRequestOperation",
	platforms: [.macOS(.v10_15), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)],
	products: [
		.library(name: "MediaType", targets: ["MediaType"]),
		.library(name: "URLRequestOperation", targets: ["URLRequestOperation"]),
	],
	dependencies: [
		.package(url: "https://github.com/apple/swift-log.git",           from: "1.4.2"),
		.package(url: "https://github.com/Frizlab/GlobalConfModule.git",  from: "0.3.0"),
		.package(url: "https://github.com/Frizlab/HTTPCoders.git",        from: "0.1.0"),
		.package(url: "https://github.com/Frizlab/RetryingOperation.git", from: "1.1.6"),
		.package(url: "https://github.com/Frizlab/SafeGlobal.git",        from: "0.3.0"),
		.package(url: "https://github.com/Frizlab/SemiSingleton.git",     from: "2.1.0-beta.1"),
	],
	targets: [
		.target(name: "MediaType", swiftSettings: swiftSettings),
		.testTarget(name: "MediaTypeTests", dependencies: ["MediaType"], swiftSettings: swiftSettings),
		
		.target(name: "URLRequestOperation", dependencies: [
			.product(name: "FormURLEncodedCoder", package: "HTTPCoders"),
			.product(name: "GlobalConfModule",    package: "GlobalConfModule"),
			.product(name: "Logging",             package: "swift-log"),
			.product(name: "RetryingOperation",   package: "RetryingOperation"),
			.product(name: "SafeGlobal",          package: "SafeGlobal"),
			.product(name: "SemiSingleton",       package: "SemiSingleton"),
			.target(name: "MediaType"),
		], swiftSettings: swiftSettings),
		.testTarget(name: "URLRequestOperationTests", dependencies: ["URLRequestOperation"], swiftSettings: swiftSettings),
		.executableTarget(name: "URLRequestOperationManualTest", dependencies: ["URLRequestOperation"], swiftSettings: swiftSettings),
	]
)
