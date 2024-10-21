//
//  ChooseAppIconView.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import SwiftUI

struct ChooseAppIconView: View {
    @State private var viewModel: ChooseAppIconViewModel = .init()
    
    private func isSelected(_ icon: AppIcon) -> Bool {
        return viewModel.selectedAppIcon == icon
    }
    
    private let columns = [
        GridItem(.flexible(minimum: 30, maximum: 300)),
        GridItem(.flexible(minimum: 30, maximum: 300))
    ]
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Image(systemName: SFSymbol.iPhoneWithApps)
                        .font(.title)
                    Text("This App Icon will appear on your Home Screen.")
                }
            }
            
            LazyVGrid(columns: columns) {
                ForEach(AppIcon.allCases) { icon in
                    IconChoice(icon: icon, isSelected: self.isSelected(icon))
                        .onTapGesture {
                            withAnimation {
                                viewModel.updateAppIcon(to: icon)
                            }
                        }
                }
            }
        }
        .navigationTitle("Choose App Icon")
        .analyticsView("\(Self.self)")
    }
}

extension ChooseAppIconView {
    
    private struct IconChoice: View {
        let icon: AppIcon
        let isSelected: Bool
        var checkmarkImage: String {
            isSelected ? SFSymbol.checkmarkFill : SFSymbol.circle
        }
        
        var body: some View {
            GroupBox {
                HStack {
                    Image(systemName: checkmarkImage)
                        .foregroundStyle(.blue)
                    Text(icon.description)
                    Spacer()
                }
                Image(icon.previewImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(.rect(cornerRadius: 20))
            }
        }
    }
}

#Preview {
    ChooseAppIconView()
}
