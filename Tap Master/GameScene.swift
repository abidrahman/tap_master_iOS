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
import GoogleMobileAds

class GameScene: SKScene {
    
    var profileViewController : UIViewController?
    var stateMachine: GKStateMachine!
    var score = 0
    var numPlayed = 0
    var interstitialAd: GADInterstitial!
    
    override func didMove(to view: SKView) {
        
        let mainMenuState = MainMenuState(scene: self)
        let aboutGameState = AboutGameState(scene: self)
        let highScoreState = HighScoreState(scene: self)
        highScoreState.parentViewController = self.profileViewController
        let activeGameState = ActiveGameState(scene: self)
        let gameOverState = GameOverState(scene: self)
        gameOverState.parentViewController = self.profileViewController
        
        stateMachine = GKStateMachine(states: [mainMenuState, aboutGameState, highScoreState, activeGameState, gameOverState])
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
