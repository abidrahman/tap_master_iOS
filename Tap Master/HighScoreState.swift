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
import GoogleMobileAds
import Firebase

class HighScoreState: GameSceneState{
    
    var parentViewController : UIViewController?
    var scene: GameScene?
    var bannerAd: GADBannerView!
    
    let hScore = SKLabelNode(fontNamed: "Indie Flower")
    var highScore = UserDefaults.standard.value(forKey: "Highscore") as? Int
    var counter = 0
    
    init(scene: GameScene){
        self.scene = scene
        super.init()
    }
    
    override func didEnter(from previousState: GKState?) {
        self.scene?.backgroundColor = SKColor.black
        highScore = UserDefaults.standard.value(forKey: "Highscore") as? Int
        
        //Analytics
        Analytics.logEvent(AnalyticsEventViewItem, parameters: [AnalyticsParameterItemID : "High Score Screen" as NSObject])

        //Ad
        bannerAd = GADBannerView(adSize: kGADAdSizeSmartBannerPortrait)
        bannerAd.frame.origin.y = (self.scene?.size.height)! - bannerAd.frame.size.height
        self.parentViewController?.view.addSubview(bannerAd)
        bannerAd.adUnitID = "ca-app-pub-3441960749414963/5109155133"
        bannerAd.rootViewController = self.parentViewController
        bannerAd.load(GADRequest())
        
        //HScoreLabel
        let hScoreLabel = SKLabelNode(fontNamed: "Indie Flower")
        hScoreLabel.text = "Your high score is.."
        hScoreLabel.fontSize = 30
        hScoreLabel.color = SKColor.white
        hScoreLabel.position = CGPoint(x: (self.scene?.size.width)! * 0.5, y: (self.scene?.size.height)! * 0.90)
        
        //Score
        hScore.text = "0"
        hScore.fontSize = 175
        hScore.color = SKColor.white
        hScore.position = CGPoint(x: (self.scene?.size.width)! * 0.5, y: (self.scene?.size.height)! * 0.60)
        
        //Share
        let shareHS = SKLabelNode(fontNamed: "Indie Flower")
        shareHS.text = "Share High Score"
        shareHS.fontSize = 35
        shareHS.color = SKColor.white
        shareHS.position = CGPoint(x: (self.scene?.size.width)! * 0.5, y: (self.scene?.size.height)! * 0.35)
        
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
        
        self.scene?.addChild(hScoreLabel)
        self.scene?.addChild(hScore)
        self.scene?.addChild(shareHS)
        self.scene?.addChild(playNow)
        self.scene?.addChild(mainMenu)
    }
    
    override func willExit(to nextState: GKState) {
        bannerAd.removeFromSuperview()
        self.scene?.removeAllChildren()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        return (stateClass == MainMenuState.self)
    }
    
    override func update(deltaTime seconds: TimeInterval) {
        //Slow down incrementer if score is less than 150
        if (highScore)! < 150 {
            counter += 1
        }
        if (0 == counter % 2) && ((highScore)! > Int(hScore.text!)!){
            let newScore = Int(hScore.text!)! + 1
            hScore.text = String(describing: newScore)
        }
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
                case "Share High Score"?:
                    let shareText = "My high score on Tap Master is " + hScore.text! + ". What can you get?"
                    let activityViewController = UIActivityViewController(activityItems: [shareText as NSString], applicationActivities: nil)
                    parentViewController?.present(activityViewController, animated: true)
                    break
                default:
                    break
    
                }
            }
        }
    }
}
