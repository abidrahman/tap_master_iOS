//
//  ActiveGameState.swift
//  Tap Master
//
//  Created by Abid Rahman on 2017-09-11.
//  Copyright © 2017 Abid Rahman. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import GameplayKit
import GoogleMobileAds
import Firebase

class ActiveGameState: GameSceneState {
    
    var scene: GameScene?
    var circles : [Circle] = [Circle]()
    var gameStarted = false
    
    let scoreText = SKLabelNode(fontNamed: "Indie Flower")
    let startGame = SKLabelNode(fontNamed: "Indie Flower")

    init(scene: GameScene){
        self.scene = scene
        super.init()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == GameOverState.self
    }
    
    override func didEnter(from previousState: GKState?) {
        
        //Must tap to begin
        gameStarted = false
        
        //Analytics
        Analytics.logEvent(AnalyticsEventViewItem, parameters: [AnalyticsParameterItemID : "Active Game Screen" as NSObject])
        
        //Numplayed
        let numPlayed = UserDefaults.standard.value(forKey: "numPlayed") as? Int
        if numPlayed != nil {
            if (3 == numPlayed!) {
                UserDefaults.standard.set(0, forKey: "numPlayed")
                //Load Ad
                self.scene?.interstitialAd = GADInterstitial(adUnitID: "ca-app-pub-3441960749414963/7715137175")
                let request = GADRequest()
                self.scene?.interstitialAd.load(request)
                
            } else {
                UserDefaults.standard.set(numPlayed! + 1, forKey: "numPlayed")
            }
        } else {
            UserDefaults.standard.set(1, forKey: "numPlayed")
        }

        self.scene?.numPlayed += 1
        //If 5th time, load Ad
        if 5 == self.scene?.numPlayed {
            
        }
        
        //Background
        self.scene?.backgroundColor = SKColor.black
        
        //Score
        self.scene?.score = 0
        scoreText.text = String(describing: self.scene?.score ?? 0)
        scoreText.fontSize = 50
        scoreText.color = SKColor.white
        scoreText.position = CGPoint(x: (self.scene?.size.width)! * 0.5, y: (self.scene?.size.height)! * 0.92)
        scoreText.isHidden = true
        
        //Circles
        circles = [Circle]()
        for i in 0..<Circle.NUMBER_OF_CIRCLES {
            let circle = Circle()
            circle.position = CGPoint(x: (Circle.diameter)*CGFloat(i+1) - Circle.diameter/2, y: (self.scene?.size.height)! - Circle.diameter/2)
            circles.append(circle)
        }
        
        //Tap to begin
        startGame.text = "Tap To Begin!"
        startGame.fontSize = 50
        startGame.fontColor = SKColor.white
        startGame.position = CGPoint(x: (self.scene?.size.width)! * 0.5, y: (self.scene?.size.height)! * 0.5)
        startGame.isHidden = false
        
        let circleAnimate = SKAction.fadeIn(withDuration: 1)
        
        self.scene?.addChild(scoreText)
        self.scene?.addChild(startGame)
        for circle in circles {
            self.scene?.addChild(circle)
            circle.alpha = 0.0
            circle.run(circleAnimate)
        }
    }
    
    override func willExit(to nextState: GKState) {
        self.scene?.removeAllChildren()
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        if (gameStarted) {
            self.checkCircleBottom()
            scoreText.text = String(describing: self.scene?.score ?? 0)
            for circle in circles {
                circle.update()
                circle.position = CGPoint(x: circle.position.x, y: circle.position.y - 1)
            }
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
        for touch in touches {
            if (gameStarted) {
                let positionTouched = touch.location(in: (self.scene)!)
                
                for circle in circles {
                    if(positionTouched.x < circle.position.x + Circle.diameter/2
                        && positionTouched.x > circle.position.x - Circle.diameter/2
                        && positionTouched.y > circle.position.y - Circle.diameter/2 - touchSpace()
                        && positionTouched.y < circle.position.y + Circle.diameter/2 + touchSpace()) {
                        
                        if (UIColor.green == circle.color) {
                            circle.isHidden = true
                            self.scene?.score += 1
                        } else if (UIColor.red == circle.color) {
                            gameOver()
                        }

                    }
                }
            } else {
                startGame.isHidden = true
                scoreText.isHidden = false
                gameStarted = true
            }
        }
    }
    
    func checkCircleBottom() {
        for circle in circles {
            if (circle.position.y <= -Circle.diameter/2) {
                if ((UIColor.green == circle.color) && (!circle.isHidden)) {
                    gameOver()
                } else {
                    circle.reposition(score: (self.scene?.score)!)
                }
            }
        }
    }
    
    func touchSpace() -> CGFloat {
        if ((self.scene?.score)! >= 35) { return CGFloat((self.scene?.score)! - 35) }
        else if ((self.scene?.score)! > 75) { return 40 }
        else { return 0 }
    }
    
    func gameOver() {
        self.stateMachine?.enter(GameOverState.self)
    }
}
