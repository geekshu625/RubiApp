//
//  UITextField.swift
//  RubiApp
//
//  Created by 松木周 on 2020/04/10.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import UIKit

@IBDesignable class MainTextFieldStyle: UITextField {
    override func awakeFromNib() {
        self.font = .textFiledStyle()
    }
}
