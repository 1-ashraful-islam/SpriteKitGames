    //
    //  GameScene.swift
    //  EndlessRunner
    //
    //  Created by Ashraful Islam on 3/15/25.
    //

import SpriteKit
import GameplayKit
import CoreMotion

enum spaceCollisionType: UInt32 {
    case player = 1
    case playerWeapon = 2
    case enemy = 4
    case enemyWeapon = 8
}

class SpaceShooterGameScene: SKScene, SKPhysicsContactDelegate {
    let motionManager = CMMotionManager()
    
    let player = SKSpriteNode(imageNamed: "player")
    let waves = Bundle.main.decode([Wave].self, from: "waves.json")
    let enemyTypes = Bundle.main.decode([EnemyType].self, from: "enemy-types.json")
    
    var isPlayerAlive = true
    var levelNumber = 0
    var waveNumber = 0
    var playerShields = 10
    
    let positions: [CGFloat] = Array(stride(from: -320, through: 320, by: 80))
    
    override func didMove(to view: SKView) {
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        if let particles = SKEmitterNode(fileNamed: "stardust") {
            particles.position = CGPoint(x: 1080, y: 0)
            particles.advanceSimulationTime(60)
            particles.zPosition = -1
            addChild(particles)
        }
        
        player.name = "player"
        player.position.x = frame.minX + 75
        player.zPosition = 1
        addChild(player)
        
        player.physicsBody = SKPhysicsBody(texture: player.texture!, size: player.texture!.size())
        player.physicsBody?.categoryBitMask = spaceCollisionType.player.rawValue
        player.physicsBody?.collisionBitMask = spaceCollisionType.enemy.rawValue | spaceCollisionType.enemyWeapon.rawValue
        player.physicsBody?.contactTestBitMask = spaceCollisionType.enemy.rawValue | spaceCollisionType.enemyWeapon.rawValue
        player.physicsBody?.isDynamic = false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard isPlayerAlive else { return }
        fireWeapon()
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if let accelerometerData = motionManager.accelerometerData {
            player.position.y += CGFloat(accelerometerData.acceleration.x * 50)
            
            if player.position.y < frame.minY {
                player.position.y = frame.minY
            } else if player.position.y > frame.maxY {
                player.position.y = frame.maxY
            }
            
        }
        
        for child in children {
            if child.frame.maxX < 0 {
                if !frame.intersects(child.frame) {
                    child.removeFromParent()
                }
            }
        }
        
        let activeEnemies = children.compactMap { $0 as? EnemyNode }
        
        if activeEnemies.isEmpty {
            createWave()
        }
        
        for enemy in activeEnemies {
            guard frame.intersects(enemy.frame) else { continue }
            
            if enemy.lastFireTime + 1 < currentTime {
                enemy.lastFireTime = currentTime
                
                if Int.random(in: 0...6) == 0 {
                    enemy.fire()
                }
            }
        }
        
    }
    
    func createWave() {
        guard isPlayerAlive else { return }
        
        if waveNumber == waves.count {
            levelNumber += 1
            waveNumber = 0
        }
        
        let currentWave = waves[waveNumber]
        waveNumber += 1
        
        let maximumEnemyType = min(enemyTypes.count, levelNumber + 1)
        let enemyType = Int.random(in: 0..<maximumEnemyType)
        
        let enemyOffsetX: CGFloat = 100
        let enemyStartX: CGFloat = 600
        
        if currentWave.enemies.isEmpty {
            for (index, position) in positions.shuffled().enumerated() {
                let enemy = EnemyNode(type: enemyTypes[enemyType], startPosition: CGPoint(x: enemyStartX, y: position), xOffset: enemyOffsetX * CGFloat(index * 3), moveStraight: true)
                addChild(enemy)
            }
        } else {
            for enemy in currentWave.enemies {
                let node = EnemyNode(type: enemyTypes[enemyType], startPosition: CGPoint(x: enemyStartX, y: positions[enemy.position]), xOffset: enemyOffsetX * enemy.xOffset, moveStraight: enemy.moveStraight)
                addChild(node)
            }
                
        }
        

    }
    
    func fireWeapon() {
        let weaponType = "playerWeapon"
        
        let weapon = SKSpriteNode(imageNamed: weaponType)
        weapon.name = "playerWeapon"
        weapon.position = player.position
        
        weapon.physicsBody = SKPhysicsBody(rectangleOf: weapon.size)
        weapon.physicsBody?.categoryBitMask = spaceCollisionType.playerWeapon.rawValue
        weapon.physicsBody?.collisionBitMask = spaceCollisionType.enemy.rawValue | spaceCollisionType.enemyWeapon.rawValue
        weapon.physicsBody?.contactTestBitMask = spaceCollisionType.enemy.rawValue | spaceCollisionType.enemyWeapon.rawValue
        weapon.physicsBody?.mass = 0.001
        
        addChild(weapon)
        
        let movement = SKAction.move(to: CGPoint(x: 1900, y: weapon.position.y), duration: 5)
        let sequence = SKAction.sequence([movement, .removeFromParent()])
        weapon.run(sequence)
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
        
        let sortedNodes = [nodeA, nodeB].sorted { $0.name ?? "" < $1.name ?? "" }
        
        let firstNode = sortedNodes[0]
        let secondNode = sortedNodes[1]
        
        if secondNode.name == "player" {
            guard isPlayerAlive else { return }
            if let explosion = SKEmitterNode(fileNamed: "Explosion") {
                explosion.position = firstNode.position
                addChild(explosion)
                
                explosion.run(.sequence([.wait(forDuration: 3), .removeFromParent()]))
            }
            
            playerShields -= 1
            if playerShields == 0 {
                gameOver()
                secondNode.removeFromParent()
            }
            
            firstNode.removeFromParent()
        } else if let enemy = firstNode as? EnemyNode {
            enemy.shields -= 1
            if enemy.shields == 0 {
                if let explosion = SKEmitterNode(fileNamed: "Explosion") {
                    explosion.position = enemy.position
                    addChild(explosion)
                    
                    explosion.run(.sequence([.wait(forDuration: 3), .removeFromParent()]))
                }
                enemy.removeFromParent()
            }
            
            if let explosion = SKEmitterNode(fileNamed: "Explosion") {
                explosion.position = enemy.position
                addChild(explosion)
                
                explosion.run(.sequence([.wait(forDuration: 3), .removeFromParent()]))
            }
            
            secondNode.removeFromParent()
        } else {
            if let explosion = SKEmitterNode(fileNamed: "Explosion") {
                explosion.position = secondNode.position
                addChild(explosion)
                
                explosion.run(.sequence([.wait(forDuration: 3), .removeFromParent()]))
            }
            firstNode.removeFromParent()
            secondNode.removeFromParent()
        }

    }
    
    func gameOver() {
        isPlayerAlive = false
        if let explosion = SKEmitterNode(fileNamed: "Explosion") {
            explosion.position = player.position
            addChild(explosion)
            
            explosion.run(.sequence([.wait(forDuration: 3), .removeFromParent()]))
        }
        let gameOver = SKSpriteNode(imageNamed: "gameOver")
        addChild(gameOver)
    }

}
