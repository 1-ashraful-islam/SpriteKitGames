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
    
    override func didMove(to view: SKView) {
        backgroundColor = UIColor(hue: 0.669, saturation: 0.99, brightness: 0.67, alpha: 1)
        createBuildings()
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
    
    func launch(angle: Int, velocity: Int) {
        isPlayerDisabled?.wrappedValue = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.isPlayerDisabled?.wrappedValue = false
            self.activePlayer?.wrappedValue = self.activePlayer?.wrappedValue == .player1 ? .player2 : .player1
        }
    }

}
