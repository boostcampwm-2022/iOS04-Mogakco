import ProjectDescription
import ProjectDescriptionHelpers

// MARK: - Project Factory
protocol ProjectFactory {
    var projectName: String { get }
    var dependencies: [TargetDependency] { get }
    
    func generateTarget() -> [Target]
    func generateConfigurations() -> Settings
}

// MARK: - Base Project Factory
class BaseProjectFactory: ProjectFactory {
    let projectName: String = "Mogakco"
    
    let deploymentTarget: ProjectDescription.DeploymentTarget = .iOS(targetVersion: "16.0", devices: [.iphone])
    
    let dependencies: [TargetDependency] = [
        .external(name: "RxSwift"),
        .external(name: "RxCocoa"),
        .external(name: "RxKeyboard"),
        .external(name: "SnapKit"),
        .external(name: "Then"),
        .external(name: "FirebaseAuth"),
        .external(name: "FirebaseDatabase"),
        .external(name: "FirebaseFirestore"),
        .external(name: "FirebaseStorage"),
        .external(name: "FirebaseMessaging"),
        .external(name: "Swinject"),
        .target(name: "RxMogakcoYa"),
        .target(name: "RxMGKfisher"),
        .target(name: "Mogakmation")
    ]
    
    let infoPlist: [String: InfoPlist.Value] = [
        "CFBundleShortVersionString": "1.0",
        "CFBundleVersion": "1",
        "UILaunchStoryboardName": "LaunchScreen",
        "UIApplicationSceneManifest": [
            "UIApplicationSupportsMultipleScenes": false,
            "UISceneConfigurations": [
                "UIWindowSceneSessionRoleApplication": [
                    [
                        "UISceneConfigurationName": "Default Configuration",
                        "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                    ],
                ]
            ]
        ],
    ]
    
    let baseSettings: [String: SettingValue] = [
      "OTHER_LDFLAGS": "-ObjC",
    ]
    
    let releaseSetting: [String: SettingValue] = [:]
    
    let debugSetting: [String: SettingValue] = [:]
    
    func generateConfigurations() -> Settings {
        return Settings.settings(
            base: baseSettings,
            configurations: [
              .release(
                name: "Release",
                settings: releaseSetting
              ),
              .debug(
                name: "Debug",
                settings: debugSetting
              )
            ],
            defaultSettings: .recommended
          )
    }
    
    func generateTarget() -> [Target] {
        [
            Target(
                name: projectName,
                platform: .iOS,
                product: .app,
                bundleId: "com.codershigh.boostcamp.\(projectName)",
                deploymentTarget: deploymentTarget,
                infoPlist: .extendingDefault(with: infoPlist),
                sources: ["\(projectName)/Sources/**"],
                resources: "\(projectName)/Resources/**",
                entitlements: "\(projectName).entitlements",
                scripts: [.pre(path: "Scripts/SwiftLintRunScript.sh", arguments: [], name: "SwiftLint")],
                dependencies: dependencies
            ),
            Target(
                name: "RxMogakcoYa",
                platform: .iOS,
                product: .framework,
                bundleId: "com.codershigh.boostcamp.\(projectName).RxMogakcoYa",
                deploymentTarget: deploymentTarget,
                infoPlist: .default,
                sources: ["RxMogakcoYa/Sources/**"],
                dependencies: [
                    .external(name: "RxSwift"),
                    .external(name: "Alamofire")
                ]
            ),
            Target(
                name: "RxMGKfisher",
                platform: .iOS,
                product: .framework,
                bundleId: "com.codershigh.boostcamp.\(projectName).RxMGKfisher",
                deploymentTarget: deploymentTarget,
                infoPlist: .default,
                sources: ["RxMGKfisher/Sources/**"],
                dependencies: [
                    .external(name: "RxSwift"),
                    .external(name: "RxCocoa")
                ]
            ),
            Target(
                name: "Mogakmation",
                platform: .iOS,
                product: .framework,
                bundleId: "com.codershigh.boostcamp.\(projectName).Mogakmation",
                deploymentTarget: deploymentTarget,
                sources: ["Mogakmation/Sources/**"]
            )
        ]
    }
}

// MARK: - Project
let factory = BaseProjectFactory()

let project: Project = .init(
    name: factory.projectName,
    organizationName: factory.projectName,
    settings: factory.generateConfigurations(),
    targets: factory.generateTarget()
)
