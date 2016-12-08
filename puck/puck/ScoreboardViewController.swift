//
//  ScoreboardViewController.swift
//  puck
//
//  Created by Yaqi Miao on 2016/12/03.
//  Copyright © 2016 KELLYTRINH. All rights reserved.
//

import UIKit

class ScoreboardViewController: UIViewController {
    
    let backButton = UIButton(type: UIButtonType.custom)
    let scoreTitle = UILabel()




    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreTitle.translatesAutoresizingMaskIntoConstraints = false
        scoreTitle.font = UIFont.boldSystemFont(ofSize: 36.0)
        scoreTitle.textColor = UIColor.black
        
        let userDefaults = UserDefaults.standard //returns shared defaults object.

        if let highScore = userDefaults.value(forKey: "highScore") as? Int{ //Returns the integer value associated with the specified key.
            //do something here when a highscore exists
            scoreTitle.text = "Your High Score: " + String(highScore)
            print(highScore)
        } else {
            //no highscore exists
            scoreTitle.text = "No High Scores Yet"
            print("No Scores Yet")
        }
        view.addSubview(scoreTitle)
        // "New Game" Button


        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor(red:0.93, green:0.93, blue:0.93, alpha:1.0)
        backButton.translatesAutoresizingMaskIntoConstraints = false
        // Return Button
        backButton.setTitle("Return to Title", for: .normal)
        backButton.setTitleColor(UIColor.black, for: .normal)
        backButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
        view.addSubview(backButton)
        
        
        view.setNeedsUpdateConstraints()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Setup view constraints
    override func updateViewConstraints() {
        super.updateViewConstraints()
        NSLayoutConstraint(item: backButton, attribute: .left, relatedBy: .equal, toItem: view, attribute: .right, multiplier: 0.1, constant: 0.0).isActive = true
        NSLayoutConstraint(item: backButton, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 0.1, constant: 0.0).isActive = true
        
        NSLayoutConstraint(item: scoreTitle, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1.0, constant: 0.0).isActive = true
        NSLayoutConstraint(item: scoreTitle, attribute: .top, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 0.2, constant: 0.0).isActive = true

        }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
    func backButtonTapped(sender: UIButton) {
        self.present(TitleViewController(), animated: true, completion: nil)
    }

}
