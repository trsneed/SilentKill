//
//  Player.swift
//  SilentKill.iOS
//
//  Created by Tim Sneed on 3/10/17.
//  Copyright © 2017 SilentKill. All rights reserved.
//

import UIKit
import SwiftyJSON

struct Player: Model {
    typealias T = Player

    let id: UInt
    let username: String

    init(id: UInt, username: String) {
        self.id = id
        self.username = username
    }

    static func Create(json: [JSON]) -> [Player]? {
        guard let players = (json.map { (jsonPlayer) -> Player? in
            Player.Create(json: jsonPlayer)
        }.filter { (player) -> Bool in
            return player != nil
            } as? [Player])
        else { return nil }

        return players
    }

    static func Create(json: JSON) -> Player? {
        guard let id = json["id"].uInt else { return nil }
        guard let username = json["username"].string else { return nil }

        return Player(id: id, username: username)
    }
}
