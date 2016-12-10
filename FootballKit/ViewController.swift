//
//  ViewController.swift
//  FootballAnimation
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
        
        playManager = PlayManager(view: background)
        playManager?.play(play: items.first)
    }
    
    @IBAction func playToggled(_ sender: Any) {
        print("Play")
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
