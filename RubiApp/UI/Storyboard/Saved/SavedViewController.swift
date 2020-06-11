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
import RealmSwift

final class SavedViewController: UIViewController, AlertProtocol, PropertyInjectable {

    @IBOutlet private weak var savedTableView: UITableView!
    @IBOutlet private weak var settingButton: UIBarButtonItem!

    struct Dependency {
        let savedViewModel: SavedViewModel
    }

    var dependency: Dependency!
    //TODO: DIするためにViewModelに記載する
    var savelistArray: Results<Savelist> = {
        return SavelistManager.getAll()
    }()

    var notificationToken: NotificationToken?
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

        // Realm更新時、reloadDataする
        notificationToken = savelistArray.observe({ [weak self] (change) in
            guard let tableView = self?.savedTableView else { return }

            switch change {
            case .initial:
                tableView.reloadData()
            case .update(_, deletions: let deletions, insertions: let insertions, modifications: let modifications):
                tableView.beginUpdates()
                tableView.insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                     with: .automatic)
                tableView.reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                     with: .automatic)
                tableView.endUpdates()
            case .error(let error):
                // TODO: エラー処理
                fatalError("\(error)")
                break
            }
        })

        settingButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                SavedRouter.moveToSettingViewController(from: self!)
            })
            .disposed(by: disposeBag)
    }

}

extension SavedViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savelistArray.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.resultTableViewCell, for: indexPath)!

        let savelist = savelistArray[indexPath.row]
        cell.convertInfo = ConvertedInfo(sentence: savelist.hiragana, convertedSentence: savelist.kanzi, saveStatus: SaveStatus.saved, id: savelist.id)
        cell.delegate = self

        return cell
    }

}

extension SavedViewController: HomeActionDelegate {

    func actionCell(_ actionCell: ResultTableViewCell, didTapSaveButton: UIButton) {

        let savelist = Savelist()
        savelist.hiragana = actionCell.convertInfo.sentence
        savelist.kanzi = actionCell.convertInfo.convertedSentence
        savelist.id = actionCell.convertInfo.id

        viewModel.deleteSavelist(savelist: savelist)

    }

}

