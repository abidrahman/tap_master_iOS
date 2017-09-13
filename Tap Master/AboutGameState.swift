//
//  AboutGameState.swift
//  Tap Master
//
//  Created by Abid Rahman on 2017-09-12.
//  Copyright © 2017 Abid Rahman. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import GameplayKit

class AboutGameState: GameSceneState{
    var scene: GameScene?
    var resetNode: SKNode!
    
    init(scene: GameScene){
        self.scene = scene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        
        //Background
        self.scene?.backgroundColor = SKColor.black
        
        //HowToPlay
        let howtoPlay = SKLabelNode(fontNamed: "Indie Flower")
        howtoPlay.text = "How To Play"
        howtoPlay.fontSize = 45
        howtoPlay.color = SKColor.white
        howtoPlay.position = CGPoint(x: (self.scene?.size.width)! * 0.5, y: (self.scene?.size.height)! * 0.90)
        
        //TaptheGreen
        let taptheGreen = SKLabelNode(fontNamed: "Indie Flower")
        taptheGreen.text = "1. Tap the green circles:"
        taptheGreen.fontSize = 25
        taptheGreen.color = SKColor.white
        taptheGreen.position = CGPoint(x: (self.scene?.size.width)! * 0.5, y: (self.scene?.size.height)! * 0.80)
        
        //TaptheRed
        let taptheRed = SKLabelNode(fontNamed: "Indie Flower")
        taptheRed.text = "2. Dont tap the red circles:"
        taptheRed.fontSize = 25
        taptheRed.color = SKColor.white
        taptheRed.position = CGPoint(x: (self.scene?.size.width)! * 0.5, y: (self.scene?.size.height)! * 0.55)
        
        //Cirles
        let greenc = SKSpriteNode(imageNamed: "greenc")
        let redc = SKSpriteNode(imageNamed: "redc")
        greenc.position = CGPoint(x: (self.scene?.size.width)! * 0.5, y: (self.scene?.size.height)! * 0.70)
        greenc.color = UIColor.green
        redc.position = CGPoint(x: (self.scene?.size.width)! * 0.5, y: (self.scene?.size.height)! * 0.45)
        redc.color = UIColor.red
        
        //PlayNow
        let playNow = SKLabelNode(fontNamed: "Indie Flower")
        playNow.text = "Play Now!"
        playNow.fontSize = 35
        playNow.color = SKColor.white
        playNow.position = CGPoint(x: (self.scene?.size.width)! * 0.5, y: (self.scene?.size.height)! * 0.25)
        
        //MainMenu
        let mainMenu = SKLabelNode(fontNamed: "Indie Flower")
        mainMenu.text = "Main Menu"
        mainMenu.fontSize = 35
        mainMenu.color = SKColor.white
        mainMenu.position = CGPoint(x: (self.scene?.size.width)! * 0.5, y: (self.scene?.size.height)! * 0.15)
        
        //Copyright
        let copyRight = SKLabelNode(fontNamed: "Indie Flower")
        copyRight.text = "Created by Abid Rahman"
        copyRight.fontSize = 20
        copyRight.color = SKColor.white
        copyRight.position = CGPoint(x: (self.scene?.size.width)! * 0.5, y: (self.scene?.size.height)! * 0.05)
        
        self.scene?.addChild(howtoPlay)
        self.scene?.addChild(taptheGreen)
        self.scene?.addChild(taptheRed)
        self.scene?.addChild(playNow)
        self.scene?.addChild(mainMenu)
        self.scene?.addChild(greenc)
        self.scene?.addChild(redc)
        self.scene?.addChild(copyRight)
        
    }
    
    override func willExit(to nextState: GKState) {
        self.scene?.removeAllChildren()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return (stateClass == MainMenuState.self) || (stateClass == ActiveGameState.self)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        //todo
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
        for touch in touches {
            let positionTouched = touch.location(in: (self.scene)!)
            
            if let touchedNode = self.scene?.atPoint(positionTouched) as? SKLabelNode {
                switch touchedNode.text {
                case "Play Now!"?:
                    self.stateMachine?.enter(ActiveGameState.self)
                    break
                case "Main Menu"?:
                    self.stateMachine?.enter(MainMenuState.self)
                    break
                default:
                    break
                }
            } else if let touchedNode = self.scene?.atPoint(positionTouched) as? SKSpriteNode {
                if UIColor.red == touchedNode.color {
                    shakeSprite(layer: touchedNode, duration: 1)
                } else if UIColor.green == touchedNode.color {
                    touchedNode.alpha = 0.0
                    let greencFade = SKAction.fadeIn(withDuration: 1.50)
                    touchedNode.run(greencFade)
                }
            }
        }
    }
    
    // Make a sprite shakekkekekekek
    func shakeSprite(layer:SKSpriteNode, duration:Float) {
        
        let position = layer.position
        
        let amplitudeX:Float = 20
        let amplitudeY:Float = 15
        let numberOfShakes = duration / 0.04
        var actionsArray:[SKAction] = []
        for _ in 1...Int(numberOfShakes) {
            let moveX = Float(arc4random_uniform(UInt32(amplitudeX))) - amplitudeX / 2
            let moveY = Float(arc4random_uniform(UInt32(amplitudeY))) - amplitudeY / 2
            let shakeAction = SKAction.moveBy(x: CGFloat(moveX), y: CGFloat(moveY), duration: 0.02)
            shakeAction.timingMode = SKActionTimingMode.easeOut
            actionsArray.append(shakeAction)
            actionsArray.append(shakeAction.reversed())
        }
        
        actionsArray.append(SKAction.move(to: position, duration: 0.0))
        
        let actionSeq = SKAction.sequence(actionsArray)
        layer.run(actionSeq)
    }

}
