//
//  GameOverState.swift
//  Tap Master
//
//  Created by Abid Rahman on 2017-09-11./Users/abidrahman/Projects/Tap_Master_iOS/Tap Master/Tap Master/ActiveGameState.swift
//  Copyright © 2017 Abid Rahman. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import GameplayKit

class GameOverState: GameSceneState{
    var parentViewController : UIViewController?
    var scene: GameScene?
    
    init(scene: GameScene){
        self.scene = scene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        self.scene?.backgroundColor = SKColor.black
        
        //Score animation
        let scoreText = SKLabelNode(fontNamed: "Indie Flower")
        scoreText.text = String(describing: self.scene?.score ?? 0)
        scoreText.fontSize = 200
        scoreText.color = SKColor.white
        scoreText.position = CGPoint(x: (self.scene?.size.width)! * 0.5, y: (self.scene?.size.height)! * 0.92)
        scoreText.xScale = 50/200
        scoreText.yScale = 50/200
        
        let scoreZoom = SKAction.scale(by: 4, duration: 0.50)
        let scoreMove = SKAction.moveBy(x: 0, y: -((self.scene?.size.height)! * 0.235), duration: 0.50)
        let scoreAnimate = SKAction.group([scoreZoom, scoreMove])
        
        //New HighScore Text
        let newHScore = SKLabelNode(fontNamed: "Indie Flower")
        newHScore.text = "New High Score!"
        newHScore.fontSize = 45
        newHScore.color = SKColor.white
        newHScore.position = CGPoint(x: (self.scene?.size.width)! * 0.5, y: (self.scene?.size.height)! * 0.92)
        
        //Check if new highscore
        var hScore = UserDefaults.standard.value(forKey: "Highscore") as? Int
        if hScore != nil {
            if (self.scene?.score)! > hScore! {
                UserDefaults.standard.set(self.scene?.score, forKey: "Highscore")
                self.scene?.addChild(newHScore)
                hScore = self.scene?.score
            }
        } else {
            hScore = self.scene?.score
            UserDefaults.standard.set(self.scene?.score, forKey: "Highscore")
            self.scene?.addChild(newHScore)
        }
        
        //HighScore
        let highScore = SKLabelNode(fontNamed: "Indie Flower")
        highScore.text = "High Score: " + String(describing: hScore ?? (self.scene?.score)!)
        highScore.fontSize = 30
        highScore.color = SKColor.white
        highScore.position = CGPoint(x: (self.scene?.size.width)! * 0.5, y: (self.scene?.size.height)! * 0.575)
        
        //GameOver
        let gameOver = SKLabelNode(fontNamed: "Indie Flower")
        gameOver.text = "Game Over"
        gameOver.fontSize = 60
        gameOver.color = SKColor.white
        gameOver.position = CGPoint(x: (self.scene?.size.width)! * 0.5, y: (self.scene?.size.height)! * 0.4625)
        
        //PlayAgain
        let playAgain = SKLabelNode(fontNamed: "Indie Flower")
        playAgain.text = "Play Again"
        playAgain.fontSize = 35
        playAgain.color = SKColor.white
        playAgain.position = CGPoint(x: (self.scene?.size.width)! * 0.5, y: (self.scene?.size.height)! * 0.335)
        
        //MainMenu
        let mainMenu = SKLabelNode(fontNamed: "Indie Flower")
        mainMenu.text = "Main Menu"
        mainMenu.fontSize = 35
        mainMenu.color = SKColor.white
        mainMenu.position = CGPoint(x: (self.scene?.size.width)! * 0.5, y: (self.scene?.size.height)! * 0.235)
        
        //Share
        let shareText = SKLabelNode(fontNamed: "Indie Flower")
        shareText.text = "Share"
        shareText.fontSize = 35
        shareText.color = SKColor.white
        shareText.position = CGPoint(x: (self.scene?.size.width)! * 0.5, y: (self.scene?.size.height)! * 0.135)
        
        self.scene?.addChild(shareText)
        self.scene?.addChild(mainMenu)
        self.scene?.addChild(highScore)
        self.scene?.addChild(gameOver)
        self.scene?.addChild(playAgain)
        self.scene?.addChild(scoreText)
        scoreText.run(scoreAnimate)
        
    }
    
    override func willExit(to nextState: GKState) {
        self.scene?.removeAllChildren()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return (stateClass == MainMenuState.self) || (stateClass == ActiveGameState.self) || (stateClass == HighScoreState.self)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        //todo
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
        for touch in touches {
            let positionTouched = touch.location(in: (self.scene)!)
            let touchedNode = self.scene?.atPoint(positionTouched) as? SKLabelNode
            
            switch touchedNode?.text {
            case "Share"?:
                let shareText = "I just scored a " + String(describing: self.scene?.score) + " on Tap Master! What can you get?"
                let activityViewController = UIActivityViewController(activityItems: [shareText as NSString], applicationActivities: nil)
                parentViewController?.present(activityViewController, animated: true)
                break
            case "Play Again"?:
                self.stateMachine?.enter(ActiveGameState.self)
                break
            case "Main Menu"?:
                self.stateMachine?.enter(MainMenuState.self)
                break
            default: break
            }
        }
    }
}
