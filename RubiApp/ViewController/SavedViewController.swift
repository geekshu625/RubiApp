//
//  SavedViewController.swift
//  RubiApp
//
//  Created by 松木周 on 2020/04/09.
//  Copyright © 2020 ShuMatsuki. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class SavedViewController: UIViewController, UITableViewDelegate{
    
    @IBOutlet weak var savedTableView: UITableView!
    
    lazy var dataSource = RxTableViewSectionedAnimatedDataSource<SavedViewModel.SectionModel>.init(animationConfiguration: AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .none, deleteAnimation: .fade), configureCell: { [weak self] dataSource, tableView, indexPath, item in
        guard let wSelf = self,
            let cell = tableView.dequeueReusableCell(withIdentifier: wSelf.CELL_ID, for: indexPath) as? ResultTableViewCell
        else { return UITableViewCell() }
        cell.kanziLabel.text = item.vocabulary.kanzi
        cell.hiraganaLabel.text = item.vocabulary.hiragana
        cell.saveButton.setImage(#imageLiteral(resourceName: "Save_done"), for: .normal)
        cell.saveButton.isEnabled = false
        return cell
    })
    
    private var viewModel: SavedViewModel!
    private let disposeBag = DisposeBag()
    private let CELL_ID = "ResultTableViewCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = .backgroud
        tabBarController?.tabBar.isTranslucent = false
        
        savedTableView.register(UINib(nibName: "ResultTableViewCell", bundle: nil), forCellReuseIdentifier: CELL_ID)
        savedTableView.tableFooterView = UIView()
        savedTableView.rx.setDelegate(self).disposed(by: self.disposeBag)
        
        viewModel = SavedViewModel()
        viewModel.dataObservable.bind(to: savedTableView.rx.items(dataSource: dataSource)).disposed(by: self.disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetch()
    }

}
