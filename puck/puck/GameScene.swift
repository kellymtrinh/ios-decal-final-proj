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
    var numTargetsLeft = 0
    let timer = CountdownLabel()
    var timeOver = false
    var score = ScoreLabel()
    var titleVCDelegate: GameSceneDelegate?
    
    
    override func didMove(to view: SKView) {
        /* Setup your scene here */
        self.backgroundColor = UIColor.black
        
        timer.position = CGPoint(x: 128, y: size.height - 64)
        timer.fontSize = 40
        timer.fontColor = UIColor.white
        addChild(timer)
        // number of seconds to countdown
        timer.startWithDuration(duration: 30)
        
        score.position = CGPoint(x: self.frame.width/4 * 3, y: size.height - 64)
        score.fontSize = 30
        score.fontColor = UIColor.white
        addChild(score)
        
        
        ball = SKShapeNode(circleOfRadius: 16)
        ball.position = CGPoint(x: self.frame.width/2, y: self.frame.height*0.10)
        ball.fillColor = UIColor.white
        self.addChild(ball)
 
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
        target.fillColor = UIColor.white
        
        target.physicsBody = SKPhysicsBody(circleOfRadius: radius)
        target.physicsBody?.isDynamic = true
        target.physicsBody?.categoryBitMask = PhysicsCategory.Target
        target.physicsBody?.contactTestBitMask = PhysicsCategory.Projectile | PhysicsCategory.Wall //notify contact listener when intersect with projectiles
        target.physicsBody?.collisionBitMask = PhysicsCategory.Wall //bouncing
        
        self.addChild(target)
        numTargetsLeft += 1
        

        
        self.addChild(pauseButtonNode())
        
        target.physicsBody?.restitution = 1.0
        target.physicsBody?.friction = 0.0
        target.physicsBody?.linearDamping = 0.0
        let randomX = random(min: 3.0, max: 20.0)
        let randomY = random(min: 3.0, max: 20.0)
        target.physicsBody?.applyImpulse(CGVector(dx: randomX, dy: randomY))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        var touch = touches.first
        var location = touch!.location(in: self)
        var node = self.nodes(at: location).first
        
        if (node != nil && node!.name == "pauseButtonNode") {
            let pauseNode = node as! SKSpriteNode
            if self.view?.isPaused == false {
                changePauseImage(pauseNode, state: false)
                self.view?.isPaused = true
            } else {
                self.view?.isPaused = false
                changePauseImage(pauseNode, state: true)
            }
        }
    }
    
    func changePauseImage(_ node: SKSpriteNode, state pause: Bool) {
        var action: SKAction
        if pause {
            action = SKAction.setTexture(SKTexture(imageNamed: "pause"))
        } else {
            action = SKAction.setTexture(SKTexture(imageNamed: "play"))
        }
        node.run(action)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
      
        if !timeOver {
        // 1 - Choose one of the touches to work with
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: self)
        
        // 2 - Set up initial location of projectile
        
        let projectile = SKSpriteNode(imageNamed: "projectile")   //(circleOfRadius: 10)
//        projectile.fillColor = UIColor.white
        projectile.position = CGPoint(x: self.frame.width/2, y: self.frame.height*0.10)
        
        projectile.physicsBody = SKPhysicsBody(circleOfRadius: 16)
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
    

    func projectileDidCollideWithTarget(projectile: SKSpriteNode, target: SKShapeNode) {
        
        projectile.removeFromParent()
        target.removeFromParent()
        score.addPoint(value: 1)
        self.run(SKAction.playSoundFileNamed("hit", waitForCompletion: false))
        self.run(SKAction.wait(forDuration: 1))
        numTargetsLeft -= 1
        

        if (numTargetsLeft < 1) {
            var radius = Int(arc4random_uniform(50) + 10)
            addTarget(radius: CGFloat(radius))
            radius = Int(arc4random_uniform(50) + 10)
            addTarget(radius: CGFloat(radius))
            radius = Int(arc4random_uniform(50) + 10)
            addTarget(radius: CGFloat(radius))
        }
        
        
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
        
        if firstBody.node == nil || secondBody.node == nil {
            return
        }
        
        // projectile hits target
        if ((firstBody.categoryBitMask & PhysicsCategory.Target != 0) &&
            (secondBody.categoryBitMask & PhysicsCategory.Projectile != 0)) {
            projectileDidCollideWithTarget(projectile: secondBody.node as! SKSpriteNode, target: firstBody.node as! SKShapeNode)
//            let firstNode = firstBody as! SKSpriteNode
//            let secondNode = secondBody as! SKSpriteNode
//            if (firstNode.name != "pauseButtonNode" && secondNode.name != "pauseButtonNode") {
//                projectileDidCollideWithTarget(projectile: firstBody.node as! SKShapeNode, target: secondBody.node as! SKShapeNode)
//            }
        }
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        timer.update()
        score.update()
        if (timer.hasFinished()) {
            timeOver = true
            //resetGame()
            let gameOverScene = GameOverScene(size: self.size, score: score.getScore())
            gameOverScene.titleVCDelegate = titleVCDelegate
            self.view?.presentScene(gameOverScene)
        }
        
    }
    
    private func resetGame() {
        
        timer.reset(duration: 50)
        
    }
    
    func pauseButtonNode() -> SKSpriteNode {
        let pauseButton = SKSpriteNode(imageNamed: "pause")
        pauseButton.position = CGPoint(x:64, y:size.height - 64)
        pauseButton.name = "pauseButtonNode"
        pauseButton.zPosition = 1.0
        return pauseButton;
    }

}
