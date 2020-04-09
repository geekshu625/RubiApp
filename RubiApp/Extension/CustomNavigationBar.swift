//
//  CustomNavigationBar.swift
//  RubiApp
//
//  Created by 松木周 on 2020/04/09.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import UIKit

class CustomNavigationBar: UINavigationBar {
    override func awakeFromNib() {
        self.isTranslucent = false
        self.barTintColor = .theme
        self.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
}
