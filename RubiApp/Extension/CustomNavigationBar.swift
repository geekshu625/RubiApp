//
//  CustomNavigationBar.swift
//  RubiApp
//
//  Created by 松木周 on 2020/04/09.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import UIKit

class HomeNavigationBar: UINavigationBar {
    override func awakeFromNib() {
        self.isTranslucent = false
        self.barTintColor = .theme
        self.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
}

class SavedNavigationBar: UINavigationBar {
    override func awakeFromNib() {
        self.isTranslucent = false
        self.barTintColor = .backgroud
        self.titleTextAttributes = [.foregroundColor: UIColor.navigaionTitle]
    }
}
