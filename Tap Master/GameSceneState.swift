//
//  GameSceneState.swift
//  Tap Master
//
//  Created by Abid Rahman on 2017-09-11.
//  Copyright © 2017 Abid Rahman. All rights reserved.
//

import Foundation
import SpriteKit
import GameKit

class GameSceneState : GKState {
    func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
        preconditionFailure("This method must be overriden")
    }
}
