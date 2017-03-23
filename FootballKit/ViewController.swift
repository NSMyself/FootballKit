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
            
            var p1 = Play(scored: true, kind: .OpenPlay, ball: ["A1", "G5"], homeTeam: [:], awayTeam: [:])
        
            let bernardo = Player(name: Name(full: "Bernardo Silva", short: "Bernardo Silva", jersey: "Bernardo"), number: 10)
            p1.homeTeam[bernardo] = ["G11", "C8"]
            
            
            let renato = Player(name: Name(full: "Renato Sanches", short: "Renato Sanches", jersey: "Renato Sanches"), number: 8)
            
            p1.homeTeam[renato] = ["F5", "A5"]
            
            items.append(p1)
            
            playManager?.play(play: items.first!)
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
