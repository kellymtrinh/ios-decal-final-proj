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
    
    var viewController: UIViewController?
    var button: SKNode! = nil
    var main: SKNode! = nil
    
    override func didMove(to view: SKView) {
        
        
        button = SKSpriteNode(color: SKColor.white, size: CGSize(width: 100, height: 44))
        button.name = "button"
        button.position = CGPoint(x:self.frame.width/2, y:self.frame.height*0.4);
        self.addChild(button)
        
        main = SKSpriteNode(color: SKColor.white, size: CGSize(width:120, height:44))
        main.name = "main"
        main.position = CGPoint(x: self.frame.width/2, y: self.frame.height*0.25)
        self.addChild(main)
        
        let label = SKLabelNode(text: "Play again")
        label.position = CGPoint(x: self.frame.width/2, y:self.frame.height*0.39)
        label.fontSize = 28
        label.fontColor = UIColor.black
        addChild(label)
        
        let menu = SKLabelNode(text: "Main menu")
        menu.position = CGPoint(x: self.frame.width/2, y:self.frame.height*0.24)
        menu.fontSize = 28
        menu.fontColor = UIColor.black
        addChild(menu)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        // Loop over all the touches in this event
        for touch: AnyObject in touches {
            // Get the location of the touch in this scene
            let location = touch.location(in: self)
            // Check if the location of the touch is within the button's bounds
            if main.contains(location) {
                let titleViewController = TitleViewController()
                viewController?.present(titleViewController, animated: true, completion: nil)
            } else if button.contains(location) {
                let gameViewController = GameViewController()
                viewController?.present(gameViewController, animated: true, completion: nil)
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
