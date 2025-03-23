//
//  ExplodingMonkeyGameScene.swift
//  SpriteKitGames
//
//  Created by Ashraful Islam on 3/22/25.
//

import SpriteKit
import SwiftUICore

enum eMonkeyCollisionType: UInt32 {
    case banana = 1
    case building = 2
    case player = 4
}

class ExplodingMonkeyGameScene: SKScene {
    var buildings = [BuildingNode]()
    var isPlayerDisabled: Binding<Bool>?
    var activePlayer: Binding<monkeyPlayer>?
    
    var player1: SKSpriteNode!
    var player2: SKSpriteNode!
    var banana: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
        createBuildings()
        createPlayers()
    }
    
    func createBuildings() {
        var currentX: CGFloat = -15
        
        while currentX < frame.width + 15 {
            let size = CGSize(width: Int.random(in: 2...4) * 40, height: Int.random(in: 300...600))
            currentX += size.width + 2
            
            let building = BuildingNode(color: .red, size: size)
            building.position = CGPoint(x: currentX - (size.width / 2), y: size.height / 2)
            building.setup()
            addChild(building)
            
            buildings.append(building)
        }

    }
    
    func createPlayers() {
        player1 = SKSpriteNode(imageNamed: "monkeyPlayer")
        player1.name = "player1"
        player1.physicsBody = SKPhysicsBody(circleOfRadius: player1.size.width / 2)
        player1.physicsBody?.categoryBitMask = eMonkeyCollisionType.player.rawValue
        player1.physicsBody?.collisionBitMask = eMonkeyCollisionType.banana.rawValue
        player1.physicsBody?.contactTestBitMask = eMonkeyCollisionType.banana.rawValue
        player1.physicsBody?.isDynamic = false
        
        let player1Building = buildings[1]
        player1.position = CGPoint(
            x: player1Building.position.x,
            y: player1Building.position.y + (player1Building.size.height + player1.size.height) / 2
        )
        
        addChild(player1)
        
        player2 = SKSpriteNode(imageNamed: "monkeyPlayer")
        player2.name = "player2"
        player2.physicsBody = SKPhysicsBody(circleOfRadius: player2.size.width / 2)
        player2.physicsBody?.categoryBitMask = eMonkeyCollisionType.player.rawValue
        player2.physicsBody?.collisionBitMask = eMonkeyCollisionType.banana.rawValue
        player2.physicsBody?.contactTestBitMask = eMonkeyCollisionType.banana.rawValue
        player2.physicsBody?.isDynamic = false
        
        let player2Building = buildings[buildings.count - 2]
        player2.position = CGPoint(
            x: player2Building.position.x,
            y: player2Building.position.y + (player2Building.size.height + player2.size.height) / 2
        )
        
        addChild(player2)
    }
    
    func launch(angle: Int, velocity: Int) {
        isPlayerDisabled?.wrappedValue = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isPlayerDisabled?.wrappedValue = false
            self.activePlayer?.wrappedValue = self.activePlayer?.wrappedValue == .player1 ? .player2 : .player1
        }
    }
    
    

}
