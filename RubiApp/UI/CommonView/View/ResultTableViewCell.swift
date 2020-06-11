//
//  ResultTableViewCell.swift
//  RubiApp
//
//  Created by 松木周 on 2020/04/09.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

/*Cell上のボタンタップを検知する方法
 disposeBagオブジェクトはセルの再利用のたびに新しく生成する必要がある。
 参考：https://qiita.com/katafuchix/items/5909fa2d38b5f5455df1
 */

import UIKit
import RxSwift

protocol HomeActionDelegate: AnyObject {
    func actionCell(_ actionCell: ResultTableViewCell, didTapSaveButton: UIButton)
}

class ResultTableViewCell: UITableViewCell {

    @IBOutlet public weak var hiraganaLabel: SubLabelStyle!
    @IBOutlet public weak var kanziLabel: MainLabelStyle!
    @IBOutlet public weak var saveButton: UIButton!

    var disposeBag = DisposeBag()
    var isTap = false
    weak var delegate: HomeActionDelegate?

    var convertInfo: ConvertedInfo! {

        didSet {
            hiraganaLabel.text = convertInfo.sentence
            kanziLabel.text = convertInfo.convertedSentence

            switch convertInfo.saveStatus {
            case .saved:
                saveButton.setImage(#imageLiteral(resourceName: "Save_done"), for: .normal)

            case .unSaved:
                saveButton.setImage(#imageLiteral(resourceName: "Save_not"), for: .normal)
                
            default:
                break
            }
        }

    }

    override func awakeFromNib() {
        super.awakeFromNib()

        self.disposeBag = DisposeBag()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }


    @IBAction func saveButtonTapped(_ sender: Any) {
        delegate?.actionCell(self, didTapSaveButton: saveButton)
    }


}
