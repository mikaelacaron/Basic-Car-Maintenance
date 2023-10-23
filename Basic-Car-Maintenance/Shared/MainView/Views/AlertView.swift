//
//  AlertView.swift
//  Basic-Car-Maintenance
//
//  Created by Omar Hegazy on 11/10/2023.
//

import SwiftUI

struct AlertView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            VStack {
                ScrollView {
                    VStack(alignment: .center) {
                        Text("🤠")
                            .font(.system(size: 100))
                        
                        Text("This is the title")
                            .font(.title)
                            .lineLimit(2)
                            .bold()
                        
                        Text("Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.")
                            .multilineTextAlignment(.center)
                    }
                }
                .scrollIndicators(.hidden)
                .padding(.horizontal, 24)
                
                Button {
                    UIApplication.shared.open(URL(string: "https://www.google.com")!)
                } label: {
                    Text("Read More...")
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
                            .foregroundStyle(.black)
                            .bold()
                    }
                }
            }
        }
        .interactiveDismissDisabled()
    }
}

#Preview {
    AlertView()
}
