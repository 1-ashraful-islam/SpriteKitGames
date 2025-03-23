    //
    //  ContentView.swift
    //  SpriteKitGames
    //
    //  Created by Ashraful Islam on 3/15/25.
    //

import SpriteKit
import GameplayKit
import SwiftUI

enum GameSceneType {
    case spaceShooter
    case explodingMonkey
}

struct ContentView: View {
    let sceneType = GameSceneType.explodingMonkey
    var scene: SKScene
    var debugOptions: SpriteView.DebugOptions
    let debug = true
    
    init() {
        
        switch sceneType {
        case .spaceShooter:
            scene = SpaceShooterGameScene(size: CGSize(width: 1560, height: 720))
        case .explodingMonkey:
            scene = ExplodingMonkeyGameScene(size: CGSize(width: 1560, height: 720))
        }
        scene.scaleMode = .aspectFit
        debugOptions  = debug ? [.showsPhysics, .showsDrawCount, .showsFPS, .showsNodeCount] : []
    }
    
    var body: some View {
        SpriteView(scene: scene, debugOptions: debugOptions)
            .frame(width: 1560, height: 720)
            .ignoresSafeArea()
    }
}
