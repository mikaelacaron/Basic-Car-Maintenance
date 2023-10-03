//
//  InfoViewModel.swift
//  Basic-Car-Maintenance
//
//  Created by Yashraj jadhav on 01/10/23.
//

import Foundation
import SwiftUI

class AboutAppViewModel {
    var title: String {
        return appName
    }
    
    var message: LocalizedStringKey {
        return "Thanks For Using"
    }
    
    let imageName: String = "logo"
    
    private var appName: String {
        return Bundle.main.infoDictionary?[kCFBundleNameKey as String] as? String ?? "Basic Car Maintenance"
    }

    var infoText: LocalizedStringKey {
        return "Basic-Car-Maintenance"
    }
    
    var openSourceRemark: LocalizedStringKey {
        return "If You Want To Contribute"
    }
}
