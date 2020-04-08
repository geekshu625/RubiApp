//
//  ViewController.swift
//  RubiApp
//
//  Created by 松木周 on 2020/04/08.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    let titleLabel = UILabel()
    let client: HiraganaAPIClientProtocol
    
    init?(client: HiraganaAPIClientProtocol = HiraganaAPIClient()) {
        self.client = client
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.client = HiraganaAPIClient()
        super.init(coder: coder)
    }

    override func encode(with coder: NSCoder) {
        super.encode(with: coder)
    }

    override func encodeRestorableState(with coder: NSCoder) {
        super.encodeRestorableState(with: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        titleLabel.textColor = .black
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)
        
        titleLabel.topAnchor
        .constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16) .isActive = true
        titleLabel.leftAnchor
        .constraint(equalTo: view.leftAnchor, constant: 16) .isActive = true
        
        client.post { (hiragana) in
            guard
                let hiragana = hiragana,
                0 < hiragana.count else { return }
            self.titleLabel.text = hiragana[0].converted
        }
        
    }
}

