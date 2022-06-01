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
    
    @IBOutlet weak var volumeSlider: WKInterfaceSlider!
    let minVal: Float = 0
    let maxVal: Float = 10
    var selectedVal: Float = 5

    override func awake(withContext context: Any?) {
        // Configure interface objects here.
        // The sequencer should be focused to receive events
//         crownSequencer.focus()
//         crownSequencer.delegate = self
//        crownSequencer.delegate = self
        
        let url = Bundle.main.url(forResource: "whistleSound", withExtension: "wav")
        player = try! AVAudioPlayer(contentsOf: url!)
        player.volume = 0.5
        volumeSlider.setValue(maxVal * 0.5)

    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
//        crownSequencer.focus()

    }
    
    override func didAppear() {
        super.didAppear()
        crownSequencer.delegate = self
        crownSequencer.focus()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
//        stopSound()
    }

    @IBAction func whistleButtonPressed() {
        playSound()
    }
    
    func playSound() {
        player.play()
//        player.numberOfLoops = -1
    }
    
    func stopSound() {
        player.stop()
    }
    
    @IBAction func volumeSliderChanged(_ value: Float) {
        selectedVal = value
        print("selectedVal 2", selectedVal)
        player.volume = selectedVal * 0.1
        print("player.volume", player.volume)

    }
    
}

// MARK: WKCrownDelegate
extension InterfaceController: WKCrownDelegate {
    public func crownDidRotate(_ crownSequencer: WKCrownSequencer?, rotationalDelta: Double) {
        // 1 divided by number of rotations required to change the value from min to max

        let rotationToValRatio = 0.25 * Double(maxVal - minVal)

        let newVal = selectedVal + Float(rotationalDelta) * Float(rotationToValRatio)

        let trimmedNewVal = max(minVal, min(newVal, maxVal))

        volumeSlider.setValue(Float(trimmedNewVal))
        print("Float(trimmedNewVal)", Float(trimmedNewVal))

        selectedVal = trimmedNewVal
        print("selectedVal", selectedVal)
        player.volume = selectedVal * 0.1
        print("player.volume", player.volume)
    }
}
