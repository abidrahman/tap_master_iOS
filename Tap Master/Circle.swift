//
//  Circle.swift
//  Tap Master
//
//  Created by Abid Rahman on 2017-09-11.
//  Copyright © 2017 Abid Rahman. All rights reserved.
//

import Foundation
import SpriteKit

extension SKSpriteNode {
    
    //To make nodes glow like my face
    func addGlow(radius: Float = 40) {
        let effectNode = SKEffectNode()
        effectNode.shouldRasterize = true
        addChild(effectNode)
        effectNode.addChild(SKSpriteNode(texture: texture))
        effectNode.filter = CIFilter(name: "CIGaussianBlur", withInputParameters: ["inputRadius":radius])
    }
}

class Circle : SKSpriteNode {
    
    static let CIRCLE_SPRITES = ["greenc3", "redc3", "greenc3"]
    static let diameter: CGFloat = UIScreen.main.bounds.size.width/6
    static let MINIMUM_VELOCITY : CGFloat = 1.50
    static let NUMBER_OF_CIRCLES = 6
    
    var velocity : CGFloat = 0.00
    
    init() {
        let currColor = Circle.CIRCLE_SPRITES[Int(arc4random_uniform(3))]
        let texture = SKTexture(imageNamed: currColor)
        
        super.init(texture: texture, color: UIColor.clear, size: CGSize(width: Circle.diameter, height: Circle.diameter))
        self.color = ("greenc3" == currColor) ? UIColor.green : UIColor.red
        self.velocity = Circle.MINIMUM_VELOCITY
       
    }
    
    func update() {
        self.position = CGPoint(x: self.position.x, y: self.position.y - self.velocity)
    }
    
    func reposition(score: Int) {
        self.position = CGPoint(x: self.position.x, y: UIScreen.main.bounds.size.height - Circle.diameter/2)
        self.changeColor()
        self.isHidden = false
        self.velocity = calculateVelocity(score: score)
    }
    
    func changeColor() {
        let newColor = Circle.CIRCLE_SPRITES[Int(arc4random_uniform(3))]
        self.texture = SKTexture(imageNamed: newColor)
        self.color = ("greenc3" == newColor) ? UIColor.green : UIColor.red
    }
    
    func calculateVelocity(score: Int) -> CGFloat {
        return CGFloat(score)/30 + Circle.MINIMUM_VELOCITY + CGFloat(arc4random_uniform(101))/60
    }
    
    func switchColor() {
        self.color = (UIColor.green == self.color) ? UIColor.red : UIColor.green
        self.texture = (UIColor.green == self.color) ? SKTexture(imageNamed: "greenc3") : SKTexture(imageNamed: "redc3")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

