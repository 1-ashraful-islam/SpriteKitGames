//
//  SpaceShooterView.swift
//  SpriteKitGames
//
//  Created by Ashraful Islam on 3/23/25.
//


import SpriteKit
import GameplayKit
import SwiftUI

struct SpaceShooterView: View {
    let scene: SpaceShooterGameScene
    let debugOptions: SpriteView.DebugOptions
    let showDebug: Bool
    
    init(showDebug: Bool = false) {
        scene = SpaceShooterGameScene(size: CGSize(width: 1560, height: 720))
        scene.scaleMode = .aspectFit
        scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        self.showDebug = showDebug
        debugOptions  = showDebug ? [.showsPhysics, .showsDrawCount, .showsFPS, .showsNodeCount] : []
    }
    
    var body: some View {
        VStack {
            SpriteView(scene: scene, debugOptions: debugOptions)
                .ignoresSafeArea()
        }
    }
}
