//
//  library.swift
//  MahjongNote
//
//  Created by 藤井勇樹 on 2018/08/12.
//  Copyright © 2018 mahcial. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

// 対局のデータをDBに保存する
func addGameData(date: String, gameFlag: String, gameNumber: Int, playerAName: String, playerBName: String, playerCName: String, yourId: String, playerAId: String, playerBId: String, playerCId: String, yourRank: Int, playerARank: Int, playerBRank: Int, playerCRank: Int, yourScore: Int, playerAScore: Int, playerBScore: Int, playerCScore: Int, isPostServer: Bool) {
    let realm = try! Realm()
    let game = GameData()
    game.date = date
    game.gameFlag = gameFlag
    game.gameNumber = gameNumber
    game.playerAName = playerAName
    game.playerBName = playerBName
    game.playerCName = playerCName
    game.yourId = yourId
    game.playerAId = playerAId
    game.playerBId = playerBId
    game.playerCId = playerCId
    game.yourRank = yourRank
    game.playerARank = playerARank
    game.playerBRank = playerBRank
    game.playerCRank = playerCRank
    game.yourScore = yourRank
    game.playerAScore = playerAScore
    game.playerBScore = playerBScore
    game.playerCScore = playerCScore
    game.isPostServer = isPostServer
    
    try! realm.write() {
        realm.add(game)
    }
}

// 日毎のデータをDBに保存する
func addDailyData(date: String, gameFlag: String, id: String, amountOfGame: Int, first: Int, second: Int, third: Int, fourth: Int, averageRank: Double, income: Int, payment: Int, bop: Int, score: Int, rate: Int, gamePayment: Int, playerAId: String, playerBId: String, playerCId: String, playerAName: String, playerBName: String, playerCName: String, isPostServer: Bool) {
    let realm = try! Realm()
    let dailyData = DailyData()

    dailyData.date = date
    dailyData.gameFlag = gameFlag
    dailyData.id = id
    dailyData.amountOfGame = amountOfGame
    dailyData.first = first
    dailyData.second = second
    dailyData.third = third
    dailyData.fourth = fourth
    dailyData.averageRank = averageRank
    dailyData.income = income
    dailyData.payment = payment
    dailyData.bop = bop
    dailyData.score = score
    dailyData.rate = rate
    dailyData.gamePayment = gamePayment
    dailyData.playerAId = playerAId
    dailyData.playerBId = playerBId
    dailyData.playerCId = playerCId
    dailyData.playerAName = playerAName
    dailyData.playerBName = playerBName
    dailyData.playerCName = playerCName
    dailyData.isPostServer = isPostServer
    
    try! realm.write() {
        realm.add(dailyData)
    }
}

// 対局DBから指定された数字を日時に含むデータを取得する
func getGameData(date: String) -> Results<GameData> {
    let realm = try! Realm()
    let result = realm.objects(GameData.self).filter("date contains '" + date + "'").sorted(byKeyPath: "date", ascending: false)
    return result
}

// 日毎DBから指定された数字を日時に含むデータを取得する
func getDailyData(date: String) -> Results<DailyData> {
    let realm = try! Realm()
    let result = realm.objects(DailyData.self).filter("date contains '" + date + "'").sorted(byKeyPath: "date", ascending: false)
    return result
}

// 総合データを返却する
func getTotally(data: Results<DailyData>) -> [(month: String, income: Int, payment: Int, bop: Int, gamePayment: Int, bopWithGamePayment: Int, first: Int, second: Int, third: Int, fourth: Int, averageRank: Double, averageScore: Double)]{
    
    var arr:[(month: String, income: Int, payment: Int, bop: Int, gamePayment: Int, bopWithGamePayment: Int, first: Int, second: Int, third: Int, fourth: Int, averageRank: Double, averageScore: Double)] = []

    let month = "総合"
    var totalIncome = 0
    var totalPayment = 0
    var totalBop = 0
    var gamePayment = 0
    var bopWithGamePayment = 0
    var totalRank = 0
    var totalScore = 0
    var numOfFirst = 0
    var numOfSecond = 0
    var numOfThird = 0
    var numOfFourth = 0
    var numOfGame = 0
    
    for datum in data {
        
        totalRank += datum.first * 1
        totalRank += datum.second * 2
        totalRank += datum.third * 3
        totalRank += datum.fourth * 4
        
        totalIncome += datum.income
        totalPayment += datum.payment
        totalBop += datum.bop
        gamePayment += datum.gamePayment
        bopWithGamePayment += datum.bop
        bopWithGamePayment += datum.gamePayment
        
        numOfGame += datum.amountOfGame
        totalScore += datum.score
        
        numOfFirst += datum.first
        numOfSecond += datum.second
        numOfThird += datum.third
        numOfFourth += datum.fourth
        
    }
    // 配列に追加
    arr.append((month:month, income:totalIncome, payment: totalPayment, bop:totalBop,
                gamePayment:gamePayment, bopWithGamePayment:bopWithGamePayment,
                first:numOfFirst, second:numOfSecond, third:numOfThird, fourth:numOfFourth,
                averageRank: Double(totalRank)/Double(numOfGame), averageScore: Double(totalScore)/Double(numOfGame)))
    
    return arr
    
}

// 日毎のデータを受け取って、月ごとのデータを返却する
// 月ごとの収入、支出、収支、場代、場代込み収支、1位回数、2位回数、3位回数、4位回数、平均順位、平均得点を返す
func getMonthly(data: Results<DailyData>) -> [(month: String, income: Int, payment: Int, bop: Int, gamePayment: Int, bopWithGamePayment: Int, first: Int, second: Int, third: Int, fourth: Int, averageRank: Double, averageScore: Double)] {
    
    var arr:[(month: String, income: Int, payment: Int, bop: Int, gamePayment: Int, bopWithGamePayment: Int, first: Int, second: Int, third: Int, fourth: Int, averageRank: Double, averageScore: Double)] = []
    var nowMonth = ""
    var count = 0
    var nowTotalIncome = 0
    var nowTotalPayment = 0
    var nowTotalBop = 0
    var nowGamePayment = 0
    var nowBopWithGamePayment = 0
    var nowTotalRank = 0
    var nowTotalScore = 0
    var nowNumOfFirst = 0
    var nowNumOfSecond = 0
    var nowNumOfThird = 0
    var nowNumOfFourth = 0
    var nowNumOfGame = 0
    
    for datum in data {
        if (count == 0) {
            nowMonth = String(datum.date[datum.date.index(datum.date.startIndex, offsetBy: 0)..<datum.date.index(datum.date.startIndex, offsetBy: 6)])
        }
        if (String(datum.date[datum.date.index(datum.date.startIndex, offsetBy: 0)..<datum.date.index(datum.date.startIndex, offsetBy: 6)]) != nowMonth && count != 0) {
            // まとめる
            arr.append((month:nowMonth, income:nowTotalIncome, payment: nowTotalPayment, bop:nowTotalBop,
                        gamePayment:nowGamePayment, bopWithGamePayment:nowBopWithGamePayment,
                        first:nowNumOfFirst, second:nowNumOfSecond, third:nowNumOfThird, fourth:nowNumOfFourth,
                        averageRank: Double(nowTotalRank)/Double(nowNumOfGame), averageScore: Double(nowTotalScore)/Double(nowNumOfGame)))
            
            // 次の日付に更新
            nowMonth = String(datum.date[datum.date.index(datum.date.startIndex, offsetBy: 0)..<datum.date.index(datum.date.startIndex, offsetBy: 6)])
            // クリア
            nowTotalIncome = 0
            nowTotalPayment = 0
            nowTotalBop = 0
            nowGamePayment = 0
            nowBopWithGamePayment = 0
            nowTotalRank = 0
            nowTotalScore = 0
            nowNumOfFirst = 0
            nowNumOfSecond = 0
            nowNumOfThird = 0
            nowNumOfFourth = 0
            nowNumOfGame = 0
        }
        
        nowTotalRank += datum.first * 1
        nowTotalRank += datum.second * 2
        nowTotalRank += datum.third * 3
        nowTotalRank += datum.fourth * 4
        
        nowTotalIncome += datum.income
        nowTotalPayment += datum.payment
        nowTotalBop += datum.bop
        nowGamePayment += datum.gamePayment
        nowBopWithGamePayment += datum.bop
        nowBopWithGamePayment += datum.gamePayment
        
        nowNumOfGame += datum.amountOfGame
        nowTotalScore += datum.score
        
        nowNumOfFirst += datum.first
        nowNumOfSecond += datum.second
        nowNumOfThird += datum.third
        nowNumOfFourth += datum.fourth
        
        count += 1
        
    }
    // 最後を追加
    arr.append((month:nowMonth, income:nowTotalIncome, payment: nowTotalPayment, bop:nowTotalBop,
                gamePayment:nowGamePayment, bopWithGamePayment:nowBopWithGamePayment,
                first:nowNumOfFirst, second:nowNumOfSecond, third:nowNumOfThird, fourth:nowNumOfFourth,
                averageRank: Double(nowTotalRank)/Double(nowNumOfGame), averageScore: Double(nowTotalScore)/Double(nowNumOfGame)))
    
    return arr
}

// 1000単位で「,」カンマを入れる
func formatComma(num: Int) -> String{
    let formatter = NumberFormatter()
    formatter.numberStyle = NumberFormatter.Style.decimal
    formatter.groupingSeparator = ","
    formatter.groupingSize = 3
    return formatter.string(from: num as NSNumber)!
}

// 日付の書式を変更
// 20180831 → 2018年8月31日
func formatDate(dateString: String) -> String {
    var year = ""
    var month = ""
    var day = ""
    
    year = String(dateString[dateString.index(dateString.startIndex, offsetBy: 0)..<dateString.index(dateString.startIndex, offsetBy: 4)])
    if (dateString[dateString.index(dateString.startIndex, offsetBy: 4)..<dateString.index(dateString.startIndex, offsetBy: 5)] == "0") {
        month = String(dateString[dateString.index(dateString.startIndex, offsetBy: 5)..<dateString.index(dateString.startIndex, offsetBy: 6)])
    } else {
        month = String(dateString[dateString.index(dateString.startIndex, offsetBy: 4)..<dateString.index(dateString.startIndex, offsetBy: 6)])
    }
    if (dateString[dateString.index(dateString.startIndex, offsetBy: 6)..<dateString.index(dateString.startIndex, offsetBy: 7)] == "0") {
        day = String(dateString[dateString.index(dateString.startIndex, offsetBy: 7)..<dateString.index(dateString.startIndex, offsetBy: 8)])
    } else {
        day = String(dateString[dateString.index(dateString.startIndex, offsetBy: 6)..<dateString.index(dateString.startIndex, offsetBy: 8)])
    }
    
    return year + "年" + month + "月" + day + "日"
}

// 日付だけを整形して返却 (チャート用)
// 20180801 → 1日
func getDay(date: String) -> String {
    var day: String = ""
    if (String(date[date.index(date.startIndex, offsetBy: 6)..<date.index(date.startIndex, offsetBy: 7)]) == "0") {
        day = String(date[date.index(date.startIndex, offsetBy: 7)..<date.index(date.startIndex, offsetBy: 8)]) + "日"
    } else {
        day = String(date[date.index(date.startIndex, offsetBy: 6)..<date.index(date.startIndex, offsetBy: 8)]) + "日"
    }
    return day
}

// 年月だけを整形して返却 (ナビゲーションバータイトル用)
func formatYearAndMonth(date: String) -> String {
    let year: String
        = String(date[date.index(date.startIndex, offsetBy: 0)..<date.index(date.startIndex, offsetBy: 4)])
    var month: String = ""
    
    if (String(date[date.index(date.startIndex, offsetBy: 4)..<date.index(date.startIndex, offsetBy: 5)]) == "0") {
        month = String(date[date.index(date.startIndex, offsetBy: 5)..<date.index(date.startIndex, offsetBy: 6)])
    } else {
        month = String(date[date.index(date.startIndex, offsetBy: 4)..<date.index(date.startIndex, offsetBy: 6)])
    }
    return year + "年" + month + "月"
}

// 年と月を返却 (カレンダー設定用)
// 201808: String → (2018,8): (Int,Int)
func formatCalendar(date: String) -> (Int, Int) {
    
    let year: Int = Int(String(date[date.index(date.startIndex, offsetBy: 0)..<date.index(date.startIndex, offsetBy: 4)]))!
    var month: Int = 0

    if (date[date.index(date.startIndex, offsetBy: 4)..<date.index(date.startIndex, offsetBy: 5)] == "0") {
        month = Int(String(date[date.index(date.startIndex, offsetBy: 5)..<date.index(date.startIndex, offsetBy: 6)]))!
    } else {
        month = Int(String(date[date.index(date.startIndex, offsetBy: 4)..<date.index(date.startIndex, offsetBy: 6)]))!
    }
    return (year, month)
}

// 正の数字にプラス記号(+)を追加して返す
func addPlusSymbol(number: String) -> String {
    // 先頭文字列を確認して、「-」マイナス記号じゃなかったら「+」プラス記号をつける
    if (number[number.index(number.startIndex, offsetBy: 0)..<number.index(number.startIndex, offsetBy: 1)] != "-") {
        return "+" + number
    }
    return number
}
