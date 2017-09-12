//
//  Circle.swift
//  Tap Master
//
//  Created by Abid Rahman on 2017-09-11.
//  Copyright © 2017 Abid Rahman. All rights reserved.
//

import Foundation
import SpriteKit

class Circle : SKSpriteNode {
    
    static let CIRCLE_SPRITES = ["greenc", "redc", "greenc"]
    static let diameter: CGFloat = UIScreen.main.bounds.size.width/6
    static let MINIMUM_VELOCITY : CGFloat = 1.25
    
    var velocity : CGFloat = 0.00
    
    init() {
        let currColor = Circle.CIRCLE_SPRITES[Int(arc4random_uniform(3))]
        let texture = SKTexture(imageNamed: currColor)
        
        super.init(texture: texture, color: UIColor.clear, size: CGSize(width: Circle.diameter, height: Circle.diameter))
        self.color = ("greenc" == currColor) ? UIColor.green : UIColor.red
        self.velocity = Circle.MINIMUM_VELOCITY
        
    }
    
    func update() {
        self.position = CGPoint(x: self.position.x, y: self.position.y - self.velocity)
    }
    
    func reposition(score: Int) {
        self.position = CGPoint(x: self.position.x, y: UIScreen.main.bounds.size.height - Circle.diameter/2)
        self.changeColor()
        self.isHidden = false;
        self.velocity = calculateVelocity(score: score)
    }
    
    func changeColor() {
        let newColor = Circle.CIRCLE_SPRITES[Int(arc4random_uniform(3))]
        self.texture = SKTexture(imageNamed: newColor)
        self.color = ("greenc" == newColor) ? UIColor.green : UIColor.red
    }
    
    func calculateVelocity(score: Int) -> CGFloat {
        return CGFloat(score)/40 + Circle.MINIMUM_VELOCITY + CGFloat(arc4random_uniform(101))/60
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

