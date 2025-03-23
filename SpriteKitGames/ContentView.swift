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
    @State private var sceneType = GameSceneType.explodingMonkey
    
    var body: some View {
        VStack {
            Picker("Game", selection: $sceneType) {
                Text("Shooter").tag(GameSceneType.spaceShooter)
                Text("Monkey").tag(GameSceneType.explodingMonkey)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(.horizontal)
            
            switch sceneType {
            case .spaceShooter:
                SpaceShooterView()
            case .explodingMonkey:
                ExplodingMonkeyView()
            }
        }
    }
}
