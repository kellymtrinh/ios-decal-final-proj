//
//  GameOverScene.swift
//  puck
//
//  Created by Yitian Zou on 12/7/16.
//  Copyright © 2016 KELLYTRINH. All rights reserved.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    var button: SKNode! = nil
    
    override func didMove(to view: SKView) {
        button = SKSpriteNode(color: SKColor.white, size: CGSize(width: 100, height: 44))
        button.position = CGPoint(x:self.frame.width/2, y:self.frame.height*0.4);
        self.addChild(button)
        
        let label = SKLabelNode(text: "Play again")
        label.position = CGPoint(x: self.frame.width/2, y:self.frame.height*0.39)
        label.fontSize = 28
        label.fontColor = UIColor.black
        addChild(label)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Loop over all the touches in this event
        for touch: AnyObject in touches {
            // Get the location of the touch in this scene
            let location = touch.location(in: self)
            // Check if the location of the touch is within the button's bounds
            if button.contains(location) {
               
                let scene = GameScene(size: self.size)
                self.view?.presentScene(scene)
            }
        }
    }

    init(size: CGSize, score: Int) {
        super.init(size: size)
        
        backgroundColor = SKColor.white
        
        let yourScore = SKLabelNode(text: "Your score: ")
        yourScore.position = CGPoint(x: self.frame.width/2, y: self.frame.height*0.8)
        yourScore.fontSize = 40
        yourScore.fontColor = UIColor.black
        addChild(yourScore)
        
        let label = SKLabelNode(text: String(score))
        label.position = CGPoint(x: self.frame.width/2, y: self.frame.height/2)
        label.fontSize = 50
        label.fontColor = UIColor.black
        addChild(label)
        
       
        let userDefaults = UserDefaults.standard //returns shared defaults object.
        
        if let highScore = userDefaults.value(forKey: "highScore") as? Int{ //Returns the integer value associated with the specified key.
            //do something here when a highscore exists
            if (highScore < score) {
                userDefaults.set(score, forKey: "highScore") //if this score is higher, set it
            }
            print(highScore)
        } else {
            //no highscore exists
            userDefaults.set(score, forKey: "highScore") //if no highscore exists, set it
            print("setting high score")
            print(score)
        }
        

     
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}