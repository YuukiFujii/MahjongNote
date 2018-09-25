//
//  TopController.swift
//  MahjongNote
//
//  Created by 藤井勇樹 on 2018/08/12.
//  Copyright © 2018 mahcial. All rights reserved.
//

import UIKit
import QuartzCore
import FSCalendar

class TopController : UIViewController, XMLParserDelegate, LineChartDelegate, FSCalendarDelegate, FSCalendarDataSource, FSCalendarDelegateAppearance {
    
    var label = UILabel()
    @IBOutlet weak var chart: UIView!
    @IBOutlet weak var calendar: UIView!
    // カラー
    let blue: UIColor = UIColor(red: 0.121569, green: 0.466667, blue: 0.705882, alpha: 1.0)
    let red: UIColor = UIColor(red: 0.89, green: 0.29, blue: 0.29, alpha: 1.0)
    
    // StoryBoardのlabel
    @IBOutlet weak var income: UILabel!
    @IBOutlet weak var payment: UILabel!
    @IBOutlet weak var bop: UILabel!
    @IBOutlet weak var finalDate: UILabel!
    @IBOutlet weak var bopWithGamePayment: UILabel!
    @IBOutlet weak var gamePayment: UILabel!
    @IBOutlet weak var first: UILabel!
    @IBOutlet weak var second: UILabel!
    @IBOutlet weak var third: UILabel!
    @IBOutlet weak var fourth: UILabel!
    @IBOutlet weak var averageRank: UILabel!
    @IBOutlet weak var averageScore: UILabel!
    
    // チャート
    var lineChart: LineChart!
    var chartData: [CGFloat] = []
    var chartXLavels: [String] = []
    
    // カレンダー
    let dateView = FSCalendar()
    var year: Int = 2018
    var month: Int = 8
    // カレンダー表示用の収支dictionary
    var dailyData: [String: String] = [:]
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        // ios11からライフサイクルが変わって、AppDelegateのメソッドが
        // controllerの描画タイミングより遅くなった。からしょうがなく、controllerでデータの取得する。
        // 参考 : goo.gl/mj25Re
        
        var views: [String: AnyObject] = [:]

        label.textAlignment = NSTextAlignment.right
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = label.font.withSize(20)
        self.chart.addSubview(label)
        views["label"] = label

        chart.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[label]-|", options: [], metrics: nil, views: views))
        chart.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-80-[label]", options: [], metrics: nil, views: views))
        
        //let data: [CGFloat] = [-19700.0, 0.0, 12000.0, 2000.0, -13000.0, -10000.0]
        // 折れ線を増やすなら下のようにデータを準備する
        //let data2: [CGFloat] = [19700, -1000, -12000, 10000, 13000, -5000]

        //let xLabels: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun"]
        
        lineChart = LineChart()
        lineChart.animation.enabled = true
        lineChart.area = true
        lineChart.x.labels.visible = true
        lineChart.x.grid.count = 5
        lineChart.y.grid.count = 5
        lineChart.x.labels.values = chartXLavels
        lineChart.y.labels.visible = false
        lineChart.addLine(chartData)
        // 折れ線の追加は下のように、準備したデータを追加する
        //lineChart.addLine(data2)

        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.delegate = self
        self.chart.addSubview(lineChart)

        views["chart"] = lineChart
        //chart.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[chart]-|", options: [], metrics: nil, views: views))
        //chart.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[label]-[chart(==200)]", options: [], metrics: nil, views: views))

        lineChart.translatesAutoresizingMaskIntoConstraints = false
        lineChart.topAnchor.constraint(equalTo: chart.topAnchor).isActive = true
        lineChart.bottomAnchor.constraint(equalTo: chart.bottomAnchor).isActive = true
        lineChart.leftAnchor.constraint(equalTo: chart.leftAnchor).isActive = true
        lineChart.rightAnchor.constraint(equalTo: chart.rightAnchor).isActive = true

        // ここからカレンダー
        //カレンダー設定
        self.dateView.dataSource = self
        self.dateView.delegate = self
        self.dateView.today = nil
        self.dateView.tintColor = .red
        dateView.backgroundColor = .white
        calendar.addSubview(dateView)

        dateView.translatesAutoresizingMaskIntoConstraints = false
        dateView.topAnchor.constraint(equalTo: calendar.topAnchor).isActive = true
        dateView.bottomAnchor.constraint(equalTo: calendar.bottomAnchor).isActive = true
        dateView.leftAnchor.constraint(equalTo: calendar.leftAnchor).isActive = true
        dateView.rightAnchor.constraint(equalTo: calendar.rightAnchor).isActive = true
        dateView.scrollEnabled = false
        dateView.headerHeight = 0
        dateView.select(Calendar.current.date(from: DateComponents(year: year, month: month)))
        dateView.allowsSelection = false

        // ここまでカレンダー

    }
    
    /**
     * Line chart delegate method.
     */
    func didSelectDataPoint(_ x: CGFloat, yValues: Array<CGFloat>) {
        let y: Int = Int(yValues[0])
        label.text = "\(y)"
        if (y >= 0) {
            label.textColor = blue
        } else {
            label.textColor = red
        }
        label.textAlignment = NSTextAlignment.right
    }
    
    /**
     * Redraw chart on device rotation.
     */
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        if let chart = lineChart {
            chart.setNeedsDisplay()
        }
    }

    // ここからカレンダーメソッド
    // date型 -> 年月日をIntで取得
    func getDay(_ date:Date) -> (Int,Int,Int){
        let tmpCalendar = Calendar(identifier: .gregorian)
        let year = tmpCalendar.component(.year, from: date)
        let month = tmpCalendar.component(.month, from: date)
        let day = tmpCalendar.component(.day, from: date)
        return (year,month,day)
    }
    //曜日判定
    func getWeekIdx(_ date: Date) -> Int{
        let tmpCalendar = Calendar(identifier: .gregorian)
        return tmpCalendar.component(.weekday, from: date)
    }
    
    // 土日や祝日の日の文字色を変える
    // 下の「選択時」と同じ処理
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        //土日の判定
        let weekday = self.getWeekIdx(date)
        if weekday == 1 {
            return UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
        } else if weekday == 7 {
            return UIColor(red: 0, green: 0, blue: 1, alpha: 0.5)
        } else {
            return UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        }
    }
    
    // 選択された日付の背景色を透明に
    // 今回は選択させないから
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, fillSelectionColorFor date: Date) -> UIColor? {
        return UIColor(red: 0, green: 0, blue: 0, alpha: 0)
    }
    
    // 選択された日付のタイトル(日付)の色を指定
    // 上の「未選択時」の処理と同じ
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleSelectionColorFor date: Date) -> UIColor? {
        //土日の判定
        let weekday = self.getWeekIdx(date)
        if weekday == 1 {
            return UIColor(red: 1, green: 0, blue: 0, alpha: 0.5)
        } else if weekday == 7 {
            return UIColor(red: 0, green: 0, blue: 1, alpha: 0.5)
        } else {
            return UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
        }
    }
    // 選択された日付のサブタイトル(収支)の色を指定
    // 下のサブタイトルの色設定と同じ処理
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, subtitleSelectionColorFor date: Date) -> UIColor? {
        let year: String = String(self.getDay(date).0)
        var month: String = String(self.getDay(date).1)
        // 1桁の場合は0を足す(7 → 07)
        if (month.count == 1) {
            month = "0" + month
        }
        // 1桁の場合は0を足す(1 -> 01)
        var day: String = String(self.getDay(date).2)
        if (day.count == 1) {
            day = "0" + day
        }
        // カレンダーに表示されている日付を取得
        let data = year + month + day
        
        if let bop = dailyData[data]{
            if (Int(bop)! >= 0) {
                return blue
            } else {
                return red
            }
        } else {
            return nil
        }
    }
 
    // カレンダーのサブタイトル(収支)の値をセット
    func calendar(_ calendar: FSCalendar, subtitleFor date: Date) -> String? {
        // カレンダーに表示されている日付を取得
        let year: String = String(self.getDay(date).0)
        var month: String = String(self.getDay(date).1)
        // 1桁の場合は0を足す(7 → 07)
        if (month.count == 1) {
            month = "0" + month
        }
        // 1桁の場合は0を足す(1 -> 01)
        var day: String = String(self.getDay(date).2)
        if (day.count == 1) {
            day = "0" + day
        }
        let data = year + month + day

        if let bop = dailyData[data]{
            return addPlusSymbol(number: bop)
        } else {
            return ""
        }
    }
    
    // カレンダーのサブタイトル(収支)の色をセット
    // 上の「選択時」のサブタイトルの色と同じ処理
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, subtitleDefaultColorFor date: Date) -> UIColor? {
        let year: String = String(self.getDay(date).0)
        var month: String = String(self.getDay(date).1)
        // 1桁の場合は0を足す(7 → 07)
        if (month.count == 1) {
            month = "0" + month
        }
        // 1桁の場合は0を足す(1 -> 01)
        var day: String = String(self.getDay(date).2)
        if (day.count == 1) {
            day = "0" + day
        }
        // カレンダーに表示されている日付を取得
        let data = year + month + day
        
        if let bop = dailyData[data]{
            if (Int(bop)! >= 0) {
                return blue
            } else {
                return red
            }
        } else {
            return nil
        }
    }

    // ここまで
    
}
