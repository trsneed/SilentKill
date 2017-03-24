//
//  GameRound.swift
//  SilentKill.iOS
//

import UIKit
import SwiftyJSON

struct GameRound: Model {
    typealias T = GameRound
    
    let createdAt: Date
    let roundId: UInt
    let alivePlayersCount: UInt
    let deadPlayersCount: UInt
    let ongoing: Bool
    let players: [Player]

    init(createdAt: Date, roundId: UInt, alivePlayersCount: UInt, deadPlayersCount: UInt, ongoing: Bool, players: [Player]) {
        self.createdAt = createdAt
        self.roundId = roundId
        self.alivePlayersCount = alivePlayersCount
        self.deadPlayersCount = deadPlayersCount
        self.ongoing = ongoing
        self.players = players
    }

    static func Create(json: [JSON]) -> [GameRound]? {
        guard let rounds = (json.map { (jsonRound) -> GameRound? in
            GameRound.Create(json: jsonRound)
            }.filter { (round) -> Bool in
                return round != nil
            } as? [GameRound])
            else { return nil }

        return rounds
    }

    static func Create(json: JSON) -> GameRound? {
        guard let id = json["id"].uInt else { return nil }
        guard let alivePlayersCount = json["alive_players_count"].uInt else { return nil }
        guard let deadPlayersCount = json["dead_players_count"].uInt else { return nil }
        guard let ongoing = json["ongoing"].bool else { return nil }
        guard let createdAt = json["created_at"].date else { return nil }
        guard let jsonPlayers = json["players"].array else { return nil }
        guard let players = Player.Create(json: jsonPlayers) else { return nil }

        return GameRound(createdAt: createdAt, roundId: id, alivePlayersCount: alivePlayersCount, deadPlayersCount: deadPlayersCount, ongoing: ongoing, players: players)
    }
}

protocol Model {
    associatedtype T
    static func Create(json: JSON) -> T?
    static func Create(json: [JSON]) -> [T]?
}

extension JSON {
    public var date: Date? {
        get {
            if let str = self.string {
                return JSON.jsonDateFormatter.date(from: str)
            }
            return nil
        }
    }

    private static let jsonDateFormatter: DateFormatter = {
        let fmt = DateFormatter()
        fmt.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        return fmt
    }()
}
