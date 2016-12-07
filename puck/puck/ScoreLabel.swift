//
//  CountdownLabel.swift
//
//

import SpriteKit

class ScoreLabel: SKLabelNode {
    var score = 0
    
    func update() {
        text = "Score: " + String(score)
        
    }
    
    func addPoint(value: Int) {
        score += value
    }
    
    func reset(duration: TimeInterval) {
        score = 0
    }
    
    func getScore() -> Int {
        return score
    }
}
