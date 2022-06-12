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
    @IBOutlet weak var countdownGroup: WKInterfaceGroup!
    
    @IBOutlet weak var timePickerGroup: WKInterfaceGroup!
    @IBOutlet weak var minutePickerGroup: WKInterfaceGroup!
    @IBOutlet weak var secondPickerGroup: WKInterfaceGroup!
    
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
        countdownGroup.setHidden(true)
        
        startButton.setEnabled(false)
        startButton.setBackgroundColor(UIColor(red: 79/255, green: 194/255, blue: 86/255, alpha: 1))
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        resetButton.setEnabled(false)
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
        
        processButtonStatus()
    }
    
    @IBAction func secondPickerChanged(_ value: Int) {
        secondOunces = value + 1
        print("second value: \(value)")
        
        processButtonStatus()
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
                startButton.setBackgroundColor(.orange)
                resetButton.setEnabled(true)
            
                timePickerGroup.setHidden(true)
                countdownGroup.setHidden(false)
            
                minuteTotalTime = minuteOunces - 1
                secondTotalTime = secondOunces

                secondsPassed = 0
                minutesPassed = 0
            
                minute = Double(minuteTotalTime) * 60.0
                second = Double(secondTotalTime)
                duration = minute + second

                timer = Timer.scheduledTimer(timeInterval: duration - elapsedTime, target: self, selector: #selector(timerDone), userInfo: nil, repeats: true)

                myTimer.setDate(NSDate(timeIntervalSinceNow: duration - elapsedTime) as Date)
                myTimer.start()
                startTime = NSDate()
            
            case .stop:
                self.watchStatus = .start
                startButton.setTitle("Start")
                startButton.setBackgroundColor(UIColor(red: 79/255, green: 194/255, blue: 86/255, alpha: 1))
                resetButton.setEnabled(true)
                
                let paused = NSDate()
                elapsedTime += paused.timeIntervalSince(startTime as Date)
                myTimer.stop()
                timer?.invalidate()
        }
    }
    
    @IBAction func reset() {
        // avoid going to stop status
        watchStatus = .start
        
        timer?.invalidate()
        startButton.setTitle("Start")
        startButton.setBackgroundColor(UIColor(red: 79/255, green: 194/255, blue: 86/255, alpha: 1))
        resetButton.setEnabled(false)
        
        timePickerGroup.setHidden(false)
        countdownGroup.setHidden(true)
        
        // WKInterfaceTimer reset to picker time
        myTimer.stop()
        myTimer.setDate(NSDate(timeIntervalSinceNow: 0.0) as Date)
        
        // Timer reset to picker time
        elapsedTime = 0.0
    }
    
    @objc func timerDone(){
        // avoid going to stop status
        watchStatus = .start
        
        timer?.invalidate()
        print("End.")
        startButton.setTitle("Start")
        startButton.setBackgroundColor(UIColor(red: 79/255, green: 194/255, blue: 86/255, alpha: 1))
        resetButton.setEnabled(false)
        
        timePickerGroup.setHidden(false)
        countdownGroup.setHidden(true)
        
        // WKInterfaceTimer reset to picker time
        myTimer.stop()
        myTimer.setDate(NSDate(timeIntervalSinceNow: 0.0) as Date)
        
        // Timer reset to picker time
        elapsedTime = 0.0
    }
}

// MARK: Start Button
extension TimerInterfaceController {
    
    // Activate Start Button when time is over 0
    private func processButtonStatus() {
        
         if secondOunces == 1 && minuteOunces == 1 {
            print("Disabled")
            startButton.setEnabled(false)
        } else {
            print("abled")
            startButton.setEnabled(true)
        }
        
    }
}
