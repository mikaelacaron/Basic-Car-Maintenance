//
//  ContributorsProfileView.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import SwiftUI

struct ContributorsProfileView: View {
    
    let name: String
    let imgUrl: String
    @ScaledMetric(relativeTo: .largeTitle) var imageSize: CGFloat = 50

    init(name: String, url: String) {
        self.name = name
        self.imgUrl = url
    }

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: imgUrl)!) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                        .frame(width: imageSize, height: imageSize)
                    
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: imageSize, height: imageSize)
                        .clipShape(Circle())
                    
                case .failure:
                    Image(systemName: SFSymbol.personCircle)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: imageSize, height: imageSize)
                        .foregroundColor(.gray)
                    
                @unknown default:
                    Image(systemName: SFSymbol.personCircle)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: imageSize, height: imageSize)
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
