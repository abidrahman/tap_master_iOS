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

    init(scene: GameScene){
        self.scene = scene
        super.init()
        self.scene?.backgroundColor = SKColor.black
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == ActiveGameState.self
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        //todo
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
        self.stateMachine?.enter(ActiveGameState.self)
        print("Going into activeState")
    }
}
