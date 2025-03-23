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
    var onRequestSceneReset: (() -> Void)?
    
    var player1: SKSpriteNode!
    var player2: SKSpriteNode!
    var banana: SKSpriteNode!
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
        createBuildings()
        createPlayers()
        
        physicsWorld.contactDelegate = self
    }
    
    override func update(_ currentTime: TimeInterval) {
        guard banana != nil else { return }
        
        if abs(banana.position.y) > 1000 {
            banana.removeFromParent()
            banana = nil
            changePlayer()
        }

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
        let speed = Double(velocity) / 10.0
        let radians = Double(angle) * .pi / 180
        
        if banana != nil {
            banana.removeFromParent()
            banana = nil
        }
        
        banana = SKSpriteNode(imageNamed: "banana")
        banana.name = "banana"
        banana.physicsBody = SKPhysicsBody(circleOfRadius: banana.size.width / 2)
        banana.physicsBody?.categoryBitMask = eMonkeyCollisionType.banana.rawValue
        banana.physicsBody?.collisionBitMask = eMonkeyCollisionType.building.rawValue | eMonkeyCollisionType.player.rawValue
        banana.physicsBody?.contactTestBitMask = eMonkeyCollisionType.building.rawValue | eMonkeyCollisionType.player.rawValue
        banana.physicsBody?.isDynamic = true
        banana.physicsBody?.usesPreciseCollisionDetection = true
        banana.physicsBody?.mass = 0.01
        
        addChild(banana)
        
        if activePlayer?.wrappedValue == .player1 {
            banana.position = CGPoint(x: player1.position.x - 30, y: player1.position.y + 40)
            banana.physicsBody?.angularVelocity = -20
            banana.physicsBody?.applyImpulse(CGVector(dx: cos(radians) * speed, dy: sin(radians) * speed))
        } else {
            banana.position = CGPoint(x: player2.position.x + 30, y: player2.position.y + 40)
            banana.physicsBody?.angularVelocity = 20
            banana.physicsBody?.applyImpulse(CGVector(dx: -cos(radians) * speed, dy: sin(radians) * speed))
        }
        
        let monkey = activePlayer?.wrappedValue == .player1 ? player1 : player2
        
        let raiseArm = SKAction.setTexture(SKTexture(imageNamed: "player\(activePlayer?.wrappedValue.rawValue ?? 0)Throw"))
        let lowerArm = SKAction.setTexture(SKTexture(imageNamed: "monkeyPlayer"))
        let pause = SKAction.wait(forDuration: 0.15)
        let sequence = SKAction.sequence([raiseArm, pause, lowerArm])
        monkey?.run(sequence)
    }
    
    

}

extension ExplodingMonkeyGameScene: SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let firstBody: SKPhysicsBody
        let secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        guard let firstNode = firstBody.node else { return }
        guard let secondNode = secondBody.node else { return }
        
        if firstNode.name == "banana" && secondNode.name == "building" {
            bananaHit(building: secondNode, atPoint: contact.contactPoint)
        }
        
        if firstNode.name == "banana" && secondNode.name == "player1" {
            destroy(player: player1)
        }
        
        if firstNode.name == "banana" && secondNode.name == "player2" {
            destroy(player: player2)
        }
    }
    
    func destroy(player: SKSpriteNode) {
        if let explosion = SKEmitterNode(fileNamed: "Explosion") {
            explosion.position = player.position
            addChild(explosion)
            explosion.run(.sequence([.wait(forDuration: 3), .removeFromParent()]))
        }
        
        player.removeFromParent()
        banana.removeFromParent()
        changePlayer()
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
          self.onRequestSceneReset?()
        }
    }
    
    func bananaHit(building: SKNode, atPoint contactPoint: CGPoint) {
        guard let building = building as? BuildingNode else { return }
        
        let buildingLocation = convert(contactPoint, to: building)
        building.hit(at: buildingLocation)
        
        if let explosion = SKEmitterNode(fileNamed: "Explosion") {
            explosion.position = contactPoint
            addChild(explosion)
            explosion.run(.sequence([.wait(forDuration: 3), .removeFromParent()]))
        }
        
        banana.name = "" // this will prevent the banana from causing further collisions
        banana.removeFromParent()
        banana = nil
        changePlayer()
    }
    
    func changePlayer() {
        if activePlayer?.wrappedValue == .player1 {
            activePlayer?.wrappedValue = .player2
        } else {
            activePlayer?.wrappedValue = .player1
        }
        isPlayerDisabled?.wrappedValue = false
    }
}
