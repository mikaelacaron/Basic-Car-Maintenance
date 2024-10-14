//
//  BasicCarMaintenanceApp.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import FirebaseAuth
import FirebaseCore
import FirebaseFirestore
import SwiftUI
import TipKit

@main
struct BasicCarMaintenanceApp: App {
    @State private var actionService = ActionService.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    // Logic to load Onboarding screen when app was first launched
//    @AppStorage("isFirstTime") private var isFirstTime: Bool = true
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(actionService)
                .modelContainer(for: [AcknowledgedAlert.self])
                .task {
                  try? Tips.configure()
                }
//                .sheet(isPresented: $isFirstTime) {
//                    WelcomeView()
//                        .interactiveDismissDisabled()
//                }
        }
    }
}

class AppDelegate: NSObject, UIApplicationDelegate {
    private let actionService = ActionService.shared
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        
        FirebaseApp.configure()
        
        try? Auth.auth().useUserAccessGroup(Bundle.main.keychainAccessGroup)
        let useEmulator = UserDefaults.standard.bool(forKey: "useEmulator")
        if useEmulator {
            let settings = Firestore.firestore().settings
            settings.host = "localhost:8080"
            settings.cacheSettings = MemoryCacheSettings()
            settings.isSSLEnabled = false
            Firestore.firestore().settings = settings
            
            Auth.auth().useEmulator(withHost: "127.0.0.1", port: 9099)
        }
        
        return true
    }
    
    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        // get the shortcut when the app is launching
        if let shortcutItem = options.shortcutItem,
           let action = Action(shortcutItem: shortcutItem) {
            actionService.updateIncoming(action)
        }
        
        let configuration = UISceneConfiguration(
            name: connectingSceneSession.configuration.name,
            sessionRole: connectingSceneSession.role
        )
        configuration.delegateClass = SceneDelegate.self
        return configuration
    }
}

class SceneDelegate: NSObject, UIWindowSceneDelegate {
    private let actionService = ActionService.shared
    
    func windowScene(
        _ windowScene: UIWindowScene,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ) {
        // get the shortcut if the app is already running
        let action = Action(shortcutItem: shortcutItem)
        actionService.updateIncoming(action)
        completionHandler(true)
    }
}

@Observable
class ActionService: ObservableObject {
    static let shared = ActionService()
    private(set) var action: Action?
    
    fileprivate func updateIncoming(_ action: Action?) {
        self.action = action
    }
}
