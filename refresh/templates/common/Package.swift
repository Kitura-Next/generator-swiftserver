// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "{{{executableModule}}}",
    dependencies: [
      .package(url: "https://github.com/IBM-Swift/Kitura.git", .upToNextMinor(from: "2.8.0")),
      .package(url: "https://github.com/IBM-Swift/HeliumLogger.git", from: "1.7.1"),
      .package(url: "https://github.com/IBM-Swift/CloudEnvironment.git", from: "9.0.0"),
{{#each dependencies}}
      {{{this}}}
{{/each}}
    ],
    targets: [
      .target(name: "{{{executableModule}}}", dependencies: [ .target(name: "{{{applicationModule}}}") ]),
      .target(name: "{{{applicationModule}}}", dependencies: [ "Kitura", "HeliumLogger", "CloudEnvironment",{{#each modules}}{{{this}}}, {{/each}}
{{#ifCond appType '===' 'crud'}}.target(name: "{{{generatedModule}}}"),{{/ifCond}}
{{#ifCond sdkTargets.length '>' 0}}
      {{#each sdkTargets}}.target(name: "{{{this}}}"), {{/each}}
      ]),
      {{#each sdkTargets}}.target(name: "{{{this}}}", dependencies: ["SimpleHttpClient"], path: "Sources/{{{this}}}" ), {{/each}}
{{else}}
      ]),
{{/ifCond}}
{{#ifCond appType '===' 'crud'}}
      .target(name: "{{{generatedModule}}}", dependencies: ["Kitura", "CloudEnvironment", "SwiftyJSON", {{#each modules}}{{{this}}},{{/each}}], path: "Sources/{{{generatedModule}}}"),
{{/ifCond}}

      .testTarget(name: "ApplicationTests" , dependencies: [.target(name: "{{{applicationModule}}}"), "Kitura", "HeliumLogger" ])
    ]
)
