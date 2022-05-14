//
//  TimerInterfaceController.swift
//  Whistle_WatchOS WatchKit Extension
//
//  Created by MinJi Kang on 2022/05/14.
//

import WatchKit
import Foundation


class TimerInterfaceController: WKInterfaceController {

    @IBOutlet weak var minutePicker: WKInterfacePicker!
    @IBOutlet weak var secondPicker: WKInterfacePicker!
    
    @IBOutlet weak var resetButton: WKInterfaceButton!
    @IBOutlet weak var startButton: WKInterfaceButton!
    
    @IBOutlet weak var listPickerGroup: WKInterfaceGroup!
    
    var ounces = 30
    
    enum WatchStatus {
        case start
        case stop
    }
    var watchStatus: WatchStatus = .start

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
        ounces = value + 1
    }
    
    @IBAction func secondPickerChanged(_ value: Int) {
        ounces = value + 1
    }
    
    func minutePickerTimer() {
        var minuteItems: [WKPickerItem] = []
        
        for i in 1...32 {
            let item_minute = WKPickerItem()
            item_minute.title = String(i)
            minuteItems.append(item_minute)
        }
        minutePicker.setItems(minuteItems)
        minutePicker.setSelectedItemIndex(ounces - 1)
    }
    
    func secondPickerTimer() {
        var secondItems: [WKPickerItem] = []
        
        for j in 1...32 {
            let item_second = WKPickerItem()
            item_second.title = String(j)
            secondItems.append(item_second)
        }
        secondPicker.setItems(secondItems)
        secondPicker.setSelectedItemIndex(ounces - 1)
    }
    
    @IBAction func start() {
        switch self.watchStatus {
            case .start:
                self.watchStatus = .stop
                startButton.setTitle("Stop")
                startButton.setBackgroundColor(UIColor.orange)
//                sequencePickerGroup.setHidden(true)
//                listPickerGroup.setHidden(true)
            case .stop:
                self.watchStatus = .start
                startButton.setTitle("Start")
                startButton.setBackgroundColor(UIColor.green)
        }
    }
    
}
