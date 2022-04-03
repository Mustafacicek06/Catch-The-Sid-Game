//
//  ViewController.swift
//  CatchTheSidGame
//
//  Created by Mustafa Çiçek on 3.04.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var currentScoreLabel: UILabel!
    
    @IBOutlet weak var highScoreLabel: UILabel!
    
    @IBOutlet weak var sidImage: UIImageView!
    
    // variables
    var timer = Timer()
    var score : Int32 = 0
    var highScore : Int32 = 0
    let imageViewWidth = CGFloat(125)
    let imageViewHeight = CGFloat(125)
    var countTimer = 0
    
    // constants
    var gameOverAlertTitle : String = "Time's Up"
    var gameOverAlertMessage : String = "Do you want to play again?"
    var gameOverAlertOk : String = "OK"
    var gameOverAlertReplay : String = "Replay"
    
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // high score check
        let storedHighScore = UserDefaults.standard.object(forKey: "highScore")
        
        if storedHighScore == nil{
            highScore = 0
            highScoreLabel.text = "High Score : \(highScore)"
        }
        
        if let newScore = storedHighScore as? Int32{
            highScore = newScore
            highScoreLabel.text = "High Score : \(highScore)"
        }
        
        // uzerine tiklamasini saglar
        sidImage.isUserInteractionEnabled = true
        countTimer = 10
        timeLabel.text = "\(countTimer)"
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(counterFunction), userInfo: nil, repeats: true)
        
        addTapRecognizerToImageView()
    }
    
    func addTapRecognizerToImageView() {
            let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
            sidImage.addGestureRecognizer(tap)
            sidImage.isUserInteractionEnabled = true
        
        }
    
    @objc func handleTap() {
            let maxX = view.frame.maxX-imageViewWidth
            let maxY = view.frame.maxY-imageViewHeight
            let randomX = arc4random_uniform(UInt32(maxX)) + 0
            let randomY = arc4random_uniform(UInt32(maxY)) + 0
        UIView.animate(withDuration: 0.01) {
                self.sidImage.frame = CGRect(
                    x: CGFloat(randomX),
                    y: CGFloat(randomY),
                    width: self.imageViewWidth,
                    height: self.imageViewHeight
                )
            }
        // increase current Score
            increaseScore()
        }
    @objc func increaseScore(){
        score += 1
        currentScoreLabel.text = "Score : \(score)"
    }
    
    @objc func counterFunction(){
        timeLabel.text = "\(countTimer)"
        countTimer -= 1
        
        if countTimer == -1 {
            if self.score > self.highScore{
                self.highScore = self.score
                highScoreLabel.text = "High Score : \(highScore)"
                UserDefaults.standard.set(self.highScore, forKey: "highScore")
            }
            
            createAlert()
            timer.invalidate()
            
            sidImage.isUserInteractionEnabled = false
            
            
           
        }
        
    }
    func createAlert(){
        let alert = UIAlertController(title: gameOverAlertTitle, message: gameOverAlertMessage, preferredStyle: UIAlertController.Style.alert)
        
        let okButton = UIAlertAction(title: gameOverAlertOk, style: UIAlertAction.Style.default) { UIAlertAction in
            print("okButton clicked")
        }
        
        let replayButton = UIAlertAction(title: gameOverAlertReplay, style: UIAlertAction.Style.default) { [self] UIAlertAction in
            sidImage.isUserInteractionEnabled = true
            self.score = 0
            self.currentScoreLabel.text = "Score : \(self.score)"
            self.countTimer = 10
            self.timeLabel.text = String(countTimer)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(counterFunction), userInfo: nil, repeats: true)
        }
        
        alert.addAction(okButton)
        alert.addAction(replayButton)
        self.present(alert, animated: true)
    }

}

