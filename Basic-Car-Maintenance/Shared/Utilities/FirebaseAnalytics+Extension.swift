//
//  FirebaseAnalytics+Extension.swift
//  Basic-Car-Maintenance
//
//  Created by Jessica Linden on 10/30/23.
//

import SwiftUI
import FirebaseAnalyticsSwift

struct FireBaseAnalyticsModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .analyticsScreen(name: "\(Self.self)")
    }
}

extension View {
    func analyticsView() -> some View {
        modifier(FireBaseAnalyticsModifier())
    }
}
