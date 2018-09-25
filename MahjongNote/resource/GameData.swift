//
//  GameData.swift
//  MahjongNote
//
//  Created by 藤井勇樹 on 2018/08/12.
//  Copyright © 2018 mahcial. All rights reserved.
//

import Foundation
import RealmSwift

class GameData: Object {
    @objc dynamic var date: String = ""
    // 同日データを登録したときに、別日と判定するためのフラグ
    // 入力時の時間を入れて、同日データと判別する
    @objc dynamic var gameFlag: String = ""
    @objc dynamic var gameNumber: Int = 0
    @objc dynamic var playerAName: String = ""
    @objc dynamic var playerBName: String = ""
    @objc dynamic var playerCName: String = ""
    @objc dynamic var yourId: String = ""
    @objc dynamic var playerAId: String = ""
    @objc dynamic var playerBId: String = ""
    @objc dynamic var playerCId: String = ""
    @objc dynamic var yourRank: Int = 0
    @objc dynamic var playerARank: Int = 0
    @objc dynamic var playerBRank: Int = 0
    @objc dynamic var playerCRank: Int = 0
    @objc dynamic var yourScore: Int = 0
    @objc dynamic var playerAScore: Int = 0
    @objc dynamic var playerBScore: Int = 0
    @objc dynamic var playerCScore: Int = 0
    @objc dynamic var isPostServer: Bool = false
}
