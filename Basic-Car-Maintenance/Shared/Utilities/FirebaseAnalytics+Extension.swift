//
//  FirebaseAnalytics+Extension.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import SwiftUI
import FirebaseAnalyticsSwift

struct FirebaseAnalyticsModifier: ViewModifier {
    
    let screenName: String
    
    func body(content: Content) -> some View {
        content
            .analyticsScreen(name: screenName)
    }
}

extension View {
    func analyticsView(_ name: String) -> some View {
        modifier(FirebaseAnalyticsModifier(screenName: name))
    }
}
