//
//  TextFieldClearButton.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import SwiftUI

/// An overlay of a button that is used to clear a TextField.
struct TextFieldClearButton: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        content
            .overlay {
                if !text.isEmpty {
                    HStack {
                        Spacer()
                        Button {
                            text = ""
                        } label: {
                            Image(systemName: "multiply.circle.fill")
                                .imageScale(.medium)
                        }
                        .foregroundColor(.secondary)
                        .padding(.trailing, 4)
                    }
                }
            }
    }
}

extension View {
    
    /// Add a `TextFieldClearButton` to a view.
    func showClearButton(_ text: Binding<String>) -> some View {
        self.modifier(TextFieldClearButton(text: text))
    }
}
