//
//  ChooseAppIconView.swift
//  Basic-Car-Maintenance
//
//  Created by Daniel Lyons on 10/11/23.
//

import SwiftUI

struct ChooseAppIconView: View {
  @State var viewModel: ChangeAppIconViewModel = .init()
  
  private func isSelected(_ icon: AppIcon) -> Bool {
    return viewModel.selectedAppIcon == icon
  }
  
  var body: some View {
    let columns = [
      GridItem(.flexible(minimum: 30, maximum: 300)),
      GridItem(.flexible(minimum: 30, maximum: 300))
    ]
    
    return Form {
      Section {
        HStack {
          Image(systemName: "apps.iphone")
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
  }
}

extension ChooseAppIconView {
  
  private struct IconChoice: View {
    let icon: AppIcon
    let isSelected: Bool
    var checkmarkImage: String {
      isSelected ? "checkmark.circle.fill" : "circle"
    }
    
    var body: some View {
      if let iconName = icon.iconName {
        GroupBox {
          HStack {
            Image(systemName: checkmarkImage)
              .foregroundStyle(.blue)
            Text(icon.description)
            Spacer()
          }
          Image(uiImage: icon.preview)
            .resizable()
            .aspectRatio(contentMode: .fit)
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
