//
//  HomeViewController.swift
//  RubiApp
//
//  Created by 松木周 on 2020/04/09.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class HomeViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var textView: MainTextViewStyle!
    @IBOutlet weak var pasteButton: UIButton!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var changedTextLabel: SubLabelStyle!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var resultTableView: UITableView!
    
    lazy var dataSource = RxTableViewSectionedAnimatedDataSource<HomeViewModel.SectionModel>.init(animationConfiguration: AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .none, deleteAnimation: .fade), configureCell: { [weak self] dataSource, tableView, indexPath, item in
        guard let wSelf = self,
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResultTableViewCell", for: indexPath) as? ResultTableViewCell
        else { return UITableViewCell() }
        cell.kanziLabel.text = item.hiragana.converted
        return cell
        
    })
    
    private var viewModel: HomeViewModel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Rubi翻訳"
        self.view.backgroundColor = .backgroud
        
        resultTableView.register(UINib(nibName: "ResultTableViewCell", bundle: nil), forCellReuseIdentifier: "ResultTableViewCell")
        resultTableView.rx.setDelegate(self).disposed(by: self.disposeBag)
        viewModel.dataObservable.bind(to: resultTableView.rx.items(dataSource: dataSource)).disposed(by: self.disposeBag)

    }
    

}
