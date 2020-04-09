//
//  UILabel.swift
//  RubiApp
//
//  Created by 松木周 on 2020/04/09.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import UIKit
@IBDesignable class MainLabelStyle: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.font = UIFont.mainTitle()
        self.textAlignment = .center
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
}

@IBDesignable class SubLabelStyle: UILabel {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.font = UIFont.subTitle()
        self.textAlignment = .center
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
    }
    
}
