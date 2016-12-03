//
//  GameScene.swift
//  puck
//
//

import SpriteKit
import GameplayKit

func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}

func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}

func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}

func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}

#if !(arch(x86_64) || arch(arm64))
    func sqrt(a: CGFloat) -> CGFloat {
        return CGFloat(sqrtf(Float(a)))
    }
#endif

extension CGPoint {
    func length() -> CGFloat {
        return sqrt(x*x + y*y)
    }
    
    func normalized() -> CGPoint {
        return self / length()
    }
}


class GameScene: SKScene {
    
    private var label : SKLabelNode?
    private var spinnyNode : SKShapeNode?
    
   
    var ball = SKShapeNode()
    var target = SKShapeNode()

    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = UIColor.white
        ball = SKShapeNode(circleOfRadius: 25)
        ball.position = CGPoint(x: self.frame.width/2, y: self.frame.height - 50)
        ball.fillColor = UIColor.red
        self.addChild(ball)
        
        target = SKShapeNode(circleOfRadius: 25)
        target.position = CGPoint(x: self.frame.width/2, y: self.frame.height*0.10)
        target.fillColor = UIColor.blue
        
    
        self.addChild(target)
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        // 1 - Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        
        // 2 - Set up initial location of projectile
        
        let projectile = SKShapeNode(circleOfRadius: 10)
        projectile.fillColor = UIColor.black

        projectile.position = CGPoint(x: self.frame.width/2, y: self.frame.height - 50)
        
        // 3 - Determine offset of location to projectile
        let offset = touchLocation - projectile.position
        
        
        addChild(projectile)
        
        // 6 - Get the direction of where to shoot
        let direction = offset.normalized()
        
        // 7 - Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * 1000
        
        // 8 - Add the shoot amount to the current position
        let realDest = shootAmount + projectile.position
        
        // 9 - Create the actions
        let actionMove = SKAction.move(to: realDest, duration: 2.0)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
        
    }
    

}
