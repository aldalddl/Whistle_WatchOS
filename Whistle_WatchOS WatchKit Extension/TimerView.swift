//
//  TimerView.swift
//  Whistle_WatchOS WatchKit Extension
//
//  Created by 강민지 on 11/11/24.
//

import SwiftUI

struct TimerView: View {
    @State private var minute = 0
    @State private var second = 0
    @State private var isRunning = false
    @State private var timer: Timer? = nil
    @State private var count = 0
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    Picker("Minute", selection: $minute) {
                        ForEach(0..<60) {
                            Text("\($0)")
                        }
                    }
                    .pickerStyle(.wheel)
                    
                    Text("min")
                }
                
                HStack {
                    Picker("Second", selection: $second) {
                        ForEach(0..<60) {
                            Text("\($0)")
                        }
                    }
                    .pickerStyle(.wheel)
                    
                    Text("sec")
                }
            }
            
            Spacer().frame(height: 20)
            
            HStack {
                Button(action: {
                    count = 0
                    timer?.invalidate()
                    timer = nil
                    isRunning = false
                }) {
                    Text("Reset")
                }
                .controlSize(.mini)
                .buttonStyle(.borderedProminent)
                .disabled(isRunning ? false : true)
                
                Spacer().frame(width: 20)
                
                Button(action: {
                    if timer == nil {
                        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
                            count += 1
                        }
                        isRunning = true
                    } else {
                        timer?.invalidate()
                        timer = nil
                        isRunning = false
                    }
                }) {
                    Text(isRunning ? "Stop" : "Start")
                }
                .controlSize(.mini)
                .buttonStyle(.borderedProminent)
                .tint(isRunning ? .green : .red)
            }
        }
        .padding(.top, -25)
    }
}
