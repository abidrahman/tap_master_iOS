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
    
    // Circle Constants
    let NUMBER_OF_CIRCLES = 6
    
    // Init circle array
    var circles : [Circle] = [Circle]()
    
    init(scene: GameScene){
        self.scene = scene
        super.init()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return stateClass == GameOverState.self
    }
    
    override func didEnter(from previousState: GKState?) {
        
        self.scene?.score = 0
        self.scene?.backgroundColor = SKColor.black
        
        //Add the circles to the circle array
        for i in 0..<NUMBER_OF_CIRCLES {
            let circle = Circle()
            circle.position = CGPoint(x: (Circle.diameter)*CGFloat(i+1) - Circle.diameter/2, y: (self.scene?.size.height)! - Circle.diameter/2)
            circles.append(circle)
        }
        
        for circle in circles {
            self.scene?.addChild(circle)
        }
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        self.checkCircleBottom()
        for circle in circles {
            circle.update()
            circle.position = CGPoint(x: circle.position.x, y: circle.position.y - 1)
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent) {
        for touch in touches {
            let positionTouched = touch.location(in: (self.scene)!)
            let touchedCircle = self.scene?.atPoint(positionTouched) as? Circle
            
            if (UIColor.green == touchedCircle?.color) {
                touchedCircle?.isHidden = true;
                self.scene?.score += 1
                print(self.scene?.score ?? 0)
            } else if (UIColor.red == touchedCircle?.color) {
                gameOver()
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
        for circle in circles {
            circle.removeFromParent()
        }
        circles = [Circle]()
        self.stateMachine?.enter(GameOverState.self)
    }
}
