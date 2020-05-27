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
import SafariServices
import SVProgressHUD

final class HomeViewController: UIViewController, UITableViewDelegate {

    @IBOutlet private weak var textField: MainTextFieldStyle!
    @IBOutlet private weak var pasteButton: UIButton!
    @IBOutlet private weak var copyButton: UIButton!
    @IBOutlet private weak var searchButton: UIButton!
    @IBOutlet private weak var changedTextLabel: SubLabelStyle!
    @IBOutlet private weak var indicator: UIActivityIndicatorView!
    @IBOutlet private weak var resultTableView: UITableView!

    //swiftlint:disable:next line_length
    lazy var dataSource = RxTableViewSectionedAnimatedDataSource<HomeViewModel.SectionModel>.init(animationConfiguration: AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .none, deleteAnimation: .fade), configureCell: { [weak self] _, tableView, indexPath, item in
        guard let wSelf = self,
            let cell = tableView.dequeueReusableCell(withIdentifier: wSelf.cellId, for: indexPath) as? ResultTableViewCell
            else { return UITableViewCell() }
        cell.kanziLabel.text = item.kanzi
        cell.hiraganaLabel.text = item.hiragana.converted
        cell.saveButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                cell.isTap.toggle()
                let data = Vocabulary(value: ["hiragana": item.hiragana.converted, "kanzi": item.kanzi, "id": item.id])
                if cell.isTap == true {
                    wSelf.viewModel.createVocabulary(vocabulary: data)
                    cell.saveButton.setImage(#imageLiteral(resourceName: "Save_done"), for: .normal)
                } else {
                    wSelf.viewModel.deleteVocabulary(vocabulary: data)
                    cell.saveButton.setImage(#imageLiteral(resourceName: "Save_not"), for: .normal)
                }
            })
            .disposed(by: cell.disposeBag)
        return cell
    })

    private var viewModel: HomeViewModel!
    private let disposeBag = DisposeBag()
    private let backgroundTapGesture = UITapGestureRecognizer()
    private let cellId = "ResultTableViewCell"
    private let pasteboard = UIPasteboard.general
    private let alertSentence = "😭文字を入力してください"

    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .backgroud
        self.view.addGestureRecognizer(backgroundTapGesture)
        tabBarController?.tabBar.isTranslucent = false
        indicator.hidesWhenStopped = true

        resultTableView.register(UINib(nibName: "ResultTableViewCell", bundle: nil), forCellReuseIdentifier: cellId)
        resultTableView.tableFooterView = UIView()
        resultTableView.rx.setDelegate(self).disposed(by: self.disposeBag)

        viewModel = HomeViewModel()
        viewModel.dataObservable.bind(to: resultTableView.rx.items(dataSource: dataSource)).disposed(by: self.disposeBag)

        viewModel.isLoading
            .drive(indicator.rx.isAnimating)
            .disposed(by: disposeBag)

        viewModel.resultData
            .drive(onNext: { [weak self](hiragana) in
                self!.changedTextLabel.text = hiragana
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
                let encodeUrl = self!.toEncodeUrl(text: text!)
                guard let url = URL(string: encodeUrl) else { return }
                let safariViewController = SFSafariViewController(url: url)
                self?.present(safariViewController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)

        //Return Keyが押された時の処理
        textField.rx.controlEvent(.editingDidEndOnExit).asDriver()
            .drive(onNext: { [weak self] in
                if self?.textField.text?.count == 0 {
                    self?.changedTextLabel.text = self!.alertSentence
                    return
                }
                self?.viewModel.post(requestId: "record001", sentence: self!.textField.text!, outputType: "hiragana")
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

    private func toEncodeUrl(text: String) -> String {
        let urlString: String = "https://dictionary.goo.ne.jp/srch/all/\(text)/m0u/"
        let encodeUrlString: String = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return encodeUrlString
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
