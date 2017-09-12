//
//  GameScene.swift
//  Tap Master
//
//  Created by Abid Rahman on 2017-09-10.
//  Copyright © 2017 Abid Rahman. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

class GameScene: SKScene {
    
    var stateMachine: GKStateMachine!
    var score = 0
    
    override func didMove(to view: SKView) {
        
        let mainMenuState = MainMenuState(scene: self)
        let activeGameState = ActiveGameState(scene: self)
        let gameOverState = GameOverState(scene: self)
        
        stateMachine = GKStateMachine(states: [mainMenuState, activeGameState, gameOverState])
        stateMachine.enter(MainMenuState.self)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for _ in touches {
            let currState = stateMachine.currentState as! GameSceneState
            currState.touchesBegan(touches: touches, withEvent: event!)
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        self.stateMachine.currentState?.update(deltaTime: currentTime)
    }
}
