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
import SafariServices
import SVProgressHUD
import DIKit

final class HomeViewController: UIViewController, PropertyInjectable {

    @IBOutlet private weak var textField: MainTextFieldStyle!
    @IBOutlet private weak var pasteButton: UIButton!
    @IBOutlet private weak var copyButton: UIButton!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var changedTextLabel: SubLabelStyle!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
    @IBOutlet private weak var resultTableView: UITableView!

    struct Dependency {
        let homeViewModel: HomeViewModel
    }

    var dependency: Dependency!

    private var convertInfo =  [ConvertedInfo]()
    private var viewModel: HomeViewModel!
    private let disposeBag = DisposeBag()
    private let backgroundTapGesture = UITapGestureRecognizer()
    private let pasteboard = UIPasteboard.general
    private let alertSentence = "😭文字を入力してください"

    override func viewDidLoad() {
        super.viewDidLoad()

        AppDelegate.resolver.injectToHomeViewController(self)
        viewModel = dependency.homeViewModel

        self.view.backgroundColor = .backgroud
        self.view.addGestureRecognizer(backgroundTapGesture)
        tabBarController?.tabBar.isTranslucent = false
        indicator.hidesWhenStopped = true

        resultTableView.register(R.nib.resultTableViewCell)
        resultTableView.tableFooterView = UIView()
        resultTableView.rx.setDelegate(self).disposed(by: self.disposeBag)
        resultTableView.rx.setDataSource(self).disposed(by: self.disposeBag)

        viewModel.isLoading
            .drive(indicator.rx.isAnimating)
            .disposed(by: disposeBag)

        viewModel.loadComplete
            .drive(onNext: { [weak self] (info) in
                self!.convertInfo = info
                self!.resultTableView.reloadData()
            })
            .disposed(by: disposeBag)

        viewModel.sentence
            .drive(onNext: { [weak self] (sentence) in
                self?.changedTextLabel.text = sentence
            })
            .disposed(by: disposeBag)

        pasteButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                self?.dismissKeyBoard()
                self?.textField.text = self!.pasteboard.value(forPasteboardType: "public.text") as? String
            })
            .disposed(by: disposeBag)

        copyButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                self?.dismissKeyBoard()
                self?.pasteboard.setValue(self!.textField.text, forPasteboardType: "public.text")
                SVProgressHUD.showSuccess(withStatus: "コピーに成功しました")
                SVProgressHUD.dismiss(withDelay: 1.0)
            })
            .disposed(by: disposeBag)

        searchButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                self!.dismissKeyBoard()
                let text = self!.textField.text
                if text?.count == 0 {
                    self?.changedTextLabel.text = self!.alertSentence
                    return
                }

                HomeRouter.moveToSearchWordWebView(from: self!, searchSentence: text!)

            })
            .disposed(by: disposeBag)

        //Return Keyが押された時の処理
        textField.rx.controlEvent(.editingDidEndOnExit).asDriver()
            .drive(onNext: { [weak self] in
                if self?.textField.text?.count == 0 {
                    self?.changedTextLabel.text = self!.alertSentence
                    return
                }
                self?.viewModel.convert(sentence: self!.textField.text!)
            })
            .disposed(by: disposeBag)

        textField.rx.controlEvent(.editingDidBegin).asDriver()
            .drive(onNext: { [weak self] in
                self?.textField.text = ""
            })
            .disposed(by: disposeBag)

        backgroundTapGesture.rx.event.asDriver()
            .drive(onNext: { [weak self](_) in
                self?.dismissKeyBoard()
            })
            .disposed(by: disposeBag)

        //通信時にエラーが発生した場合にアラートを表示
        viewModel.alertTrigger.asObservable()
            .bind { (message) in
                self.showAlert(message: message)
        }
        .disposed(by: disposeBag)

    }

    private func dismissKeyBoard() {
        self.view.endEditing(false)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let defAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(defAction)
        self.present(alert, animated: true, completion: nil)
    }

}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return convertInfo.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: R.reuseIdentifier.resultTableViewCell, for: indexPath)!

        cell.convertInfo = convertInfo[indexPath.row]
        cell.delegate = self

        return cell
    }

}

extension HomeViewController: HomeActionDelegate {

    func actionCell(_ actionCell: ResultTableViewCell, didTapSaveButton: UIButton) {

    }

}
