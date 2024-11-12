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
    @State private var remaingSeconds = 0
    @State private var showPicker = true
    
    var body: some View {
        VStack {
            if showPicker {
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
            } else {
                HStack {
                    Text(String(format: "%02d : %02d", remaingSeconds / 60, remaingSeconds % 60))
                        .font(.system(size: 40, weight: .bold))
                }
            }
            
            Spacer().frame(height: 20)
            
            HStack {
                Button(action: {
                    resetTimer()
                }) {
                    Text("Reset")
                }
                .controlSize(.mini)
                .buttonStyle(.borderedProminent)
                .disabled(isRunning ? false : true)
                
                Spacer().frame(width: 20)
                
                Button(action: {
                    if !isRunning {
                        startTimer()
                    } else {
                        stopTimer()
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
    
    func startTimer() {
        showPicker = false
        remaingSeconds = minute * 60 + second
        isRunning = true
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { _ in
            if remaingSeconds > 0 {
                remaingSeconds -= 1
            } else {
                resetTimer()
            }
        }
    }
    
    func stopTimer() {
        timer?.invalidate()
        timer = nil
        isRunning = false
    }
    
    func resetTimer() {
        stopTimer()
        showPicker = true
        remaingSeconds = 0
    }
}
