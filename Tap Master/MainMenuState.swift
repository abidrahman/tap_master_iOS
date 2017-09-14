//
//  MainMenuState.swift
//  Tap Master
//
//  Created by Abid Rahman on 2017-09-11.
//  Copyright © 2017 Abid Rahman. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import GameplayKit

class MainMenuState: GameSceneState{
    var scene: GameScene?
    var resetNode: SKNode!
    
    // Init circle array
    var circles : [Circle] = [Circle]()
    
    init(scene: GameScene){
        self.scene = scene
        super.init()
    }
    
    //Handle enterting into this state
    override func didEnter(from previousState: GKState?) {
        self.scene?.backgroundColor = SKColor.black
        circles = [Circle]()
        
        //Tap Master title
        let title = SKLabelNode(fontNamed: "Indie Flower")
        title.text = "Tap Master"
        title.fontSize = 65
        title.fontColor = SKColor.white
        title.position = CGPoint(x: (self.scene?.size.width)! * 0.5, y: (self.scene?.size.height)! * 0.8)
        
        //Play
        let playButton = SKLabelNode(fontNamed: "Indie Flower")
        playButton.text = "Play"
        playButton.fontSize = 30
        playButton.fontColor = SKColor.white
        playButton.position = CGPoint(x: (self.scene?.size.width)! * 0.5, y: (self.scene?.size.height)! * 0.5)
        
        //About
        let aboutButton = SKLabelNode(fontNamed: "Indie Flower")
        aboutButton.text = "About"
        aboutButton.fontSize = 30
        aboutButton.fontColor = SKColor.white
        aboutButton.position = CGPoint(x: (self.scene?.size.width)! * 0.5, y: (self.scene?.size.height)! * 0.4)
        
        //HighScore
        let hscoreButton = SKLabelNode(fontNamed: "Indie Flower")
        hscoreButton.text = "High Score"
        hscoreButton.fontSize = 30
        hscoreButton.fontColor = SKColor.white
        hscoreButton.position = CGPoint(x: (self.scene?.size.width)! * 0.5, y: (self.scene?.size.height)! * 0.3)
        
        //Add the circles to the circle array
        for i in 0..<Circle.NUMBER_OF_CIRCLES {
            let circle = Circle()
            circle.position = CGPoint(x: (Circle.diameter)*CGFloat(i+1) - Circle.diameter/2, y: (self.scene?.size.height)! - Circle.diameter/2)
            circle.velocity = CGFloat(arc4random_uniform(101))/20.0 + 3.00
            circle.alpha = 0.75
            circles.append(circle)
        }
        
        for circle in circles {
            self.scene?.addChild(circle)
        }
        self.scene?.addChild(title)
        self.scene?.addChild(playButton)
        self.scene?.addChild(aboutButton)
        self.scene?.addChild(hscoreButton)
   
    }
    
    //Handle exiting out of this state
    override func willExit(to nextState: GKState) {
        self.scene?.removeAllChildren()
        
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return (stateClass == ActiveGameState.self) || (stateClass == AboutGameState.self) || (stateClass == HighScoreState.self)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        checkCircleBottom()
        for circle in circles {
            circle.update()
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
        for touch in touches {
            let positionTouched = touch.location(in: (self.scene)!)
            if let touchedNode = self.scene?.atPoint(positionTouched) as? SKLabelNode {
            
                switch touchedNode.text {
                case "Play"?:
                    self.stateMachine?.enter(ActiveGameState.self)
                    break
                case "About"?:
                    self.stateMachine?.enter(AboutGameState.self)
                    break
                case "High Score"?:
                    self.stateMachine?.enter(HighScoreState.self)
                    break
                default:
                    break
                }
            } else if let touchedNode = self.scene?.atPoint(positionTouched) as? Circle {
                touchedNode.switchColor();
            }
        }
    }
    
    func checkCircleBottom() {
        for circle in circles {
            if (circle.position.y <= -Circle.diameter/2) {
                circle.reposition(score: 200)
            }
        }
    }
}
