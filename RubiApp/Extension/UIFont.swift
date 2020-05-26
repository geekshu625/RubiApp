//
//  UIFont.swift
//  RubiApp
//
//  Created by 松木周 on 2020/04/09.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import UIKit

extension UIFont {
    private static func apply(size: CGFloat, weight: UIFont.Weight) -> UIFont {
        return self.systemFont(ofSize: size, weight: weight)
    }

    static func mainTitle() -> UIFont {
        createFont(isiPhone: 25, isiPad: 30, weight: .bold)
    }

    static func subTitle() -> UIFont {
        createFont(isiPhone: 15, isiPad: 25, weight: .semibold)
    }

    static func textFiledStyle() -> UIFont {
        createFont(isiPhone: 20, isiPad: 25, weight: .semibold)
    }


    static func createFont(isiPhone: CGFloat, isiPad: CGFloat, weight: UIFont.Weight) -> UIFont {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return self.apply(size: isiPhone, weight: weight)
        case .pad:
            return self.apply(size: isiPad, weight: weight)
        default:
            break
        }
        return self.apply(size: isiPhone, weight: weight)
    }

}
