# RubiApp
入力した漢字にルビを振るアプリ。  
[docomo Developer support](https://dev.smt.docomo.ne.jp/?p=index)が提供するひらがな化APIを使用しています。

以下Demo動画です。  
![rubigit.gif](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/302458/2e9fcaf7-d83b-1c56-01ab-c80d89a139dc.gif)


# 環境
- Xcode: 11.5
- Swift: 5.2
- Cocoapod: 1.9.1 
- Carthage: 0.34.0 

# セットアップ
## cloneしてからすること

プロジェクトをクローンしてからターミナルやiTtermで以下のコマンドを実行して下さい

```
$ make bootstrap
```
and

```
$ make project
```
## ビルド前にすること

①[docomo Developer support](https://dev.smt.docomo.ne.jp/?p=index)でひらがな化APIを使用することを申請しAPIKeyを発行して下さい。  
②RubiApp/API/APIKey.swiftにあるの環境変数に取得したAPIKeyを入いれて下さい。

```
let APIKey = "ここにAPIKeyをいれてください"
```

# 開発駆動
issueに基づいた開発を行い、提出までの調整はTrelloで管理するようにしました。
github-actionsでissueの作成とTrelloでのカード作成を紐付けています。  
今回使用した[Trelloのボード](https://trello.com/invite/b/kp3OYroF/65a3f8d1a51b785b0d642ea93f456b9d/%E9%81%B8%E8%80%83%E8%AA%B2%E9%A1%8C)はこちらです。  


# ブランチ
ブランチは、master・dev・feature/issue番号/行うことの3つで運用しました。  
各ブランチ説明は以下です。  

master: リリースした時点のソースコードを管理するブランチ  
dev(masterから派生): 開発作業の主軸となるブランチ  
feature/issue番号/行うこと(devから派生): 実装する機能毎のブランチ  

# デザインパターン
MVVMを採用しました。  
それぞれの責務の認識は以下です。  

![スクリーンショット 2020-04-14 15.11.55.png](https://qiita-image-store.s3.ap-northeast-1.amazonaws.com/0/302458/0dd91161-b1f8-b2ae-9855-b03d9100fab2.png)

>画像の引用元[MVVMとMVPパターン](https://qiita.com/gdate/items/512f6fb9aba2a35a04e3)  

### MVVMにした背景
コンポーネント別で作業分担が明確にでき、FatViewControllerを避けることができるため。  
また、個人的にRxSwiftでのバインディング処理を学びなおしたかったからです！

# 反省点
今回の課題に取り組んだ中で4つの反省点がありました。

## 画面レイアウト
今回、画面レイアウト作成はStoryboardを使用しました。   
個人的にコードレイアウトほうが、テストの書きやすさや抽象化できるという点で便利だと感じています。しかし、これまで関わったプロジェクトでは比較的にStoryboardが多く、コードレイアウトサイクルの知識に対して自信がなかったためStoryboardを使用しました。

## テスト
テストに関して知識不足で、まだまだ実践的に書けるレベルになっていません。。。  
唯一書けたユニットテストは、APIデータを受け取る構造体が正しいかどうかをテストです。  

## リアクティブ
RxSwiftがまだまだ理解できておらず、実装出来なかった部分がありました。  
以下です  

```
What: RealmDBにデータがあるかないかによってUIを変更するようにしたかった。  
How: RealmDBをObservableで監視する。  
why(できなかった理由): cellが1つの場合だと可能だったが、cellが2つになった場合に他の結果の影響を受けてしまった。HotやCold、ストリームの理解が足りなかったです。
```

## コミット
devブランチから切ってfeatureブランチを作成していたのですが、作業後にrebaseではなくmergeを使用する癖がついており、mergeのログでコミットログが見えづらくなってしまっています。作業後半で気付いたことだったので既遅しでした、、、  
そもそもコミットログへの配慮が足りていないことが原因です。
また、commitメッセージの書き方もまちまちで自分でも納得できていない状態です。


# 参考文献
RxRealmについて
- http://rx-marin.com/post/dotswift-rxswift-rxrealm-unidirectional-dataflow/
- https://github.com/RxSwiftCommunity/RxRealm
- https://qiita.com/katafuchix/items/5909fa2d38b5f5455df1

MVVMについて
- https://qiita.com/tamappe/items/1de1e1ec0a03ce4bb2f5

Carthageについて
- https://qiita.com/yutat93/items/97fe9bc2bf2e97da7ec1

Github Actionsについて
- https://qiita.com/Tommydevelop/items/e26654447e43edd4286e
