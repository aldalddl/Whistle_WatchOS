//
//  TimerView.swift
//  Whistle_WatchOS WatchKit Extension
//
//  Created by 강민지 on 11/11/24.
//

import SwiftUI
import Combine

struct TimerView: View {
    @State private var minute = 0
    @State private var second = 0
    @State private var isRunning = false
    @State private var remainingSeconds = 0
    @State private var showPicker = true
    @State private var timerCancellable: AnyCancellable?
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
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
                            .frame(maxWidth: geometry.size.width / 2)
                            
                            HStack {
                                Picker("Second", selection: $second) {
                                    ForEach(0..<60) {
                                        Text("\($0)")
                                    }
                                }
                                .pickerStyle(.wheel)
                                
                                Text("sec")
                            }
                            .frame(maxWidth: geometry.size.width / 2)
                        }
                    } else {
                        HStack {
                            Text(String(format: "%02d : %02d", remainingSeconds / 60, remainingSeconds % 60))
                                .font(.system(size: 60, weight: .semibold))
                        }
                    }
                }
                .frame(height: geometry.size.height * 0.7)
                
                Spacer().frame(height: 20)
                
                HStack {
                    Button(action: {
                        resetTimer()
                    }) {
                        Text("Reset")
                    }
                    .controlSize(.mini)
                    .buttonStyle(.borderedProminent)
                    .tint(!isRunning && !showPicker ? .orange : nil)
                    .disabled(showPicker)
                    
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
        .padding([.leading, .trailing], 10)
    }
    
    func startTimer() {
        guard minute > 0 || second > 0 else { return }
        
        showPicker = false
        remainingSeconds = minute * 60 + second
        isRunning = true
        
        timerCancellable = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if remainingSeconds > 0 {
                    remainingSeconds -= 1
                } else {
                    resetTimer()
                }
            }
    }
    
    func stopTimer() {
        timerCancellable?.cancel()
        timerCancellable = nil
        isRunning = false
    }
    
    func resetTimer() {
        stopTimer()
        showPicker = true
        remainingSeconds = 0
    }
}
