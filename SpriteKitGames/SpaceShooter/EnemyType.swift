//
//  EnemyType.swift
//  EndlessRunner
//
//  Created by Ashraful Islam on 3/16/25.
//

import SpriteKit

struct EnemyType: Codable {
    let name: String
    let shields: Int
    let speed: CGFloat
    let powerUpChance: Int
}

