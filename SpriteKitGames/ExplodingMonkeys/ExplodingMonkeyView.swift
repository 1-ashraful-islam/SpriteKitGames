//
//  ExplodingMonkeyView.swift
//  SpriteKitGames
//
//  Created by Ashraful Islam on 3/23/25.
//


import SpriteKit
import GameplayKit
import SwiftUI

enum monkeyPlayer: Int {
    case player1 = 1
    case player2 = 2
}

struct ExplodingMonkeyView: View {
    @State private var angle: Double = 45
    @State private var velocity: Double = 100
    let scene: ExplodingMonkeyGameScene
    let debugOptions: SpriteView.DebugOptions
    let showDebug: Bool
    @State var isPlayerDisabled = false
    @State var activePlayer = monkeyPlayer.player1
    
    init(showDebug: Bool = false) {
        scene = ExplodingMonkeyGameScene(size: CGSize(width: 1560, height: 720))
        scene.scaleMode = .aspectFit
        self.showDebug = showDebug
        debugOptions  = showDebug ? [.showsPhysics, .showsDrawCount, .showsFPS, .showsNodeCount] : []
    }
    
    var body: some View {
        ZStack(alignment: .top) {
            SpriteView(scene: scene, debugOptions: debugOptions)
                .ignoresSafeArea()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear {
                    scene.isPlayerDisabled = $isPlayerDisabled
                    scene.activePlayer = $activePlayer
                }
            if !isPlayerDisabled {
                VStack {
                    HStack {
                        Text("Angle: \(Int(angle))°")
                        Slider(value: $angle, in: 0...90)
                        
                        Text("Velocity: \(Int(velocity))")
                        Slider(value: $velocity, in: 0...200)
                        
                        Button("Launch") {
                            scene.launch(angle: Int(angle), velocity: Int(velocity))
                        }
                        .buttonStyle(.borderedProminent)
                    }
                    HStack {
                        Spacer()
                        Text(activePlayer == monkeyPlayer.player1 ? "<<<< PLAYER1" : "PLAYER2 >>>>")
                            .font(.subheadline)
                        Spacer()
                    }
                    Spacer()
                }
                .foregroundColor(.white)
                .padding()
                
            }
        }
    }
}
