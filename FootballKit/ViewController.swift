//
//  ViewController.swift
//  FootballKit
//
//  Created by João Pereira on 11/11/16.
//  Copyright © 2016 NSMyself. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
	
    @IBOutlet var background: UIImageView?
    var playManager:PlayManager?
    var items:[Play] = []
    var i = 0
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let bundle = Bundle.main.path(forResource: "goals", ofType: "json") else { return }
        items = JSONParser.parse(url: URL(fileURLWithPath: bundle))
        
        if let background = background {
            playManager = PlayManager(view: background)
            
            let p1 = Play(scored: true, kind: .OpenPlay)
            let home = Team(name: "Home Team", country: "Portugal", colour: .red)
            
            let bernardo = Player(name: "Bernardo Silva", number: 10, at:.D1)
            bernardo.move(to: .B2, duration: 1)
            bernardo.pass(to: .C8, duration: 0.8, swerve: .right)
            
            let renato = Player(name: "Renato Sanches", number: 8, at:.D9)
            renato.move(to: .C8, duration:1.8)
            renato.shoot()
            
            //renato.holdPosition(duration: 5)
            //renato.move(to: .C9, duration:1) // we need to see if we previously had the ball; if we haven't lost it/passed/shot, we still have it
            //renato.shoot() // only if we have the damn thing
            
            home.register(player: renato)
            home.register(player: bernardo)
            
            p1.homeTeam = home
            p1.initialBallCarrier = bernardo
            
            items.append(p1)
            
            playManager?.play(play: p1)
        }
    }
    
    @IBAction func playToggled(_ sender: Any) {
        playManager?.animate(play: items.first!)
    }
    
    @IBAction func prevClicked(_ sender: Any) {
        changeItem(step: -1)
    }
    
    @IBAction func nextClicked(_ sender: Any) {
        changeItem(step: 1)
    }
    
    // MARK: - Navigation
    func changeItem(step: Int) {
        
        let newIndex = i + step
        
        if ((newIndex >= 0) && (newIndex < items.count)) {
            i = newIndex
            print(i)
            playManager?.play(play: items[i])
        }
    }
}
