//
//  GameViewController.swift
//  puck
//
//  Created by KELLYTRINH on 12/3/16.
//  Copyright © 2016 KELLYTRINH. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

protocol GameSceneDelegate {
    func returnToTitle()
}

class GameViewController: UIViewController, GameSceneDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene(size: view.bounds.size)
        let skView = SKView()
        self.view = skView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .aspectFill
        scene.titleVCDelegate = self
        
        skView.presentScene(scene)
    }

    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    func returnToTitle() {
        self.present(TitleViewController(), animated: false, completion: nil)
    }
}
