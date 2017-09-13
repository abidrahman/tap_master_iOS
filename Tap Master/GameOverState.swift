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
    var scene: GameScene?
    var resetNode: SKNode!
    
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
        let scoreMove = SKAction.moveBy(x: 0, y: -((self.scene?.size.height)! * 0.3), duration: 0.50)
        let scoreAnimate = SKAction.group([scoreZoom, scoreMove])
        
        //TopScores
        let topScores = SKLabelNode(fontNamed: "Indie Flower")
        topScores.text = "Top Scores"
        topScores.fontSize = 25
        topScores.color = SKColor.white
        topScores.position = CGPoint(x: (self.scene?.size.width)! * 0.215, y: (self.scene?.size.height)! * 0.935)
        
        //Share
        let shareText = SKLabelNode(fontNamed: "Indie Flower")
        shareText.text = "Share"
        shareText.fontSize = 25
        shareText.color = SKColor.white
        shareText.position = CGPoint(x: (self.scene?.size.width)! * 0.85, y: (self.scene?.size.height)! * 0.935)
        
        //HighScore
        let highScore = SKLabelNode(fontNamed: "Indie Flower")
        highScore.text = "High Score: " + String(describing: self.scene?.score ?? 0)
        highScore.fontSize = 30
        highScore.color = SKColor.white
        highScore.position = CGPoint(x: (self.scene?.size.width)! * 0.5, y: (self.scene?.size.height)!/2)
        
        //GameOver
        let gameOver = SKLabelNode(fontNamed: "Indie Flower")
        gameOver.text = "Game Over"
        gameOver.fontSize = 45
        gameOver.color = SKColor.white
        gameOver.position = CGPoint(x: (self.scene?.size.width)! * 0.5, y: (self.scene?.size.height)! * 0.4)
        
        //PlayAgain
        let playAgain = SKLabelNode(fontNamed: "Indie Flower")
        playAgain.text = "Play Again"
        playAgain.fontSize = 35
        playAgain.color = SKColor.white
        playAgain.position = CGPoint(x: (self.scene?.size.width)! * 0.5, y: (self.scene?.size.height)! * 0.25)
        
        //MainMenu
        let mainMenu = SKLabelNode(fontNamed: "Indie Flower")
        mainMenu.text = "Main Menu"
        mainMenu.fontSize = 35
        mainMenu.color = SKColor.white
        mainMenu.position = CGPoint(x: (self.scene?.size.width)! * 0.5, y: (self.scene?.size.height)! * 0.15)
        
        self.scene?.addChild(shareText)
        self.scene?.addChild(mainMenu)
        self.scene?.addChild(highScore)
        self.scene?.addChild(gameOver)
        self.scene?.addChild(playAgain)
        self.scene?.addChild(topScores)
        self.scene?.addChild(scoreText)
        scoreText.run(scoreAnimate)
        
    }
    
    override func willExit(to nextState: GKState) {
        self.scene?.removeAllChildren()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return (stateClass == MainMenuState.self) || (stateClass == ActiveGameState.self) || (stateClass == TopScoresState.self)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        //todo
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
        for touch in touches {
            let positionTouched = touch.location(in: (self.scene)!)
            let touchedNode = self.scene?.atPoint(positionTouched) as? SKLabelNode
            
            switch touchedNode?.text {
            case "Top Scores"?:
                self.stateMachine?.enter(TopScoresState.self)
                break
            case "Share"?:
                //todo
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
