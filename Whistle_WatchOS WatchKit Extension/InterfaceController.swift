//
//  InterfaceController.swift
//  Whistle_WatchOS WatchKit Extension
//
//  Created by MinJi Kang on 2022/05/14.
//

import WatchKit
import Foundation
import AVFoundation

class InterfaceController: WKInterfaceController {
    var player: AVAudioPlayer!
    
    @IBOutlet weak var whistleButton: WKInterfaceButton!
    
    override func awake(withContext context: Any?) {
        // Configure interface objects here.
    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
    }

    @IBAction func whistleButtonPressed() {
        playSound()
    }
    
    func playSound() {
        let url = Bundle.main.url(forResource: "whistleSound", withExtension: "wav")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.play()
        player.numberOfLoops = -1
    }
    
}
