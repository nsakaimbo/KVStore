// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "KVStore",
    targets: [
       Target(
	   name: "KVStore",
	   dependencies: ["KVStoreCore"]
       ),
       Target(name: "KVStoreCore")
    ]
)
