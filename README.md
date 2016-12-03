# Mini Games
### Authors
* Kelly Trinh, Yitian Zou, Yaqi Miao

### Purpose
* The user can choose one of two games to play.
* Puck Game
    * A fun stress relieving game similar to darts. Aim for the target while avoiding obstacles! 
* Bubble Ninja
Suppose you are in the deep sea. Collect the air bubbles to gain points and time. Score as much as you can in the time limit. Try to live longer and score higher and don’t touch the poisonous bubbles because they reduce your time left.

### Features
* Users can choose different games to play.
* Game 1 (Puck):
    * User can score points when they hit the target. Smaller targets are worth more points than larger targets.
    * As the user hits the target, the game gets progressively more challenging.
    * The target gets smaller and/or further away/move around. 
    * The user has less time to hit the target.
* Game 2 (Bubble):
    * Score point from slashing the bubbles (oxygen), but cutting the poison bubbles (carbon dioxide) takes away from the amount of time you have before the game ends. As the game progresses, the rate of objects coming up on the screen increases.  

###Control Flow
* User can choose which game they want to play.
* User can start a new game.
* If they choose Game 1 (Puck):
    * They are taken to a game screen where they can play a game of puck, which ends when the timer ends. 
* If they choose Game 2 (Bubble):
    * They are taken to a game screen where they can play a game of bubble ninja, which ends when the timer ends.
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

