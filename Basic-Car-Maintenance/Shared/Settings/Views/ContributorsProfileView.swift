//
//  ContributorsProfileView.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import SwiftUI

struct ContributorsProfileView: View {
    
    let contributor: Contributor
    
    @ScaledMetric(relativeTo: .largeTitle) private var imageSize: CGFloat = 50

    var body: some View {
        HStack {
            AsyncImage(url: URL(string: contributor.avatarURL)!) { phase in
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
            
            VStack(alignment: .leading) {
                Text(contributor.login)
                    .bold()
                
                Text(
                    "^[\(contributor.contributions) contributions](inflect: true)",
                    comment: "the number of contributions by a contributor"
                )
                .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    ContributorsProfileView(
        contributor: Contributor(
            login: "",
            id: 1,
            nodeID: "",
            avatarURL: "https://avatars.githubusercontent.com/u/22946902?v=4",
            url: "",
            htmlURL: "",
            contributions: 100
        )
    )
}
