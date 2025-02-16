// swift-tools-version: 5.9

// WARNING:
// This file is automatically generated.
// Do not edit it by hand because the contents will be replaced.

import PackageDescription
import AppleProductTypes

let package = Package(
    name: "FaceQuiz",
    platforms: [
        .iOS("17.5")
    ],
    products: [
        .iOSApplication(
            name: "FaceQuiz",
            targets: ["AppModule"],
            bundleIdentifier: "com.roosoars.FaceQuiz",
            teamIdentifier: "46DBQ8QB58",
            displayVersion: "1.0",
            bundleVersion: "1",
            appIcon: .placeholder(icon: .checkmark),
            accentColor: .presetColor(.blue),
            supportedDeviceFamilies: [
                .pad,
                .phone
            ],
            supportedInterfaceOrientations: [
                .portrait,
                .landscapeRight,
                .landscapeLeft,
                .portraitUpsideDown(.when(deviceFamilies: [.pad]))
            ]
        )
    ],
    targets: [
        .executableTarget(
            name: "AppModule",
            path: ".",
            resources: [
                .copy("Core/Resources/Model/EMOTION_ML.mlmodelc"),
                .copy("Core/Resources/Mock/MockQuestions.json")
            ],
            swiftSettings: [
                .enableUpcomingFeature("BareSlashRegexLiterals")
            ]
        )
    ]
)
