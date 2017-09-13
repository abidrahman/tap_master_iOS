//
//  TopScoresState.swift
//  Tap Master
//
//  Created by Abid Rahman on 2017-09-12.
//  Copyright © 2017 Abid Rahman. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit
import GameplayKit

class TopScoresState: GameSceneState{
    var scene: GameScene?
    var resetNode: SKNode!
    
    init(scene: GameScene){
        self.scene = scene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        self.scene?.backgroundColor = SKColor.black
    }
    
    override func willExit(to nextState: GKState) {
        self.scene?.removeAllChildren()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return (stateClass == MainMenuState.self)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        //todo
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
        self.stateMachine?.enter(MainMenuState.self)
    }
}
