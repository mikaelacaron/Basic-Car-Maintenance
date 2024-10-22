//
//  PageDimension.swift
//  Basic-Car-Maintenance
//
//  https://github.com/mikaelacaron/Basic-Car-Maintenance
//  See LICENSE for license information.
//

import Foundation

enum PageDimension {
   case A4 // swiftlint:disable:this identifier_name

    var pageWidth: CGFloat {
        switch self {
        case .A4:
            return 595.2
        }
    }
    
    var pageHeight: CGFloat {
        switch self {
        case .A4:
            return 841.8
        }
    }
    
    var size: CGSize {
        CGSize(width: pageWidth, height: pageHeight)
    }

}
