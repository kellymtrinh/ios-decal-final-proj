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


class GameScene: SKScene, SKPhysicsContactDelegate {
    
    struct PhysicsCategory {
        static let None      : UInt32 = 0
        static let Target   : UInt32 = 0b1       // 1
        static let Projectile: UInt32 = 0b10      // 2
        static let Wall: UInt32 = 0b100 // 4
    }
    
    var ball = SKShapeNode()
    var target = SKShapeNode()
    var numTargetsLeft = 3
    let timer = CountdownLabel()
    var timeOver = false
    var score = ScoreLabel()
    
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = UIColor.white
        
        timer.position = CGPoint(x: self.frame.width/4, y: self.frame.height*0.90)
        timer.fontSize = 40
        timer.fontColor = UIColor.black
        addChild(timer)
        // number of seconds to countdown
        timer.startWithDuration(duration: 10)
        
        score.position = CGPoint(x: self.frame.width/4 * 3, y: self.frame.height*0.90)
        score.fontSize = 30
        score.fontColor = UIColor.black
        addChild(score)
        
        
        ball = SKShapeNode(circleOfRadius: 25)
        ball.position = CGPoint(x: self.frame.width/2, y: self.frame.height*0.10)
        ball.fillColor = UIColor.blue
        self.addChild(ball)
        
        /* how to generate targets in random positions but not have them overlap? */
//        for _ in 1...3 {
//            let radius = Int(arc4random_uniform(50) + 10)
//            let x_scale = arc4random_uniform(10) / 10
//            let y_scale = (arc4random_uniform(9) + 1) / 10
//        
//            addTarget(radius: CGFloat(radius), x : UInt32(x_scale*UInt32(self.frame.width)),
//                    y: UInt32(y_scale * UInt32(self.frame.height)))
//            
//        }
        
        var radius = Int(arc4random_uniform(50) + 10)
        addTarget(radius: CGFloat(radius))
        
        radius = Int(arc4random_uniform(50) + 10)
        addTarget(radius: CGFloat(radius))
            
        radius = Int(arc4random_uniform(50) + 10)
        addTarget(radius: CGFloat(radius))
        
        physicsWorld.gravity = CGVector.zero
        physicsWorld.contactDelegate = self
        physicsBody = SKPhysicsBody(edgeLoopFrom : self.frame)
        physicsBody?.categoryBitMask = PhysicsCategory.Wall
        physicsBody?.collisionBitMask = PhysicsCategory.Target
        physicsBody?.contactTestBitMask = PhysicsCategory.Target
        physicsBody?.isDynamic = false
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat {
        return random() * (max - min) + min
    }
    
    private func addTarget(radius: CGFloat) {
        
        target = SKShapeNode(circleOfRadius: radius)
        let actualY = random(min: radius, max: size.height - radius)
        let actualX = random(min: radius, max: size.width - radius)
        target.position = CGPoint(x: actualX, y: actualY)
        target.fillColor = UIColor.red
        
        target.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        target.physicsBody?.isDynamic = true
        target.physicsBody?.categoryBitMask = PhysicsCategory.Target
        target.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile | PhysicsCategory.Wall //notify contact listener when intersect with projectiles
        target.physicsBody?.collisionBitMask = PhysicsCategory.Wall //bouncing
        
        self.addChild(target)
        
        //let actualDuration = random(min:CGFloat(2.0), max:CGFloat(4.0))
        
//        let actionMove = SKAction.move(to: CGPoint(x: -radius, y: actualY), duration:
//        TimeInterval(100.0))
//        target.run(SKAction.sequence([actionMove]))
        
        target.physicsBody?.restitution = 1.0
        target.physicsBody?.friction = 0.0
        target.physicsBody?.linearDamping = 0.0
        let randomX = random(min: 3.0, max: 20.0)
        let randomY = random(min: 3.0, max: 20.0)
        target.physicsBody?.applyImpulse(CGVector(dx: randomX, dy: randomY))
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      
        if !timeOver {
        // 1 - Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        
        // 2 - Set up initial location of projectile
        
        let projectile = SKShapeNode(circleOfRadius: 10)
        projectile.fillColor = UIColor.black
        projectile.position = CGPoint(x: self.frame.width/2, y: self.frame.height*0.10)
        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: 25)
        projectile.physicsBody?.isDynamic = true
        projectile.physicsBody?.categoryBitMask = PhysicsCategory.Projectile
        projectile.physicsBody?.contactTestBitMask = PhysicsCategory.Target
        projectile.physicsBody?.collisionBitMask = PhysicsCategory.None
        projectile.physicsBody?.usesPreciseCollisionDetection = true //for fast-moving objects
        // 3 - Determine offset of location to projectile
        let offset = touchLocation - projectile.position
        
        
        addChild(projectile)
        //set up 0-gravity physics world, sets scene as delegate to be notified when collision occurs
       
        
        // 6 - Get the direction of where to shoot
        let direction = offset.normalized()
        
        // 7 - Make it shoot far enough to be guaranteed off screen
        let shootAmount = direction * 1000
        
        // 8 - Add the shoot amount to the current position
        let realDest = shootAmount + projectile.position
        
        // 9 - Create the actions
        let actionMove = SKAction.move(to: realDest, duration: 1.3)
        let actionMoveDone = SKAction.removeFromParent()
        projectile.run(SKAction.sequence([actionMove, actionMoveDone]))
        
        
        }
        
    }
    
    func projectileDidCollideWithTarget(projectile: SKShapeNode, target: SKShapeNode) {
        print("Hit")
        projectile.removeFromParent()
        target.removeFromParent()
        score.addPoint(value: 1)
        numTargetsLeft -= 1
        let radius = Int(arc4random_uniform(50) + 10)
        addTarget(radius: CGFloat(radius))
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        // sorts the two bodies passed in
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        // projectile hits target
        if ((firstBody.categoryBitMask & PhysicsCategory.Target != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0)) {
            projectileDidCollideWithTarget(projectile: firstBody.node as! SKShapeNode, target: secondBody.node as! SKShapeNode)
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        timer.update()
        score.update()
        if (timer.hasFinished()) {
            timeOver = true
            //resetGame()
            let gameOverScene = GameOverScene(size: self.size, score: score.getScore())
            self.view?.presentScene(gameOverScene)
        }
        
    }
    
    private func resetGame() {
        
        timer.reset(duration: 50)
        
    }

}
