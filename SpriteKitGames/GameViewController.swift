    //
    //  GameViewController.swift
    //  EndlessRunner
    //
    //  Created by Ashraful Islam on 3/15/25.
    //

import UIKit
import SpriteKit
import GameplayKit

enum GameSceneType {
    case spaceShooter
    case explodingMonkey
}

class GameViewController: UIViewController {
    let sceneType = GameSceneType.explodingMonkey
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let view = self.view as! SKView? {
            let scene: SKScene
            switch sceneType {
            case .spaceShooter:
                scene = SpaceShooterGameScene(size: CGSize(width: 1560, height: 720))
            case .explodingMonkey:
                scene = ExplodingMonkeyGameScene(size: CGSize(width: 1560, height: 720))
            }
            
            scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            scene.scaleMode = .aspectFit
            view.presentScene(scene)
            
            view.ignoresSiblingOrder = true
            view.showsPhysics = true
            view.showsDrawCount = true
            view.showsFPS = true
            view.showsNodeCount = true
        }
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
}
