//
//  ContributionTip.swift
//  Basic-Car-Maintenance
//
//  Created by Sandro Dahl on 24.10.23.
//

import TipKit

struct ContributionTip: Tip {
    var title: Text {
        Text("Thanks for using this app!", comment: "Thanks a user for using the app.")
    }

    var message: Text? {
        // swiftlint:disable:next line_length
        Text("It's open source and anyone can contribute to it.", comment: "Tells the user they can contribute to the codebase.")
    }

    var image: Image? {
      Image(systemName: "heart")
    }
}
