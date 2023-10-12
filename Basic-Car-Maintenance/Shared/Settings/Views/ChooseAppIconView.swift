//
//  ChooseAppIconView.swift
//  Basic-Car-Maintenance
//
//  Created by Daniel Lyons on 10/11/23.
//

import SwiftUI

struct ChooseAppIconView: View {
  @Bindable var viewModel: ChangeAppIconViewModel
  
  func isSelected(_ icon: AppIcon) -> Bool {
    return viewModel.selectedAppIcon == icon
  }
  
  var body: some View {
    let columns = [
      GridItem(.flexible(minimum: 30, maximum: 300)),
      GridItem(.flexible(minimum: 30, maximum: 300))
    ]
    
    return Form {
      Section {
        Text("Choose the App Icon that you would like to see on your Home Screen.")
      }
      
      LazyVGrid(columns: columns) {
        ForEach(AppIcon.allCases) { icon in
          IconChoice(icon: icon, isSelected: self.isSelected(icon))
            .onTapGesture {
              withAnimation {
                viewModel.selectedAppIcon = icon
              }
            }
        }
        
      }
      
    }
    .navigationTitle("Choose App Icon")
  }
}

extension ChooseAppIconView {
  
  private struct IconChoice: View {
    let icon: AppIcon
    let isSelected: Bool
    var body: some View {
      if let iconName = icon.iconName {
        GroupBox(icon.iconName ?? "Icon") {
          Image(iconName, label: Text(iconName))
            .resizable()
            .scaledToFill()
            .overlay(alignment: .bottomTrailing) {
              Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                .foregroundStyle(.blue)
            }
        }
      } else {
        EmptyView()
      }
    }
  }
}

#Preview {
  ChooseAppIconView(viewModel: .init())
}
