//
//  TimerInterfaceController.swift
//  Whistle_WatchOS WatchKit Extension
//
//  Created by MinJi Kang on 2022/05/14.
//

import WatchKit
import Foundation


class TimerInterfaceController: WKInterfaceController {

    @IBOutlet weak var WKTimer: WKInterfaceTimer!
    
    @IBOutlet weak var minutePicker: WKInterfacePicker!
    @IBOutlet weak var secondPicker: WKInterfacePicker!
    
    @IBOutlet weak var resetButton: WKInterfaceButton!
    @IBOutlet weak var startButton: WKInterfaceButton!
    
    @IBOutlet weak var listPickerGroup: WKInterfaceGroup!
    
    var minuteOunces = 1
    var secondOunces = 1

    enum WatchStatus {
        case start
        case stop
    }
    var watchStatus: WatchStatus = .start
    
    var timer = Timer()
    var minutesPassed = 0
    var secondsPassed = 0
    var minuteTotalTime = 0
    var secondTotalTime = 0

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
        minutePickerTimer()
        secondPickerTimer()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

    @IBAction func minutePickerChanged(_ value: Int) {
        minuteOunces = value + 1
        print("minute value: \(value)")
    }
    
    @IBAction func secondPickerChanged(_ value: Int) {
        secondOunces = value + 1
        print("second value: \(value)")
    }
    
    func minutePickerTimer() {
        var minuteItems: [WKPickerItem] = []
        
        for i in 0...59 {
            let item_minute = WKPickerItem()
            item_minute.title = String(i)
            minuteItems.append(item_minute)
        }
        minutePicker.setItems(minuteItems)
        minutePicker.setSelectedItemIndex(minuteOunces - 1)
    }
    
    func secondPickerTimer() {
        var secondItems: [WKPickerItem] = []
        
        for j in 0...59 {
            let item_second = WKPickerItem()
            item_second.title = String(j)
            secondItems.append(item_second)
        }
        secondPicker.setItems(secondItems)
        secondPicker.setSelectedItemIndex(secondOunces - 1)
    }
    
    @IBAction func start() {
        switch self.watchStatus {
            case .start:
                self.watchStatus = .stop
                startButton.setTitle("Stop")
                startButton.setBackgroundColor(UIColor.orange)
//                sequencePickerGroup.setHidden(true)
//                listPickerGroup.setHidden(true)
            
                timer.invalidate()
                minuteTotalTime = minuteOunces - 1
                secondTotalTime = secondOunces - 1
                
                secondsPassed = 0
                minutesPassed = 0
            
                let minute:TimeInterval = Double(minuteTotalTime) * 60.0
                let second:TimeInterval = Double(secondTotalTime)
                let totalTime: TimeInterval = minute + second
                let date = Date(timeIntervalSinceNow: totalTime)

                timer = Timer.scheduledTimer(timeInterval: totalTime, target: self, selector: #selector(timerDone), userInfo: nil, repeats: true)
                WKTimer.setDate(date)
                WKTimer.start()
            
            case .stop:
                self.watchStatus = .start
                startButton.setTitle("Start")
                startButton.setBackgroundColor(UIColor.green)
        }
    }
    
    @objc func timerDone(){
        //timer done counting down
        timer.invalidate()
        print("End.")
    }
}


