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

class HomeViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var textField: MainTextFieldStyle!
    @IBOutlet weak var pasteButton: UIButton!
    @IBOutlet weak var copyButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var changedTextLabel: SubLabelStyle!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var resultTableView: UITableView!
    private let backgroundTapGesture = UITapGestureRecognizer()
    
    lazy var dataSource = RxTableViewSectionedAnimatedDataSource<HomeViewModel.SectionModel>.init(animationConfiguration: AnimationConfiguration(insertAnimation: .fade, reloadAnimation: .none, deleteAnimation: .fade), configureCell: { [weak self] dataSource, tableView, indexPath, item in
        guard let wSelf = self,
            let cell = tableView.dequeueReusableCell(withIdentifier: "ResultTableViewCell", for: indexPath) as? ResultTableViewCell
        else { return UITableViewCell() }
        cell.kanziLabel.text = item.hiragana.converted
        return cell
        
    })
    
    private var viewModel: HomeViewModel!
    private let disposeBag = DisposeBag()
    private let pasteboard = UIPasteboard.general
    private let alertSentence = "😭文字を入力してください"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .backgroud
        self.view.addGestureRecognizer(backgroundTapGesture)
        tabBarController?.tabBar.isTranslucent = false
        indicator.hidesWhenStopped = true
        
        resultTableView.register(UINib(nibName: "ResultTableViewCell", bundle: nil), forCellReuseIdentifier: "ResultTableViewCell")
        resultTableView.tableFooterView = UIView()
        resultTableView.rx.setDelegate(self).disposed(by: self.disposeBag)
        
        viewModel = HomeViewModel()
        viewModel.dataObservable.bind(to: resultTableView.rx.items(dataSource: dataSource)).disposed(by: self.disposeBag)
        
        viewModel.isLoading
        .drive(indicator.rx.isAnimating)
        .disposed(by: disposeBag)
        
        pasteButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                self?.dismissKeyBoard()
                self?.textField.text = self!.pasteboard.value(forPasteboardType: "public.text") as! String
            })
            .disposed(by: disposeBag)
        
        copyButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                self?.dismissKeyBoard()
                //完了アラートを表示
                self?.pasteboard.setValue(self!.textField.text, forPasteboardType: "public.text")
            })
            .disposed(by: disposeBag)
        
        searchButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                self!.dismissKeyBoard()
                let text = self!.textField.text
                if text?.count == 0 {
                    //アラートを表示
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
                }
                self?.viewModel.post(request_id: "record001", sentence: self!.textField.text!, output_type: "hiragana")
            })
            .disposed(by: disposeBag)
        
        textField.rx.controlEvent(.editingDidBegin).asDriver()
            .drive(onNext: { [weak self] in
                self?.textField.text = ""
                self?.changedTextLabel.text = ""
            })
            .disposed(by: disposeBag)
        
        backgroundTapGesture.rx.event.asDriver()
            .drive(onNext: { [weak self](UITapGestureRecognizer) in
                self?.dismissKeyBoard()
            })
        .disposed(by: disposeBag)
    
    }
    
    private func toEncodeUrl(text: String) -> String{
        let urlString: String = "https://dictionary.goo.ne.jp/srch/all/\(text)/m0u/"
        let encodeUrlString: String = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        return encodeUrlString
    }
    
    private func dismissKeyBoard() {
        self.view.endEditing(false)
    }

}
