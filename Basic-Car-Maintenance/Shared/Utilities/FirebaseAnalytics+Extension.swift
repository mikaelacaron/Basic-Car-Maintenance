//
//  FirebaseAnalytics+Extension.swift
//  Basic-Car-Maintenance
//
//  Created by Jessica Linden on 10/30/23.
//

import SwiftUI
import FirebaseAnalytics

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
