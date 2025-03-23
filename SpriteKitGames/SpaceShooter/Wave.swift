//
//  Wave.swift
//  EndlessRunner
//
//  Created by Ashraful Islam on 3/16/25.
//

import SpriteKit

struct Wave: Codable {
    struct WaveEnemy: Codable {
        let position: Int
        let xOffset: CGFloat
        let moveStraight: Bool
    }
    let name: String
    let enemies: [WaveEnemy]
}
