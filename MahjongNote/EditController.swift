//
//  EditController.swift
//  MahjongNote
//
//  Created by 藤井勇樹 on 2018/08/12.
//  Copyright © 2018 mahcial. All rights reserved.
//

import Foundation
import UIKit

class EditController : UIViewController, UITextFieldDelegate {
    let gameTable: UIScrollView = UIScrollView()
    
    // 合計点
    let number = UITextField()
    let yourTotalScoreField = UITextField()
    let playerATotalScoreField = UITextField()
    let playerBTotalScoreField = UITextField()
    let playerCTotalScoreField = UITextField()
    var yourTotalScore = 0
    var playerATotalScore = 0
    var playerBTotalScore = 0
    var playerCTotalScore = 0
    
    // 名前
    let yourName = UITextField()
    let playerAName = UITextField()
    let playerBName = UITextField()
    let playerCName = UITextField()
    var playerANameString:String = ""
    var playerBNameString:String = ""
    var playerCNameString:String = ""
    
    // 得点管理用配列
    var gameRows: [UIStackView] = []
    var scoreFieldArray:[[UITextField]] = []
    var scoreArray: [[Int]] = []
    var rowYPosition: CGFloat = 0
    var nowRow = 0
    var initRow = 10
    var isSelectedField:UITextField!
    var nowInputNumber:String = ""
    
    // 場代
    let inputGamePayment = UITextField()
    var gamePayment:Int = 0
    
    // レート
    let inputRate = UITextField()
    var gameRate:Int = 0
    
    // 日付入力用
    let dateField = UITextField()
    var datePicker: UIDatePicker = UIDatePicker()
    var date: String = ""
    
    // 画像保存用
    
    
    // 画面サイズ
    var rowHeight: CGFloat!
    var rowWidth: CGFloat!
    var contentsHeight: CGFloat!
    var topContentsHeight: CGFloat!
    var tableContentsHeight: CGFloat!
    
    // 行
    var playerRow: UIStackView!
    var scoreRow: UIStackView!
    
    // カラーセット
    let lightGray: UIColor = UIColor(red: 0.92, green: 0.92, blue: 0.92, alpha: 1.0)
    let superLightGray: UIColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.0)
    let gray: UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
    let green: UIColor = UIColor(red: 0.27, green: 0.75, blue: 0.55, alpha: 1.0)
    let black: UIColor = UIColor(red: 0.3, green: 0.3, blue: 0.3, alpha: 1.0)
    let blue: UIColor = UIColor(red: 0.121569, green: 0.466667, blue: 0.705882, alpha: 1.0)
    let red: UIColor = UIColor(red: 0.89, green: 0.29, blue: 0.29, alpha: 1.0)
    
    // キーボードが閉じているかのフラグ
    // キーボードが開いてるときは、入力が完了してないので、対局の保存完了はさせない
    var keyboardClosedFlag = false
    
    // 「キャンセル」ボタン押下時の処理
    @IBAction func cancelButton(_ sender: UIBarButtonItem) {
        // 入力されたデータが削除されたか大丈夫かのポップアップ
        // アラートを作成
        let alert = UIAlertController(
            title: "入力のキャンセル",
            message: "入力した内容はリセットされます",
            preferredStyle: .alert)
        // アラートにボタンをつける
        alert.addAction(UIAlertAction(title: "戻る", style: .default, handler: { action in
        }))
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            //  トップ画面に遷移
            if let tabvc = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController  {
                // トップに戻る(0が一番左)
                DispatchQueue.main.async {
                    tabvc.selectedIndex = 0
                    self.initView()
                }
            }
        }))
        // アラート表示
        self.present(alert, animated: true, completion: nil)
    }
    // 「完了」ボタン押下時の処理
    @IBAction func finishButton(_ sender: UIBarButtonItem) {
        // 場代を保存
        if let payment = inputGamePayment.text {
            if (payment != "") {
                gamePayment = Int(payment)!
            }
        }
        // レートを保存
        if let rate = inputRate.text {
            if (rate != "") {
                gameRate = Int(rate)!
            }
        }
        // 名前を保存
        if let aName = playerAName.text {
            if (aName != "") {
                playerANameString = aName
            } else {
                playerANameString = "NoName"
            }
        }
        if let bName = playerBName.text {
            if (bName != "") {
                playerBNameString = bName
            } else {
                playerBNameString = "NoName"
            }
        }
        if let cName = playerCName.text {
            if (cName != "") {
                playerCNameString = cName
            } else {
                playerCNameString = "NoName"
            }
        }

        if (keyboardClosedFlag) {
            // バリデーションチェック
            let emptyCell = validationCheckEmptyCells()
            if (validationCheckEmptyInput()) {
                // アラートを作成
                let alert = UIAlertController(
                    title: "入力データがありません",
                    message: "対局データを入力してください",
                    preferredStyle: .alert)
                // アラートにボタンをつける
                alert.addAction(UIAlertAction(title: "戻る", style: .default, handler: { action in
                }))
                // アラート表示
                self.present(alert, animated: true, completion: nil)
            } else if (emptyCell != 0) {
                // アラートを作成
                let alert = UIAlertController(
                    title: "入力データが不完全です",
                    message: String(emptyCell)+"局目の対局データを入力してください",
                    preferredStyle: .alert)
                // アラートにボタンをつける
                alert.addAction(UIAlertAction(title: "戻る", style: .default, handler: { action in
                }))
                // アラート表示
                self.present(alert, animated: true, completion: nil)
            } else {
                var title = ""
                var message = ""
                // 場代チェックバリデーション
                if (validationCheckEmptyGamePayment()) {
                    title += "場代が入力されていません"
                    message += "場代0円で保存を完了しますか?"
                }
                // レートチェックバリデーション
                if (validationCheckEmptyRate()) {
                    if (title != "") {
                        title += "\n"
                        message += "\n"
                    }
                    title += "レートが入力されていません"
                    message += "ノーレートで保存を完了しますか?"
                }
                // プレイヤー名チェックバリデーション
                if (validationCheckEmptyPlayerName()) {
                    if (title != "") {
                        title += "\n"
                        message += "\n"
                    }
                    title += "名前が入力されていないプレイヤーがいます"
                    message += "プレイヤー名をNoNameで完了しますか?"
                }
                // 入力完了
                if (title == "") {
                    title = "入力の完了"
                    message = "入力を完了し、データを保存します"
                }
                // アラートを作成
                let alert = UIAlertController(
                    title: title,
                    message: message,
                    preferredStyle: .alert)
                // アラートにボタンをつける
                alert.addAction(UIAlertAction(title: "戻る", style: .default, handler: { action in
                }))
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
                    // gameDBにデータを登録する
                    // 同日に複数回登録用のフラグ作成
                    let formatter = DateFormatter()
                    formatter.dateFormat = "HHmm"
                    // 順位を取得
                    let rankArray = self.getRank(result: self.getResults())
                    let timeFlag = "\(formatter.string(from: Date()))"
                    
                    // gameDBにデータを登録する
                    for i in 0...self.getResults().count-1 {
                        addGameData(date: self.date, gameFlag:timeFlag, gameNumber: 1, playerAName: self.playerAName.text!, playerBName: self.playerBName.text!, playerCName: self.playerCName.text!, yourId: "0", playerAId: "1", playerBId: "2", playerCId: "3", yourRank: rankArray[i][0], playerARank: rankArray[i][1], playerBRank: rankArray[i][2], playerCRank: rankArray[i][3], yourScore: self.getResults()[i][0], playerAScore: self.getResults()[i][1], playerBScore: self.getResults()[i][2], playerCScore: self.getResults()[i][3], isPostServer: false)
                    }
                    
                    // dailyDBにデータを登録する
                    addDailyData(date: self.date, gameFlag: timeFlag, id: "0", amountOfGame: self.getResults().count, first: self.getTotalRankArray(rankArray: rankArray)[0], second: self.getTotalRankArray(rankArray: rankArray)[1], third: self.getTotalRankArray(rankArray: rankArray)[2], fourth: self.getTotalRankArray(rankArray: rankArray)[3], averageRank: Double(self.getTotalRankArray(rankArray: rankArray)[0]+self.getTotalRankArray(rankArray: rankArray)[1]*2+self.getTotalRankArray(rankArray: rankArray)[2]*3+self.getTotalRankArray(rankArray: rankArray)[3]*4)/Double(self.getResults().count), income: self.getTotalScore(scoreArray: self.scoreArray).0 * self.gameRate, payment: self.getTotalScore(scoreArray: self.scoreArray).1 * self.gameRate, bop: self.getTotalScore(scoreArray: self.scoreArray).2 * self.gameRate, score: self.getTotalScore(scoreArray: self.scoreArray).2, rate: self.gameRate, gamePayment: self.gamePayment, playerAId: "aaa", playerBId: "bbb", playerCId: "ccc", playerAName: self.playerANameString, playerBName: self.playerBNameString, playerCName: self.playerCNameString, isPostServer: false)
                    
                    // 戦績画面に遷移
                    if let tabvc = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController  {
                        DispatchQueue.main.async {
                            tabvc.selectedIndex = 2
                            self.initView()
                        }
                    }
                    // 入力内容をリセットする
                    self.initView()
                }))
                // アラート表示
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 画面サイズを取得
        contentsHeight = UIScreen.main.bounds.size.height - tabBarController!.tabBar.bounds.height - CGFloat((self.navigationController?.navigationBar.frame.size.height)!) - UIApplication.shared.statusBarFrame.size.height
        topContentsHeight = contentsHeight / 7
        tableContentsHeight = contentsHeight - topContentsHeight
        rowHeight = CGFloat(tableContentsHeight / 9)
        rowWidth = CGFloat(self.view.bounds.width)
        
        // 画像を置くパネルを作成
        let imagePanel = UIView()
        let imagePanelXPosition = rowWidth-(topContentsHeight-10)/3*4
        imagePanel.frame = CGRect(x:imagePanelXPosition, y:5, width:(topContentsHeight-10)/3*4, height:topContentsHeight-10)
        imagePanel.backgroundColor = .white
        let noImageText = UITextView()
        noImageText.frame = CGRect(x:0, y:(topContentsHeight-10)/3, width:(topContentsHeight-10)/3*4, height:(topContentsHeight-10)/2)
        noImageText.textAlignment = .center
        noImageText.text = "No Image"
        noImageText.textColor = gray
        imagePanel.addSubview(noImageText)
        self.view.addSubview(imagePanel)
        
        // 今日の日付を入力するパネルを作成
        let datePanel = UIView()
        datePanel.frame = CGRect(x:0, y:5, width:(imagePanelXPosition-10)/2, height:topContentsHeight-10)
        datePanel.backgroundColor = .white
        dateField.frame = CGRect(x:0, y:0, width:(imagePanelXPosition-10)/2, height:topContentsHeight-10)
        dateField.textAlignment = .center
        //今日の日付を取得
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月dd日"
        dateField.text = "\(formatter.string(from: Date()))"
        let formatterForDb = DateFormatter()
        formatterForDb.dateFormat = "yyyyMMdd"
        date = "\(formatterForDb.string(from: Date()))"
        
        // ピッカー設定
        datePicker.datePickerMode = UIDatePickerMode.date
        datePicker.timeZone = NSTimeZone.local
        datePicker.locale = Locale(identifier: "ja_JP")
        dateField.inputView = datePicker
        // 決定バーの生成
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 35))
        let spacelItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        let doneItem = UIBarButtonItem(title: "完了", style: UIBarButtonItemStyle.plain, target: self, action: #selector(done))
        toolbar.setItems([spacelItem, doneItem], animated: true)
        // インプットビュー設定
        dateField.inputView = datePicker
        dateField.inputAccessoryView = toolbar
        datePanel.addSubview(dateField)
        self.view.addSubview(datePanel)
        
        // 今日の場代とレートを入力するパネルを作成
        let gamePaymentAndRatePanel = UIView()
        let gamePaymentAndRatePanelWidth = (imagePanelXPosition-10)/2
        gamePaymentAndRatePanel.frame = CGRect(x:(imagePanelXPosition-10)/2+5, y:5, width:gamePaymentAndRatePanelWidth, height:topContentsHeight-10)
        gamePaymentAndRatePanel.backgroundColor = .white
        // 場代
        let textGamePayment = UITextView()
        textGamePayment.frame = CGRect(x:0, y:0, width:gamePaymentAndRatePanelWidth*2/7, height:topContentsHeight/3)
        textGamePayment.text = "場代"
        textGamePayment.textColor = black
        textGamePayment.font = UIFont(name: "Hiragino Sans", size: 12)
        inputGamePayment.frame = CGRect(x:gamePaymentAndRatePanelWidth*2/7, y:10, width:gamePaymentAndRatePanelWidth*4/7, height:topContentsHeight/3)
        inputGamePayment.textAlignment = .center
        inputGamePayment.placeholder = "0"
        inputGamePayment.font = UIFont(name: "Helvetica", size: 21)
        inputGamePayment.textColor = red
        inputGamePayment.keyboardType = .numberPad
        let textGamePaymentYen = UITextView()
        textGamePaymentYen.frame = CGRect(x:gamePaymentAndRatePanelWidth*6/7, y:10, width:gamePaymentAndRatePanelWidth/7, height:topContentsHeight/3)
        textGamePaymentYen.text = "円"
        textGamePaymentYen.textColor = black
        textGamePaymentYen.font = UIFont(name: "Hiragino Sans", size: 12)
        // レート
        let textRate = UITextView()
        textRate.frame = CGRect(x:0, y:topContentsHeight/3, width:gamePaymentAndRatePanelWidth*1/4, height:topContentsHeight/3)
        textRate.text = "レート"
        textRate.textColor = black
        textRate.font = UIFont(name: "Hiragino Sans", size: 8)
        inputRate.frame = CGRect(x:gamePaymentAndRatePanelWidth*1/4, y:topContentsHeight/3+15, width:gamePaymentAndRatePanelWidth*1/2, height:topContentsHeight/3)
        inputRate.textAlignment = .center
        inputRate.placeholder = "0"
        inputRate.font = UIFont(name: "Helvetica", size: 21)
        inputRate.textColor = black
        inputRate.keyboardType = .numberPad
        let textGameRateYen = UITextView()
        textGameRateYen.frame = CGRect(x:gamePaymentAndRatePanelWidth*3/4, y:topContentsHeight/3+15, width:gamePaymentAndRatePanelWidth*1/4, height:topContentsHeight/3)
        textGameRateYen.text = "円/1000点"
        textGameRateYen.textColor = black
        textGameRateYen.font = UIFont(name: "Hiragino Sans", size: 6)
        
        // 仮のサイズでツールバー生成
        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 375, height: 40))
        kbToolBar.barStyle = UIBarStyle.default  // スタイルを設定
        kbToolBar.sizeToFit()  // 画面幅に合わせてサイズを変更
        // スペーサー
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        // 閉じるボタン
        let commitButton =  UIBarButtonItem(title: "完了", style: UIBarButtonItemStyle.plain, target: self, action: #selector(onClickPaymentFinishedButton(_:)))
        kbToolBar.items = [spacer, commitButton]
        inputGamePayment.inputAccessoryView = kbToolBar
        inputRate.inputAccessoryView = kbToolBar
        gamePaymentAndRatePanel.addSubview(textGamePayment)
        gamePaymentAndRatePanel.addSubview(inputGamePayment)
        gamePaymentAndRatePanel.addSubview(textGamePaymentYen)
        gamePaymentAndRatePanel.addSubview(textRate)
        gamePaymentAndRatePanel.addSubview(inputRate)
        gamePaymentAndRatePanel.addSubview(textGameRateYen)
        self.view.addSubview(gamePaymentAndRatePanel)
        
        // プレイヤーを入力する行を生成
        addPlayerRow()
        
        // 得点を入力する表を生成
        gameTable.frame = CGRect(x:0, y:topContentsHeight+rowHeight, width:rowWidth, height:contentsHeight-topContentsHeight-rowHeight*2)
        gameTable.bounces = false
        view.addSubview(gameTable)
        
        for i in 1...initRow {
            addGameRow()
        }

        for row in gameRows {
            gameTable.addSubview(row)
        }

        // 合計点を出力する行を生成
        addScoreRow()
        
    }
    
    // 日付入力ドラムロールの完了ボタン押下
    @objc func done() {
        let pickerDate = datePicker.date
        // 表示用フォーマッター
        let formatterText = DateFormatter()
        formatterText.dateFormat = "yyyy年MM月dd日"
        dateField.text = formatterText.string(from: pickerDate)
        // 日付保存用フォーマッター
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd"
        date = formatter.string(from: pickerDate)
        dateField.endEditing(true)
    }
    
    // 点数入力キーボードの「完了」ボタンクリック時のイベント
    @IBAction internal func onClickInputButton(_ sender: UIBarButtonItem){
        // 入力した数値を数値配列に保存
        for row in 0..<gameRows.count {
            for score in 0..<4 {
                if let item = scoreFieldArray[row][score].text {
                    if (item != "") {
                        scoreArray[row][score] = Int(item)!
                    }
                }
            }
        }
        // 1位の得点を自動入力
        self.completeFirst()
        
        // 再計算
        setTotalScore()
        
        // キーボード展開フラグ
        keyboardClosedFlag = true
        
        // キーボードを閉じる
        self.view.endEditing(true)
    }
    
    // textField展開時の処理
    func textFieldDidBeginEditing(_ textField: UITextField) {
        nowInputNumber = textField.text!
        // 得点入力のtextFieldにだけ反応
        var checkFlag = false
        for array in scoreFieldArray {
            if ((array.index(of: textField)) != nil) {
                checkFlag = true
                break
            }
        }
        if (checkFlag) {
            isSelectedField = textField
            if (textField.text == "") {
                textField.textColor = blue
            }
        }
        // キーボード展開フラグ
        keyboardClosedFlag = false
        
        self.completeFirst()
        
        // 再計算
        self.setTotalScore()
    }
    // textField入力時の処理
    @objc func textFieldDidChange(_ textField: UITextField) {
        nowInputNumber = textField.text!
        // 一度空になったら青に
        if (nowInputNumber == "") {
            isSelectedField.textColor = blue
        } else {
            // "06"とか"006"が入ってきたら、先頭の"0"を削除
            var str = nowInputNumber
            var start = 0
            var sign = ""
            // 負数は1文字目の"-"を無視
            if (str.prefix(1) == "-") {
                str = String(str[str.index(after: str.startIndex)..<str.endIndex])
                sign = "-"
            }
            for i in start..<String(nowInputNumber).count-1 {
                if (String(str.prefix(1)) == "0") {
                    str = String(str[str.index(after: str.startIndex)..<str.endIndex])
                } else {
                    break
                }
            }
            textField.text = sign+str
        }
        
        // 入力した数値を数値配列に保存
        for row in 0..<gameRows.count {
            for score in 0..<4 {
                if let item = scoreFieldArray[row][score].text {
                    if (item != "" && item != "-") {
                        scoreArray[row][score] = Int(item)!
                    } else {
                        scoreArray[row][score] = 0
                    }
                }
            }
        }
        // 再計算
        setTotalScore()
        
    }
    
    // textFieldを閉じたときの処理
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (textField.text == "-") {
            textField.text = ""
            textField.textColor = blue
        }
        isSelectedField = nil
        
        keyboardClosedFlag = true
    }
    
    // 場代入力キーボードの「完了」ボタンクリック時のイベント
    @IBAction internal func onClickPaymentFinishedButton(_ sender: UIBarButtonItem){
        // キーボードを閉じる
        self.view.endEditing(true)
    }

    // キーボードの「-」ボタンクリック時のイベント
    @IBAction internal func onClickMinusButton(_ sender: UIBarButtonItem) {
        // 入力中の値が0のときは無視
        if (nowInputNumber != "0") {
            if (nowInputNumber != "") {
                isSelectedField.text = String((Int(isSelectedField!.text!)!*(-1)))
                // 色を反転
                if (isSelectedField.textColor == blue) {
                    isSelectedField.textColor = red
                } else {
                    isSelectedField.textColor = blue
                }
            } else {
                isSelectedField.textColor = red
                isSelectedField.text = "-"
            }
        }
        
        // 値を保存
        for row in 0..<gameRows.count {
            for score in 0..<4 {
                if let item = scoreFieldArray[row][score].text {
                    if (item != "" && item != "-") {
                        scoreArray[row][score] = Int(item)!
                    } else {
                        scoreArray[row][score] = 0
                    }
                }
            }
        }
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        textField.resignFirstResponder()
        setTotalScore()
        return true
    }
    
    // 名前を入力する行を追加する
    func addPlayerRow() {

        // 行を作成
        playerRow = UIStackView()
        playerRow.frame = CGRect(x:0, y:topContentsHeight, width:rowWidth, height:rowHeight)
        playerRow.axis = .horizontal
        
        // 空のセルを追加
        let empty = UITextView()
        
        // 枠の設定
        empty.layer.borderWidth = 1
        empty.layer.borderColor = lightGray.cgColor
        yourName.layer.borderWidth = 1
        yourName.layer.borderColor = lightGray.cgColor
        playerAName.layer.borderWidth = 1
        playerAName.layer.borderColor = lightGray.cgColor
        playerBName.layer.borderWidth = 1
        playerBName.layer.borderColor = lightGray.cgColor
        playerCName.layer.borderWidth = 1
        playerCName.layer.borderColor = lightGray.cgColor
        
        // 各項目のフォントとかの設定
        yourName.font = UIFont(name: "Hiragino Sans", size: 13)
        playerAName.font = UIFont(name: "Hiragino Sans", size: 13)
        playerBName.font = UIFont(name: "Hiragino Sans", size: 13)
        playerCName.font = UIFont(name: "Hiragino Sans", size: 13)
        yourName.textColor = black
        playerAName.textColor = black
        playerBName.textColor = black
        playerCName.textColor = black
        empty.isEditable = false
        yourName.textAlignment = .center
        yourName.isEnabled = false
        playerAName.textAlignment = .center
        playerBName.textAlignment = .center
        playerCName.textAlignment = .center
        
        // 値のセット
        yourName.text = "あなた"
        playerAName.placeholder = "playerA"
        playerBName.placeholder = "playerB"
        playerCName.placeholder = "playerC"
        empty.backgroundColor = superLightGray
        yourName.backgroundColor = UIColor.white
        playerAName.backgroundColor = superLightGray
        playerBName.backgroundColor = UIColor.white
        playerCName.backgroundColor = superLightGray
        
        // returnでキーボードが閉じるようにdelegeteを設定
        playerAName.delegate = self
        playerBName.delegate = self
        playerCName.delegate = self
        
        // 行に要素を追加
        playerRow.addArrangedSubview(empty)
        playerRow.addArrangedSubview(yourName)
        playerRow.addArrangedSubview(playerAName)
        playerRow.addArrangedSubview(playerBName)
        playerRow.addArrangedSubview(playerCName)
        // 等間隔に設定
        playerRow.distribution = .fillEqually
        
        // viewに追加
        view.addSubview(playerRow)
    }
    
    // 合計得点の行を表示する
    func addScoreRow() {
        // 行を作成
        scoreRow = UIStackView()
        //scoreRow.frame = CGRect(x:0, y:topContentsHeight+rowHeight*7, width:rowWidth, height:rowHeight)
        scoreRow.frame = CGRect(x:0, y:contentsHeight-rowHeight, width:rowWidth, height:rowHeight)
        scoreRow.axis = .horizontal
        
        // 背景色の設定
        number.frame = CGRect(x:0, y:rowHeight*9, width:rowWidth/5, height:rowHeight)
        yourTotalScoreField.frame = CGRect(x:rowWidth, y:rowHeight*9, width:rowWidth/5, height:rowHeight)
        playerATotalScoreField.frame = CGRect(x:rowWidth*2, y:rowHeight*9, width:rowWidth/5, height:rowHeight)
        playerBTotalScoreField.frame = CGRect(x:rowWidth*3, y:rowHeight*9, width:rowWidth/5, height:rowHeight)
        playerCTotalScoreField.frame = CGRect(x:rowWidth*4, y:rowHeight*9, width:rowWidth/5, height:rowHeight)
        number.backgroundColor = superLightGray
        yourTotalScoreField.backgroundColor = UIColor.white
        playerATotalScoreField.backgroundColor = superLightGray
        playerBTotalScoreField.backgroundColor = UIColor.white
        playerCTotalScoreField.backgroundColor = superLightGray
        
        let topBorderEmpty = CALayer()
        let topBorderYou = CALayer()
        let topBorderPlayerA = CALayer()
        let topBorderPlayerB = CALayer()
        let topBorderPlayerC = CALayer()
        topBorderEmpty.frame = CGRect(x: 0, y: 1, width: number.frame.width, height: 3.0)
        topBorderYou.frame = CGRect(x: 0, y: 1, width: number.frame.width, height: 3.0)
        topBorderPlayerA.frame = CGRect(x: 0, y: 1, width: number.frame.width, height: 3.0)
        topBorderPlayerB.frame = CGRect(x: 0, y: 1, width: number.frame.width, height: 3.0)
        topBorderPlayerC.frame = CGRect(x: 0, y: 1, width: number.frame.width, height: 3.0)
        
        topBorderEmpty.backgroundColor = green.cgColor
        topBorderYou.backgroundColor = green.cgColor
        topBorderPlayerA.backgroundColor = green.cgColor
        topBorderPlayerB.backgroundColor = green.cgColor
        topBorderPlayerC.backgroundColor = green.cgColor
        
        //作成したViewに上線を追加
        number.layer.addSublayer(topBorderEmpty)
        yourTotalScoreField.layer.addSublayer(topBorderYou)
        playerATotalScoreField.layer.addSublayer(topBorderPlayerA)
        playerBTotalScoreField.layer.addSublayer(topBorderPlayerB)
        playerCTotalScoreField.layer.addSublayer(topBorderPlayerC)
        
        // 枠の設定
        number.layer.borderWidth = 1
        number.layer.borderColor = lightGray.cgColor
        yourTotalScoreField.layer.borderWidth = 1
        yourTotalScoreField.layer.borderColor = lightGray.cgColor
        playerATotalScoreField.layer.borderWidth = 1
        playerATotalScoreField.layer.borderColor = lightGray.cgColor
        playerBTotalScoreField.layer.borderWidth = 1
        playerBTotalScoreField.layer.borderColor = lightGray.cgColor
        playerCTotalScoreField.layer.borderWidth = 1
        playerCTotalScoreField.layer.borderColor = lightGray.cgColor
        
        // 各項目のフォントとかの設定
        number.textColor = black
        // 初期値
        number.text = "計"
        yourTotalScoreField.text = "0"
        playerATotalScoreField.text = "0"
        playerBTotalScoreField.text = "0"
        playerCTotalScoreField.text = "0"
        yourTotalScoreField.textColor = blue
        playerATotalScoreField.textColor = blue
        playerBTotalScoreField.textColor = blue
        playerCTotalScoreField.textColor = blue
        number.font = UIFont(name: "Hiragino Sans", size: 18)
        yourTotalScoreField.font = UIFont(name: "Helvetica", size: 24)
        playerATotalScoreField.font = UIFont(name: "Helvetica", size: 24)
        playerBTotalScoreField.font = UIFont(name: "Helvetica", size: 24)
        playerCTotalScoreField.font = UIFont(name: "Helvetica", size: 24)
        number.textAlignment = .center
        yourTotalScoreField.textAlignment = .center
        playerATotalScoreField.textAlignment = .center
        playerBTotalScoreField.textAlignment = .center
        playerCTotalScoreField.textAlignment = .center
        number.isEnabled = false
        yourTotalScoreField.isEnabled = false
        playerATotalScoreField.isEnabled = false
        playerBTotalScoreField.isEnabled = false
        playerCTotalScoreField.isEnabled = false
        
        // 行に要素を追加
        scoreRow.addArrangedSubview(number)
        scoreRow.addArrangedSubview(yourTotalScoreField)
        scoreRow.addArrangedSubview(playerATotalScoreField)
        scoreRow.addArrangedSubview(playerBTotalScoreField)
        scoreRow.addArrangedSubview(playerCTotalScoreField)
        // 等間隔に設定
        scoreRow.distribution = .fillEqually
 
        // viewに追加
        view.addSubview(scoreRow)
    }

    // 対局データの行を追加する
    func addGameRow() {
        
        // 数字のみを入力するキーボードをカスタマイズ
        // 仮のサイズでツールバー生成
        let kbToolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: 375, height: 40))
        kbToolBar.barStyle = UIBarStyle.default  // スタイルを設定
        kbToolBar.sizeToFit()  // 画面幅に合わせてサイズを変更
        // スペーサー
        let spacer = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: self, action: nil)
        // 閉じるボタン
        let commitButton =  UIBarButtonItem(title: "完了", style: UIBarButtonItemStyle.plain, target: self, action: #selector(onClickInputButton(_:)))
        // マイナスボタン
        let minusButton =  UIBarButtonItem(title: "ー", style: UIBarButtonItemStyle.plain, target: self, action: #selector(onClickMinusButton(_:)))
        kbToolBar.items = [minusButton, spacer, commitButton]
        
        // 行を作成
        let gameRow = UIStackView()
        let rowWidth = CGFloat(self.view.bounds.width)
        gameRow.frame = CGRect(x:0, y:CGFloat(rowYPosition), width:rowWidth, height:rowHeight)
        gameRow.axis = .horizontal
        
        // 入力用のセルを追加
        let number = UITextField()
        let score1 = UITextField()
        let score2 = UITextField()
        let score3 = UITextField()
        let score4 = UITextField()
        // delegate
        score1.delegate = self
        score2.delegate = self
        score3.delegate = self
        score4.delegate = self
        // 編集中のイベント取得用
        score1.addTarget(self, action: "textFieldDidChange:",for: UIControlEvents.editingChanged)
        score2.addTarget(self, action: "textFieldDidChange:",for: UIControlEvents.editingChanged)
        score3.addTarget(self, action: "textFieldDidChange:",for: UIControlEvents.editingChanged)
        score4.addTarget(self, action: "textFieldDidChange:",for: UIControlEvents.editingChanged)
        
        // 配列に追加
        scoreFieldArray.append([UITextField]())
        scoreFieldArray[nowRow].append(score1)
        scoreFieldArray[nowRow].append(score2)
        scoreFieldArray[nowRow].append(score3)
        scoreFieldArray[nowRow].append(score4)
        
        // 枠の設定
        number.layer.borderWidth = 1
        number.layer.borderColor = lightGray.cgColor
        score1.layer.borderWidth = 1
        score1.layer.borderColor = lightGray.cgColor
        score2.layer.borderWidth = 1
        score2.layer.borderColor = lightGray.cgColor
        score3.layer.borderWidth = 1
        score3.layer.borderColor = lightGray.cgColor
        score4.layer.borderWidth = 1
        score4.layer.borderColor = lightGray.cgColor
        
        // 各項目のフォントとかの設定
        number.isEnabled = false
        number.font = UIFont(name: "Helvetica", size: 18)
        score1.font = UIFont(name: "Helvetica", size: 24)
        score2.font = UIFont(name: "Helvetica", size: 24)
        score3.font = UIFont(name: "Helvetica", size: 24)
        score4.font = UIFont(name: "Helvetica", size: 24)
        number.textColor = black
        score1.textColor = blue
        score2.textColor = blue
        score3.textColor = blue
        score4.textColor = blue
        number.textAlignment = .center
        score1.textAlignment = .center
        score2.textAlignment = .center
        score3.textAlignment = .center
        score4.textAlignment = .center
        score1.keyboardType = UIKeyboardType.numberPad
        score2.keyboardType = UIKeyboardType.numberPad
        score3.keyboardType = UIKeyboardType.numberPad
        score4.keyboardType = UIKeyboardType.numberPad
        score1.inputAccessoryView = kbToolBar
        score2.inputAccessoryView = kbToolBar
        score3.inputAccessoryView = kbToolBar
        score4.inputAccessoryView = kbToolBar
        
        // 背景と値のセット
        number.text = String(nowRow+1)
        number.backgroundColor = superLightGray
        score1.backgroundColor = UIColor.white
        score2.backgroundColor = superLightGray
        score3.backgroundColor = UIColor.white
        score4.backgroundColor = superLightGray
        
        // 初期として0をセット
        scoreArray.append([Int]())
        scoreArray[nowRow].append(0)
        scoreArray[nowRow].append(0)
        scoreArray[nowRow].append(0)
        scoreArray[nowRow].append(0)
        
        // 行に要素を追加
        gameRow.addArrangedSubview(number)
        gameRow.addArrangedSubview(score1)
        gameRow.addArrangedSubview(score2)
        gameRow.addArrangedSubview(score3)
        gameRow.addArrangedSubview(score4)
        // 等間隔に設定
        gameRow.distribution = .fillEqually
        
        // 追加
        gameRows.append(gameRow)
        rowYPosition += rowHeight
        nowRow += 1
        gameTable.contentSize = CGSize(width:375, height:rowHeight*CGFloat(nowRow))

    }
    func calcScore () -> (Int, Int, Int, Int){
        var scoreA:Int = 0
        var scoreB:Int = 0
        var scoreC:Int = 0
        var scoreD:Int = 0
        
        for score in scoreArray {
            scoreA += score[0]
            scoreB += score[1]
            scoreC += score[2]
            scoreD += score[3]
        }

        return (scoreA, scoreB, scoreC, scoreD)
    }
    
    // 合計点を計算してセットする
    func setTotalScore() {
        // 値のセット
        yourTotalScore = calcScore().0
        playerATotalScore = calcScore().1
        playerBTotalScore = calcScore().2
        playerCTotalScore = calcScore().3
        yourTotalScoreField.text = String(yourTotalScore)
        playerATotalScoreField.text = String(playerATotalScore)
        playerBTotalScoreField.text = String(playerBTotalScore)
        playerCTotalScoreField.text = String(playerCTotalScore)
        if (yourTotalScore >= 0) {
            yourTotalScoreField.textColor = blue
        } else {
            yourTotalScoreField.textColor = red
        }
        if (playerATotalScore >= 0) {
            playerATotalScoreField.textColor = blue
        } else {
            playerATotalScoreField.textColor = red
        }
        if (playerBTotalScore >= 0) {
            playerBTotalScoreField.textColor = blue
        } else {
            playerBTotalScoreField.textColor = red
        }
        if (playerCTotalScore >= 0) {
            playerCTotalScoreField.textColor = blue
        } else {
            playerCTotalScoreField.textColor = red
        }

    }
    
    // 対局ゲームの結果を返す
    func getResults() -> [[Int]] {
        var results: [[Int]] = []
        var count = 0
        for array in scoreArray {
            var gameFlag = false
            for i in 0...3 {
                if (array[i] != 0) {
                    gameFlag = true
                    break
                }
            }
            if (gameFlag) {
                count += 1
            }
        }
        // 何も入力してないときは実行しない
        if (count != 0) {
            for i in 0...count-1 {
                results.append([Int]())
                results[i] = scoreArray[i]
            }
        }

        return results
    }
    
    // キャンセル時や完了時にビューにセットした値を初期化する
    func initView () {
        for i in 0...nowRow-1 {
            scoreArray[i][0] = 0
            scoreArray[i][1] = 0
            scoreArray[i][2] = 0
            scoreArray[i][3] = 0
            
            scoreFieldArray[i][0].text=""
            scoreFieldArray[i][1].text=""
            scoreFieldArray[i][2].text=""
            scoreFieldArray[i][3].text=""
        }
        // 合計行
        yourTotalScoreField.text = "0"
        playerATotalScoreField.text = "0"
        playerBTotalScoreField.text = "0"
        playerCTotalScoreField.text = "0"
        yourTotalScoreField.textColor = blue
        playerATotalScoreField.textColor = blue
        playerBTotalScoreField.textColor = blue
        playerCTotalScoreField.textColor = blue
        
        // 名前
        playerAName.text = ""
        playerBName.text = ""
        playerCName.text = ""
        playerANameString = ""
        playerBNameString = ""
        playerCNameString = ""
        
        // 場代
        inputGamePayment.text = ""
        gamePayment = 0
        // レート
        inputRate.text = ""
        gameRate = 0

    }
    
    // 得点配列から、順位を取得する
    // [10,20,30,10] が入ってくると [4,2,1,4]
    // [10,20,30,20] が入ってくると [4,2,1,2]
    // [10,10,10,20] が入ってくると [4,4,4,1]
    func getRank(result: [[Int]]) -> [[Int]] {
        var rankArrays:[[Int]] = []
        for results in result {
            var rankArray:[Int] = []
            //var results = result
            //var sortedResult:[Int] = results.sorted { $1 < $0 }
            let sortedResult:[Int] = results.sorted { $1 < $0 }
            
            for item in results {
                rankArray.append(sortedResult.index(of: item)!+1)
            }
            // あんまり同点は考えなくていい??
            // 4位が複数いた場合は3位になってるから、4位がいない場合は3位を全員4位にする
            if (rankArray.index(of: 4) == nil) {
                for i in 0...rankArray.count-1 {
                    if (rankArray[i] == 3) {
                        rankArray[i] = 4
                    }
                }
            }
            // 1位と2位しかいない場合は、2位を全員4位にする
            if (rankArray.index(of: 4) == nil && rankArray.index(of: 3) == nil) {
                for i in 0...rankArray.count-1 {
                    if (rankArray[i] == 2) {
                        rankArray[i] = 4
                    }
                }
            }
            rankArrays.append(rankArray)
        }
        return rankArrays
    }
    
    // 得点配列から、順位配列を返す
    // とりあえず自分のscoreだけ返す
    func getTotalRankArray(rankArray: [[Int]]) -> [Int] {
        var first:Int = 0
        var second:Int = 0
        var third:Int = 0
        var fourth:Int = 0
        
        // とりあえず自分のscoreだけ
        for rank in rankArray {
            switch rank[0] {
            case 1:
                first += 1
            case 2:
                second += 1
            case 3:
                third += 1
            case 4:
                fourth += 1
            default:
                break
            }
        }
        return [first,second,third,fourth]
    }
    
    // 得点配列から、総プラス得点、総マイナス得点、総得点を返す
    // 一旦、自分のだけ
    func getTotalScore(scoreArray: [[Int]]) -> (Int,Int,Int){
        var plus = 0
        var minus = 0
        var total = 0
        // とりあえず自分のscoreだけ
        for score in scoreArray {
            if (score[0] >= 0) {
                plus += score[0]
            } else {
                minus += score[0]
            }
            total += score[0]
        }
        return (plus,minus,total)
    }
    
    // バリデーションチェック(入力0件)
    func validationCheckEmptyInput() -> Bool{
        if (getResults().count == 0) {
            return true
        }
        return false
    }
    // バリデーションチェック(空のセルがある)
    func validationCheckEmptyCells() -> Int {
        print(getResults().count)
        if (getResults().count == 0) {
            return 0
        }
        for i in 0...getResults().count-1 {
            for j in 0...3 {
                if (scoreFieldArray[i][j].text == "") {
                    return i + 1
                }
            }
        }
        return 0
    }
    // バリデーションチェック(場代が入力されていない)
    func validationCheckEmptyGamePayment() -> Bool {
        if (inputGamePayment.text == "") {
            return true;
        }
        return false
    }
    // バリデーションチェック(レートが入力されていない)
    func validationCheckEmptyRate() -> Bool{
        if (inputRate.text == "") {
            return true;
        }
        return false
    }
    // バリデーションチェック(プレイヤー名が入力されていない)
    func validationCheckEmptyPlayerName() -> Bool {
        if (playerANameString == "NoName") {
            return true
        }
        if (playerBNameString == "NoName") {
            return true
        }
        if (playerCNameString == "NoName") {
            return true
        }
        print(playerANameString)
        print(playerBNameString)
        print(playerCNameString)
        return false
    }
    
    // 1位の得点を自動で入力する
    func completeFirst() {
        // ゲーム数が0件だったら無視
        if (getResults().count != 0) {
            
            for i in 0...getResults().count-1 {
                var firstPlayer:Int = 0
                var firstPlayerScore = -1000000
                var checkFlag:Int = 0
                var nilNumber:Int = 0
                var totalScore:Int = 0

                for j in 0...3 {
                    if (scoreFieldArray[i][j].text == "") {
                        checkFlag += 1
                        nilNumber = j
                    }
                    // 最高順位者を取っておく
                    if (firstPlayerScore < scoreArray[i][j]) {
                        firstPlayer = j
                        firstPlayerScore = scoreArray[i][j]
                    }
                    totalScore += scoreArray[i][j]
                }
                if (checkFlag == 1) {
                    print(totalScore)
                    scoreFieldArray[i][nilNumber].text = String(-totalScore)
                    scoreArray[i][nilNumber] = -totalScore
                    if (-totalScore >= 0) {
                        scoreFieldArray[i][nilNumber].textColor = blue
                    } else {
                        scoreFieldArray[i][nilNumber].textColor = red
                    }
                }
                if (checkFlag == 0) {
                    scoreArray[i][firstPlayer] = scoreArray[i][firstPlayer] - totalScore
                    scoreFieldArray[i][firstPlayer].text = String(scoreArray[i][firstPlayer])
                    if (scoreArray[i][firstPlayer] >= 0) {
                        scoreFieldArray[i][firstPlayer].textColor = blue
                    } else {
                        scoreFieldArray[i][firstPlayer].textColor = red
                    }
                }
            }
        }
    }
/*
    @IBAction func cameratapped(_ sender: CustomButton) {
        //アラート表示のためにインスタンス化
        let actionSheet = UIAlertController(title: "", message: "グループ画像を設定してください！", preferredStyle: UIAlertControllerStyle.actionSheet)
        let tappedcamera = UIAlertAction(title: "カメラで撮影する", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            self.tappedcamera()
        })
        
        let tappedlibrary = UIAlertAction(title: "ライブラリから選択する", style: UIAlertActionStyle.default, handler: {
            (action: UIAlertAction!) in
            self.tappedlibrary()
        })
        
        let cancel = UIAlertAction(title: "キャンセル", style: UIAlertActionStyle.cancel, handler: {
            (action: UIAlertAction!) in
            print("キャンセル")
        })
        //作成したalertactionを追加
        actionSheet.addAction(tappedcamera)
        actionSheet.addAction(tappedlibrary)
        actionSheet.addAction(cancel)
        
        //画面に表示。これを書かないと表示されない。
        present(actionSheet, animated: true, completion: nil)
        
    }
    
    //　撮影が完了時した時に呼ばれる
    func imagePickerController(_ imagePicker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let pickedImage = info[UIImagePickerControllerOriginalImage]
            as? UIImage {
            
        //buttonの背景画像を変えるのは、「setBackgroundImag」。
            cameratap.contentMode = .scaleAspectFit
            cameratap.setBackgroundImage(pickedImage, for: UIControlState())
            cameratap.setTitle("", for: .normal)
            
        }
        
        //閉じる処理
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    // 撮影がキャンセルされた時に呼ばれる
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func tappedcamera() {
        let sourceType:UIImagePickerControllerSourceType =
            UIImagePickerControllerSourceType.camera
        // カメラが利用可能かチェック
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.camera){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
        }
        else{
            print("error")
        }
    }
    
    func tappedlibrary() {
        let sourceType:UIImagePickerControllerSourceType =
            UIImagePickerControllerSourceType.photoLibrary
        
        if UIImagePickerController.isSourceTypeAvailable(
            UIImagePickerControllerSourceType.photoLibrary){
            // インスタンスの作成
            let cameraPicker = UIImagePickerController()
            cameraPicker.sourceType = sourceType
            cameraPicker.delegate = self
            self.present(cameraPicker, animated: true, completion: nil)
            
        }
        else{
            print("error")
            
        }
    }
    */
}
