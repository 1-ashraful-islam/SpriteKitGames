//
//  EnemyNode.swift
//  EndlessRunner
//
//  Created by Ashraful Islam on 3/16/25.
//

import SpriteKit

class EnemyNode: SKSpriteNode {
    var type: EnemyType
    var lastFireTime: Double = 0
    var shields: Int
    
    init(type: EnemyType, startPosition: CGPoint, xOffset: CGFloat, moveStraight: Bool) {
        self.type = type
        shields = type.shields
        let texture = SKTexture(imageNamed: type.name)
        super.init(texture: texture, color: .white, size: texture.size())
        
        physicsBody = SKPhysicsBody(texture: texture, size: texture.size())
        physicsBody?.categoryBitMask = spaceCollisionType.enemy.rawValue
        physicsBody?.collisionBitMask = spaceCollisionType.player.rawValue | spaceCollisionType.playerWeapon.rawValue
        physicsBody?.contactTestBitMask = spaceCollisionType.player.rawValue | spaceCollisionType.playerWeapon.rawValue
        
        name = "enemy"
        position = CGPoint(x: startPosition.x + xOffset, y: startPosition.y)
        
        configureMovement(moveStraight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureMovement(_ moveStraight: Bool) {
        let path = UIBezierPath()
        path.move(to: .zero)
        
        if moveStraight {
            path.addLine(to: CGPoint(x: -10000, y: 0))
        } else {
            path.addCurve(to: CGPoint(x: -3500, y: 0), controlPoint1: CGPoint(x: 0, y: -position.y * 4), controlPoint2: CGPoint(x: -1000, y: -position.y))
        }
        
        let movement = SKAction.follow(path.cgPath, asOffset: true, orientToPath: true, speed: type.speed)
        let sequence = SKAction.sequence([movement, .removeFromParent()])
        run(sequence)

    }
    
    func fire() {
        let weaponType = "\(type.name)Weapon"
        
        let weapon = SKSpriteNode(imageNamed: weaponType)
        weapon.name = "enemyWeapon"
        weapon.position = position
        weapon.zRotation = zRotation
        parent?.addChild(weapon)
        
        weapon.physicsBody = SKPhysicsBody(rectangleOf: weapon.size)
        weapon.physicsBody?.categoryBitMask = spaceCollisionType.enemyWeapon.rawValue
        weapon.physicsBody?.collisionBitMask = spaceCollisionType.player.rawValue
        weapon.physicsBody?.contactTestBitMask = spaceCollisionType.player.rawValue
        weapon.physicsBody?.mass = 0.001
        
        let speed: CGFloat = 1
        let adjustedRotation = zRotation + (CGFloat.pi / 2)
        
        let dx = speed * cos(adjustedRotation)
        let dy = speed * sin(adjustedRotation)
        
        weapon.physicsBody?.applyImpulse(CGVector(dx: dx, dy: dy))
        
    }
}
