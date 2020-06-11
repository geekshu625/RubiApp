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

final class SavedViewController: UIViewController, AlertProtocol, PropertyInjectable {

    @IBOutlet private weak var savedTableView: UITableView!
    @IBOutlet private weak var settingButton: UIBarButtonItem!

    struct Dependency {
        let savedViewModel: SavedViewModel
    }

    var dependency: Dependency!

    private var convertInfo =  [ConvertedInfo]()
    private var viewModel: SavedViewModel!
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        AppDelegate.resolver.injectToSavedViewController(self)
        viewModel = dependency.savedViewModel

        self.view.backgroundColor = .backgroud
        tabBarController?.tabBar.isTranslucent = false

        savedTableView.register(R.nib.resultTableViewCell)
        savedTableView.tableFooterView = UIView()
        savedTableView.allowsSelection = false
        savedTableView.rx.setDelegate(self).disposed(by: self.disposeBag)
        savedTableView.rx.setDataSource(self).disposed(by: self.disposeBag)

        settingButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                SavedRouter.moveToSettingViewController(from: self!)
            })
            .disposed(by: disposeBag)
    }

    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchAllVocabulary()
    }

}

extension SavedViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return convertInfo.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.resultTableViewCell, for: indexPath)!

        cell.convertInfo = convertInfo[indexPath.row]

        return cell
    }

}
