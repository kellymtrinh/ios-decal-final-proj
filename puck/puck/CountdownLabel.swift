//
//  CountdownLabel.swift
//  puck
//
//  Followed tutorial: http://tutorials.tinyappco.com/SwiftGames/Timer
//

import SpriteKit

class CountdownLabel: SKLabelNode {
    var endTime:NSDate!
    
    func update() {
        let timeLeftInteger = Int(timeLeft())
        text = String(timeLeftInteger)
        
    }
    
    func startWithDuration(duration: TimeInterval) {
        let timeNow = NSDate()
        endTime = timeNow.addingTimeInterval(duration)
        
    }
    
    private func timeLeft() -> TimeInterval {
        let now = NSDate()
        let remainingSeconds = endTime.timeIntervalSince(now as Date)
        return max(remainingSeconds, 0)
    }
    
    func hasFinished() -> Bool {
        return timeLeft() == 0
    }
    
    func reset(duration: TimeInterval) {
        startWithDuration(duration: duration)
    }
}
