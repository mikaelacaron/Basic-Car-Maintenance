//
//  FirebaseAnalytics+Extension.swift
//  Basic-Car-Maintenance
//
//  Created by Mikaela Caron on 10/21/23.
//

import FirebaseAnalyticsSwift
import SwiftUI

extension View {
    func analyticsView(_ viewName: String) -> some View {
        modifier(AnalyticsView(viewName: viewName))
    }
}

struct AnalyticsView: ViewModifier {
    
    let viewName: String
    
    func body(content: Content) -> some View {
        content
            .analyticsScreen(name: viewName)
    }
}
