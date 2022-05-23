//
//  TimerInterfaceController.swift
//  Whistle_WatchOS WatchKit Extension
//
//  Created by MinJi Kang on 2022/05/14.
//

import WatchKit
import Foundation


class TimerInterfaceController: WKInterfaceController {

    @IBOutlet weak var myTimer: WKInterfaceTimer!
    
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
    
    var timer : Timer?
    var elapsedTime : TimeInterval = 0.0
    var startTime = NSDate()
    var duration : TimeInterval = 45.0
    
    var minute : TimeInterval = 0.0
    var second : TimeInterval = 0.0
    
    var minutesPassed = 0
    var secondsPassed = 0
    var minuteTotalTime = 0
    var secondTotalTime = 0

    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        // Configure interface objects here.
//        resetButton.setAlpha(0.5)
//        minutePickerTimer()
//        secondPickerTimer()
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        resetButton.setAlpha(0.5)
        minutePickerTimer()
        secondPickerTimer()
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
                resetButton.setAlpha(1.0)
            
//                sequencePickerGroup.setHidden(true)
//                listPickerGroup.setHidden(true)
            
//                timer!.invalidate()
                minuteTotalTime = minuteOunces - 1
                secondTotalTime = secondOunces

                secondsPassed = 0
                minutesPassed = 0
            
                minute = Double(minuteTotalTime) * 60.0
                second = Double(secondTotalTime)
                duration = minute + second
//                date = NSDate(timeIntervalSinceNow: duration - elapsedTime) as Date

                timer = Timer.scheduledTimer(timeInterval: duration - elapsedTime, target: self, selector: #selector(timerDone), userInfo: nil, repeats: true)
                myTimer.setDate(NSDate(timeIntervalSinceNow: duration - elapsedTime) as Date)
                myTimer.start()
                startTime = NSDate()
            
            case .stop:
                self.watchStatus = .start
                startButton.setTitle("Start")
                startButton.setBackgroundColor(UIColor.green)
                resetButton.setAlpha(1.0)
                
                let paused = NSDate()
                elapsedTime += paused.timeIntervalSince(startTime as Date)
                myTimer.stop()
                timer?.invalidate()
        }
    }
    
    @IBAction func reset() {
        timer?.invalidate()
        startButton.setTitle("Start")
        startButton.setBackgroundColor(UIColor.green)
        resetButton.setAlpha(0.5)
        
        //WKInterfaceTimer reset to picker time
        myTimer.stop()
        myTimer.setDate(NSDate(timeIntervalSinceNow: 0.0) as Date)
        
        // Timer reset to picker time
        elapsedTime = 0.0
    }
    
    @objc func timerDone(){
        timer?.invalidate()
        print("End.")
        startButton.setTitle("Start")
        startButton.setBackgroundColor(UIColor.green)
        resetButton.setAlpha(0.5)
        
//        //WKInterfaceTimer reset to picker time
        myTimer.stop()
        myTimer.setDate(NSDate(timeIntervalSinceNow: 0.0) as Date)
        
        // Timer reset to picker time
        elapsedTime = 0.0
    }
}
