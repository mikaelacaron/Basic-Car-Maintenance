//
//  BasicCarMaintenanceApp.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 8/11/23.
//
import FirebaseCore
import SwiftUI

@main
struct BasicCarMaintenanceApp: App {
    @State private var actionService = ActionService.shared
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(actionService)
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
