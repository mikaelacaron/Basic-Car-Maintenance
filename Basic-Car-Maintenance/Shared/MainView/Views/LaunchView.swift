//
//  LaunchView.swift
//  Basic-Car-Maintenance
//
//  Created by Mitali Gondaliya on 20/10/23.
//

import SwiftUI

struct LaunchView: View {
    
    @State var isActive: Bool = false
    
    let appIconViewModel: ChooseAppIconViewModel
    
    init(appIconViewModel: ChooseAppIconViewModel) {
        self.appIconViewModel = ChooseAppIconViewModel()
    }
    
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
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation {
                    self.isActive = true
                }
            }
        }
    }
}

#Preview {
    LaunchView(appIconViewModel: ChooseAppIconViewModel())
}
