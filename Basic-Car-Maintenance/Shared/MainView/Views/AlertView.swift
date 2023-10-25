//
//  AlertView.swift
//  Basic-Car-Maintenance
//
//  Created by Omar Hegazy on 11/10/2023.
//

import SwiftUI

struct AlertView: View {
    let alert: AlertItem
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .center) {
                        Text(alert.icon)
                            .font(.system(size: 100))
                        
                        Text(alert.title)
                            .font(.title)
                            .lineLimit(2)
                            .bold()
                        
                        Text(alert.message)
                            .multilineTextAlignment(.center)
                    }
                }
                .scrollIndicators(.hidden)
                .padding(.horizontal, 24)
                
                Button {
                    guard let url = URL(string: alert.actionURL),
                          UIApplication.shared.canOpenURL(url) else {
                        dismiss()
                        return
                    }
                    
                    UIApplication.shared.open(url)
                } label: {
                    Text(alert.actionText)
                        .font(.title3)
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                }
                .frame(minHeight: 44)
                .background {
                    Color(.basicGreen)
                }
                .clipShape(.capsule)
                .padding([.bottom, .trailing, .leading], 24)
            }
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Dismiss")
                            .bold()
                    }
                }
            }
        }
        .interactiveDismissDisabled()
    }
}

#Preview {
    AlertView(
        alert: AlertItem(
            id: nil,
            actionText: "",
            actionURL: "",
            icon: "",
            isOn: false,
            message: "",
            title: ""
        )
    )
}
