//
//  LaunchView.swift
//  Basic-Car-Maintenance
//
//  Created by Mitali Gondaliya on 20/10/23.
//

import SwiftUI

struct LaunchView: View {
    @State private var appIconViewModel = ChooseAppIconViewModel()
    @State var isActive: Bool = false
    
    var body: some View {
        VStack {
            if self.isActive {
                MainTabView()
            } else {
                Image(uiImage: appIconViewModel.selectedAppIcon.preview)
                    .resizable()
                    .scaledToFit()
                    .clipShape(.rect(cornerRadius: 20))
                    .frame(width: 200, height: 200)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    LaunchView()
}
