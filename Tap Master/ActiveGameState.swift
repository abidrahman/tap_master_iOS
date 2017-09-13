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
                if let touchedCircle = self.scene?.atPoint(positionTouched) as? Circle {
                    if (UIColor.green == touchedCircle.color) {
                        touchedCircle.isHidden = true;
                        self.scene?.score += 1
                        print(self.scene?.score ?? 0)
                    } else if (UIColor.red == touchedCircle.color) {
                        gameOver()
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
                if ((UIColor.green == circle.color) && (false == circle.isHidden)) {
                    gameOver()
                } else {
                    circle.reposition(score: (self.scene?.score)!)
                }
            }
        }
    }
    
    func gameOver() {
        self.stateMachine?.enter(GameOverState.self)
    }
}
