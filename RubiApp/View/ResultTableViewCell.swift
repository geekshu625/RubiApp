//
//  ResultTableViewCell.swift
//  RubiApp
//
//  Created by 松木周 on 2020/04/09.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import UIKit

//HomeViewControllerに継承して、Cell側でクロージャー処理を受け取れるようにする
protocol ResultTableViewCellDelegate {
    func didTapSaveButton(tableViewCell: UITableViewCell, button: UIButton)
}

class ResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var hiraganaLabel: SubLabelStyle!
    @IBOutlet weak var kanziLabel: MainLabelStyle!
    @IBOutlet weak var saveButton: UIButton!
    
    var delegate: ResultTableViewCellDelegate?

    override func awakeFromNib() {
        super.awakeFromNib()
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func saveButtonTapped(button: UIButton) {
        self.delegate?.didTapSaveButton(tableViewCell: self, button: button)
    }
}
