//
//  ContributorsProfileView.swift
//  Basic-Car-Maintenance
//
//  Created by Yashraj jadhav on 01/10/23.
//

import SwiftUI

struct ContributorsProfileView: View {
    
    let name: String
    let imgUrl: String
    private let imgFrame: CGFloat = 30

    init(name: String, url: String) {
        self.name = name
        self.imgUrl = url
    }

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: imgUrl)!) { phase in
                switch phase {
                case .empty:
                    
                    Image(systemName: "person.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: imgFrame, height: imgFrame)
                        .foregroundColor(.gray)
                case .success(let image):
                    
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: imgFrame, height: imgFrame)
                        .clipShape(Circle())
                case .failure:
                    
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: imgFrame, height: imgFrame)
                        .foregroundColor(.gray)
                @unknown default:
                    
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: imgFrame, height: imgFrame)
                        .foregroundColor(.gray)
                }
            }
            
            Text(name)
        }
    }
}

#Preview {
    ContributorsProfileView(name: "mikaela", url: "https://avatars.githubusercontent.com/u/22946902?v=4")
}
