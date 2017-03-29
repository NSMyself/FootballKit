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
            
            var p1 = Play(scored: true, kind: .OpenPlay)
            var home = Team(name: "Home Team", country: "Portugal", colour: .red)
            
            //let bernardo = Player(name: "Bernardo Silva", number: 10)
            
            var renato = Player(name: "Renato Sanches", number: 8, at:.G11)
            renato.move(to: .C8, duration:1, ball: true)
            renato.holdPosition(duration: 2)
            renato.pass(to: .C9, duration:2)
            renato.shoot() // goal = false (default)
            
            home.register(player: renato)
            p1.homeTeam = home
            
            //renato.ball = true
            //renato.pass(to: bernardo, timespan:4)
            /* renato.shoot() // goal = false (default)
            renato.shoot(goal:true) // default shooting speed for now
 
            p1.homeTeam.register(player: bernardo, at:.G11)
                                 
                                 
                                 positions: [0:"G11", 1:"C8", 2:"C9"])
            p1.homeTeam.register(player: renato, positions: [0:"C1", 1:"B5"])
            items.append(p1)
            */
            
            playManager?.play(play: p1)
        }
    }
    
    @IBAction func playToggled(_ sender: Any) {
        //playManager?.animate(play: p1)
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
