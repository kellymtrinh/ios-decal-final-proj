# Puck!
### Authors
* Kelly Trinh, Yitian Zou, Yaqi Miao

### Purpose
* A fun stress relieving game similar to darts. Aim for the fast-moving targets and hit as many as you can before the time is up. 


### Features
* User can score points when they hit the target. Smaller targets are worth more points than larger targets.
* As the user hits the target, the game gets progressively more challenging.
* The target gets smaller and/or further away/move around. 
* The user has less time to hit the target. 

###Control Flow
* User can start a new game.
* User plays game until the timer ends.
* After a game ends, they can see their current score, compared to their highest score. If this is their new high score, the app will announce it.  

###Implementation

#### Model
* PuckGame.swift
    * Handles the logic for calculating score
* BubbleGame.swift
* Game 1 (PuckGame) Also Has These Classes:
    * Timer.swift
    * Score.swift
    * Target.swift
    * Board.swift
    * Obstacle.swift
    * Puck.swift
    * GenerateLevel.swift
* Game 2 (BubbleGame) Also Has These Classes:
    * Timer.swift
    * Score
    * Board
    * Bubble
        * Poison Bubble (subclass)
        
#### View
* SelectGameUIView
* StartGameUIVIew
* PuckGameUIView
* BubbleGameUIView
* ScoreUIView

#### Controller
* SelectGameUIViewController
* StartGameUIVIewController
* PuckGameUIViewController
* BubbleGameUIViewController
* ScoreUIViewController

