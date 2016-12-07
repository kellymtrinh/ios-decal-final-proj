//
//  TitleViewController.swift
//  puck
//
//  Created by Yaqi Miao on 2016/12/03.
//  Copyright © 2016 KELLYTRINH. All rights reserved.
//

import UIKit

class TitleViewController: UIViewController {
    
    let gameTitle = UILabel()
    let startButton = UIButton(type: UIButtonType.roundedRect)
    let scoreboardButton = UIButton(type: UIButtonType.roundedRect)

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        gameTitle.translatesAutoresizingMaskIntoConstraints = false
        startButton.translatesAutoresizingMaskIntoConstraints = false
        scoreboardButton.translatesAutoresizingMaskIntoConstraints = false
        // Game Title
        gameTitle.text = "Puk!"
        gameTitle.font = UIFont.boldSystemFont(ofSize: 36.0)
        gameTitle.textColor = UIColor.white
        view.addSubview(gameTitle)
        // "New Game" Button
        startButton.setTitle("New Game", for: .normal)
        // "Scoreboard" Button
        scoreboardButton.setTitle("Scoreboard", for: .normal)
        for button in [startButton, scoreboardButton] {
            button.setTitleColor(UIColor.white, for: .normal)
            button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
            button.backgroundColor = UIColor(red:0.60, green:0.60, blue:0.60, alpha:1.0)
            button.layer.cornerRadius = 6
            button.clipsToBounds = true
            button.contentEdgeInsets  = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10.0)
            view.addSubview(button)
        }
        view.setNeedsUpdateConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Setup view constraints
    override func updateViewConstraints() {
        super.updateViewConstraints()
        NSLayoutConstraint(item: gameTitle, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: gameTitle, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 0.2, constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: startButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: startButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 0.5, constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: scoreboardButton, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: scoreboardButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 0.65, constant: 0.0).isActive = true

    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    // Actions
    func buttonTapped(sender: UIButton) {
        switch sender.currentTitle ?? "" {
        case "New Game":
            let gameViewController = GameViewController()
            self.present(gameViewController, animated: false, completion: nil)
        case "Scoreboard":
            let scoreboardViewController = ScoreboardViewController()
            self.present(scoreboardViewController, animated: false, completion: nil)
        default:
            NSLog("Alert: Unkown button with title \(sender.currentTitle ?? "")")
        }
    }
}
