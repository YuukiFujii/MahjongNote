//
//  HistorialController.swift
//  MahjongNote
//
//  Created by 藤井勇樹 on 2018/08/12.
//  Copyright © 2018 mahcial. All rights reserved.
//

import UIKit
import RealmSwift

class HistoricalController: UITableViewController {
    
    var dayResults: Results<DailyData>!
    
    // カラー
    let blue: UIColor = UIColor(red: 0.121569, green: 0.466667, blue: 0.705882, alpha: 1.0)
    let red: UIColor = UIColor(red: 0.89, green: 0.29, blue: 0.29, alpha: 1.0)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 日毎のデータを取得
        dayResults = getDailyData(date: "2")
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dayResults.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomCell", for: indexPath) as! HistoryCell

        // 値の設定
        cell.date.text = formatDate(dateString: dayResults[indexPath.row].date)
        cell.averageRank.text = String(dayResults[indexPath.row].averageRank)
        cell.bop.text = addPlusSymbol(number: formatComma(num: dayResults[indexPath.row].bop))
        cell.first.text = String(dayResults[indexPath.row].first)
        cell.second.text = String(dayResults[indexPath.row].second)
        cell.third.text = String(dayResults[indexPath.row].third)
        cell.fourth.text = String(dayResults[indexPath.row].fourth)
        
        // 色の設定
        if (dayResults[indexPath.row].averageRank <= 2.5) {
            cell.averageRank.textColor = blue
        } else {
            cell.averageRank.textColor = red
        }
        if (dayResults[indexPath.row].bop >= 0) {
            cell.bop.textColor = blue
        } else {
            cell.bop.textColor = red
        }
 
        return cell
    }
    
}
