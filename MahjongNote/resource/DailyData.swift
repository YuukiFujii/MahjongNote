//
//  GameData.swift
//  MahjongNote
//
//  Created by 藤井勇樹 on 2018/08/12.
//  Copyright © 2018 mahcial. All rights reserved.
//

import Foundation
import RealmSwift

class DailyData: Object {
    @objc dynamic var date: String = ""
    // 同日データを登録したときに、別日と判定するためのフラグ
    // 入力時の時間を入れて、同日データと判別する
    @objc dynamic var gameFlag: String = ""
    @objc dynamic var id: String = ""
    @objc dynamic var amountOfGame: Int = 0
    @objc dynamic var first: Int = 0
    @objc dynamic var second: Int = 0
    @objc dynamic var third: Int = 0
    @objc dynamic var fourth: Int = 0
    @objc dynamic var averageRank: Double = 0
    @objc dynamic var income: Int = 0
    @objc dynamic var payment: Int = 0
    @objc dynamic var bop: Int = 0
    @objc dynamic var score: Int = 0
    @objc dynamic var rate = 0
    @objc dynamic var gamePayment: Int = 0
    @objc dynamic var playerAId: String = ""
    @objc dynamic var playerBId: String = ""
    @objc dynamic var playerCId: String = ""
    @objc dynamic var playerAName: String = ""
    @objc dynamic var playerBName: String = ""
    @objc dynamic var playerCName: String = ""
    @objc dynamic var isPostServer: Bool = false
}
