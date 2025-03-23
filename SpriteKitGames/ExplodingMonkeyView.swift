import SpriteKit
import GameplayKit
import SwiftUI

struct ExplodingMonkeyView: View {
    @State private var angle: Double = 45
    @State private var velocity: Double = 100
    let scene: ExplodingMonkeyGameScene
    let debugOptions: SpriteView.DebugOptions
    let showDebug: Bool
    
    init(showDebug: Bool = false) {
        scene = ExplodingMonkeyGameScene(size: CGSize(width: 1560, height: 720))
        scene.scaleMode = .aspectFit
        self.showDebug = showDebug
        debugOptions  = showDebug ? [.showsPhysics, .showsDrawCount, .showsFPS, .showsNodeCount] : []
    }
    
    var body: some View {
        VStack {
            SpriteView(scene: scene, debugOptions: debugOptions)
                .ignoresSafeArea()
            
            VStack {
                Text("Angle: \(Int(angle))°")
                Slider(value: $angle, in: 0...90)
                
                Text("Velocity: \(Int(velocity))")
                Slider(value: $velocity, in: 0...200)
                
                Button("Launch") {
//                    scene.launchMonkey(angle: angle, velocity: velocity)
                }
            }
            .padding()
        }
    }
}