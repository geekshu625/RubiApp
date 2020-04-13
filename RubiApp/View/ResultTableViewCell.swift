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

class ResultTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var hiraganaLabel: SubLabelStyle!
    @IBOutlet private weak var kanziLabel: MainLabelStyle!
    @IBOutlet private weak var saveButton: UIButton!
    
    var disposeBag = DisposeBag()
    var isTap = false

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.disposeBag = DisposeBag()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
