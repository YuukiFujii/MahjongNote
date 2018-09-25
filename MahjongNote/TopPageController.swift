//
//  TopPageController.swift
//  MahjongNote
//
//  Created by 藤井勇樹 on 2018/08/20.
//  Copyright © 2018 mahcial. All rights reserved.
//

import Foundation
import UIKit

class TopPageController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    @IBOutlet weak var naviBar: UINavigationItem!
    var pageViewController:UIPageViewController!
    var viewControllersArray:Array<UIViewController> = []
    let colors:Array<UIColor> = [UIColor.red, UIColor.gray, UIColor.blue]
    var pageControl: UIPageControl!
    // ナビゲーションバーに設定する月次
    var naviTitle: [String] = []
    // 最終更新日時
    var lastUpdate: String = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        /*
        addGameData(date: "20180729", gameFlag: "1700", gameNumber: 1, playerAName: "ちゃんくり", playerBName: "ふじプロ", playerCName: "KGさん", yourId: "0", playerAId: "1", playerBId: "2", playerCId: "3", yourRank: 2, playerARank: 1, playerBRank: 3, playerCRank: 4, yourScore: 3, playerAScore: 100, playerBScore: -23, playerCScore: 120, isPostServer: false)
        addGameData(date: "20180729", gameFlag: "1700", gameNumber: 2, playerAName: "ちゃんくり", playerBName: "ふじプロ", playerCName: "KGさん", yourId: "0", playerAId: "1", playerBId: "2", playerCId: "3", yourRank: 3, playerARank: 1, playerBRank: 2, playerCRank: 4, yourScore: -30, playerAScore: 110, playerBScore: 10, playerCScore: -90, isPostServer: false)
        addGameData(date: "20180730", gameFlag: "1700", gameNumber: 1, playerAName: "ちゃんくり", playerBName: "ふじプロ", playerCName: "KGさん", yourId: "0", playerAId: "1", playerBId: "2", playerCId: "3", yourRank: 2, playerARank: 1, playerBRank: 3, playerCRank: 4, yourScore: 20, playerAScore: 110, playerBScore: 10, playerCScore: -140, isPostServer: false)
        addGameData(date: "20180731", gameFlag: "1700", gameNumber: 1, playerAName: "ちゃんくり", playerBName: "ふじプロ", playerCName: "KGさん", yourId: "0", playerAId: "1", playerBId: "2", playerCId: "3", yourRank: 1, playerARank: 2, playerBRank: 3, playerCRank: 4, yourScore: 110, playerAScore: 10, playerBScore: -10, playerCScore: -110, isPostServer: false)
        addGameData(date: "20180801", gameFlag: "1700", gameNumber: 1, playerAName: "ちゃんくり", playerBName: "ふじプロ", playerCName: "KGさん", yourId: "0", playerAId: "1", playerBId: "2", playerCId: "3", yourRank: 1, playerARank: 2, playerBRank: 3, playerCRank: 4, yourScore: 110, playerAScore: 10, playerBScore: -10, playerCScore: -110, isPostServer: false)
        addGameData(date: "20180801", gameFlag: "1700", gameNumber: 2, playerAName: "ちゃんくり", playerBName: "ふじプロ", playerCName: "KGさん", yourId: "0", playerAId: "1", playerBId: "2", playerCId: "3", yourRank: 4, playerARank: 1, playerBRank: 2, playerCRank: 3, yourScore: -110, playerAScore: 120, playerBScore: 20, playerCScore: -30, isPostServer: false)
        
        addDailyData(date: "20180729", gameFlag: "1700", id: "1", amountOfGame: 2, first: 0, second: 1, third: 1, fourth: 0, averageRank: 2.5, income: 300, payment: -3000, bop: -2700, score: -27, rate: 100, gamePayment: -2000, playerAId: "aaa", playerBId: "bbb", playerCId: "ccc", playerAName: "ちゃんくり", playerBName: "おぐさん", playerCName: "フジプロ", isPostServer: false)
        addDailyData(date: "20180730", gameFlag: "1700", id: "1", amountOfGame: 1, first: 0, second: 1, third: 0, fourth: 0, averageRank: 2, income: 2000, payment: 0, bop: 2000, score: 20, rate: 100, gamePayment:-1000, playerAId:"aaa", playerBId:"bbb", playerCId:"ccc", playerAName: "ちゃんくり", playerBName: "おぐさん", playerCName: "フジプロ", isPostServer: false)
        addDailyData(date: "20180731", gameFlag: "1700", id: "1", amountOfGame: 1, first: 1, second: 0, third: 0, fourth: 0, averageRank: 1, income: 11000, payment: 0, bop: 11000, score: 110, rate: 100, gamePayment: -1000, playerAId:"aaa", playerBId: "bbb", playerCId: "ccc", playerAName: "ちゃんくり", playerBName: "おぐさん", playerCName: "フジプロ", isPostServer: false)
        addDailyData(date: "20180801", gameFlag: "1700", id: "1", amountOfGame: 1, first: 0, second: 1, third: 0, fourth: 0, averageRank: 2, income: 3200, payment: 0, bop: 3200, score: 32, rate: 100, gamePayment: -1000, playerAId:"aaa", playerBId: "bbb", playerCId: "ccc", playerAName: "ちゃんくり", playerBName: "おぐさん", playerCName: "フジプロ", isPostServer: false)
        addDailyData(date: "20180802", gameFlag: "1700", id: "1", amountOfGame: 1, first: 0, second: 0, third: 1, fourth: 0, averageRank: 3, income: 0, payment: -1000, bop: -1000, score: -10, rate: 100, gamePayment: -1000, playerAId:"aaa", playerBId: "bbb", playerCId: "ccc", playerAName: "ちゃんくり", playerBName: "おぐさん", playerCName: "フジプロ", isPostServer: false)
        addDailyData(date: "20180803", gameFlag: "1700", id: "1", amountOfGame: 2, first: 1, second: 0, third: 0, fourth: 1, averageRank: 2.5, income: 11000, payment: -14000, bop: -3000, score: -30, rate: 100, gamePayment: -2000, playerAId:"aaa", playerBId: "bbb", playerCId: "ccc", playerAName: "ちゃんくり", playerBName: "おぐさん", playerCName: "フジプロ", isPostServer: false)
*/
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        // カラー
        let blue: UIColor = UIColor(red: 0.121569, green: 0.466667, blue: 0.705882, alpha: 1.0)
        let red: UIColor = UIColor(red: 0.89, green: 0.29, blue: 0.29, alpha: 1.0)
        
        // 日ごとのデータをすべて取得
        let dailyResults = getDailyData(date: "2")
        
        // 月ごとのデータを取得
        let monthlyResults = getMonthly(data: dailyResults)
        
        // 総合データを取得
        let totalResults = getTotally(data: dailyResults)
        
        // 月ごとのデータと総合データを連結
        let allResults = totalResults + monthlyResults
        // PageViewを生成するときに、逆順の方が都合がいいため、逆の配列も用意する
        let allResultsReverse = Array(allResults.reversed())
        
        // 最終更新を取得。ナビゲーションバーにも初期値としてセットする
        // もしデータがない初期状態なら、現在日時を取得して指定する?
        lastUpdate = dailyResults[0].date
        if (lastUpdate == "") {
            let now = NSDate()
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyyMMdd"
            let nowDate = formatter.string(from: now as Date)
            naviBar.title = formatYearAndMonth(date: nowDate)
        } else {
            naviBar.title = formatYearAndMonth(date: lastUpdate)
        }
        
        // PageViewControllerに表示するViewControllerを生成
        for index in 0 ..< allResultsReverse.count {
            
            let topController = storyboard.instantiateViewController(withIdentifier: "Top") as! TopController
            topController.view.tag = index
            
            // テキストラベルのセット
            topController.income.text = addPlusSymbol(number :formatComma(num: allResultsReverse[index].income))
            topController.payment.text = addPlusSymbol(number :formatComma(num: allResultsReverse[index].payment))
            topController.bop.text = addPlusSymbol(number :formatComma(num: allResultsReverse[index].bop))
            topController.gamePayment.text = addPlusSymbol(number :formatComma(num: allResultsReverse[index].gamePayment))
            topController.bopWithGamePayment.text = addPlusSymbol(number :formatComma(num: allResultsReverse[index].bopWithGamePayment))
            topController.first.text = String(allResultsReverse[index].first)
            topController.second.text = String(allResultsReverse[index].second)
            topController.third.text = String(allResultsReverse[index].third)
            topController.fourth.text = String(allResultsReverse[index].fourth)
            topController.averageRank.text = String(allResultsReverse[index].averageRank)
            topController.averageScore.text = addPlusSymbol(number: (String(allResultsReverse[index].averageScore)))
            topController.finalDate.text = String(formatDate(dateString: lastUpdate))
            
            // ナビゲーションタイトル用の配列にセット
            naviTitle.append(allResultsReverse[index].month)

            // フォントサイズと色のセット
            topController.averageRank.adjustsFontSizeToFitWidth = true
            topController.averageScore.adjustsFontSizeToFitWidth = true
            topController.income.textColor = blue
            topController.payment.textColor = red
            topController.gamePayment.textColor = red
            if (allResultsReverse[index].bop >= 0) {
                topController.bop.textColor = blue
            } else {
                topController.bop.textColor = red
            }
            if (allResultsReverse[index].bopWithGamePayment >= 0) {
                topController.bopWithGamePayment.textColor = blue
            } else {
                topController.bopWithGamePayment.textColor = red
            }
            if (allResultsReverse[index].averageRank <= 2.5) {
                topController.averageRank.textColor = blue
            } else {
                topController.averageRank.textColor = red
            }
            if (allResultsReverse[index].averageScore >= 0) {
                topController.averageScore.textColor = blue
            } else {
                topController.averageScore.textColor = red
            }
            
            // チャート描画のために、当月の日付データを取得
            var dailyData = getDailyData(date: allResultsReverse[index].month)
            if (allResultsReverse[index].month == "総合") {
                dailyData = dailyResults
            }
            
            // チャートデータのセット
            var chartData: [CGFloat] = []
            var chartXLavels: [String] = []
            var bopAccumulation: CGFloat = 0
            for dailyDatum in dailyData.reversed() {
                bopAccumulation += CGFloat(dailyDatum.bop)
                chartData.append(CGFloat(bopAccumulation))
                chartXLavels.append(getDay(date: dailyDatum.date))
            }
            topController.chartData = chartData
            topController.chartXLavels = chartXLavels
            
            // カレンダーのセット
            var calendarDate: (Int,Int) = (0,0)
            if (allResultsReverse[index].month == "総合") {
                calendarDate = formatCalendar(date: allResultsReverse[index-1].month)
            } else {
                calendarDate = formatCalendar(date: allResultsReverse[index].month)
            }
            topController.year = calendarDate.0
            topController.month = calendarDate.1
            
            // カレンダーのサブタイトルのためのdictionaryを作成
            for dailyBop in dailyData {
                topController.dailyData[dailyBop.date] = String(dailyBop.bop)
            }
            
            // viewの追加
            viewControllersArray.append(topController)
        }
        
        //PageViewControllerの生成
        pageViewController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.scroll,
                                                  navigationOrientation: UIPageViewControllerNavigationOrientation.horizontal,
                                                  options: nil)
        //DelegateとDataSouceの設定
        pageViewController.dataSource = self
        pageViewController.delegate = self
        
        //はじめに生成するページを設定
        pageViewController.setViewControllers([viewControllersArray.first!], direction: .forward, animated: true, completion: nil)
        pageViewController.view.frame = self.view.frame
        self.view.addSubview(pageViewController.view!)
        
        //PageControlの生成
        pageControl = UIPageControl()
        
        // PageControlするページ数を設定する.
        pageControl.numberOfPages = allResults.count
        
        // 現在ページを設定する.(今月にする)
        pageControl.currentPage = 0
        pageViewController.setViewControllers(
            [viewControllersArray[allResults.count-2]], direction: .forward, animated: false, completion: nil)
        pageControl.isUserInteractionEnabled = false
        self.view.addSubview(pageControl)
        
    }
    
    //DataSourceのメソッド
    //指定されたViewControllerの後にViewControllerを返す
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = viewController.view.tag
        pageControl.currentPage = index
        if index == colors.count - 1{
            return nil
        }
        index = index + 1
        return viewControllersArray[index]
    }
    
    //DataSourceのメソッド
    //指定されたViewControllerの前にViewControllerを返す
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = viewController.view.tag
        pageControl.currentPage = index
        index = index - 1
        if index < 0{
            return nil
        }
        return viewControllersArray[index]
    }
    
    //Viewが変更されると呼ばれる
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating: Bool, previousViewControllers: [UIViewController], transitionCompleted: Bool) {

        //naviBar.title = formatComma(num: allResultsReverse[pageViewController.viewControllers![0].view.tag]
        if (naviTitle[pageViewController.viewControllers![0].view.tag] != "総合") {
            naviBar.title = formatYearAndMonth(date: naviTitle[pageViewController.viewControllers![0].view.tag])
        } else {
            naviBar.title = naviTitle[pageViewController.viewControllers![0].view.tag]
        }
    }
}


