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
    @State private var showPicker = true
    
    @StateObject private var timerManager = TimerManager()
    
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
                        TimerDisplay(remainingSeconds: timerManager.remainingSeconds)
                    }
                }
                .frame(height: geometry.size.height * 0.7)
                
                Spacer().frame(height: 20)
                
                ControlButtons(
                    isRunning: timerManager.isRunning,
                    showPicker: showPicker,
                    onReset: {
                        timerManager.resetTimer()
                        showPicker = true
                    },
                    onStartStop: {
                        if !timerManager.isRunning {
                            timerManager.setTimer(minute: minute, second: second)
                            timerManager.startTimer()
                            showPicker = false
                        } else {
                            timerManager.stopTimer()
                        }
                    }
                )
            }
            .padding(.top, -25)
        }
        .padding([.leading, .trailing], 10)
    }
}

struct TimerDisplay: View {
    let remainingSeconds: Int
    
    var body: some View {
        HStack {
            Text(String(format: "%02d : %02d", remainingSeconds / 60, remainingSeconds % 60))
                .font(.system(size: 60, weight: .semibold))
        }
    }
}

struct ControlButtons: View {
    let isRunning: Bool
    let showPicker: Bool
    let onReset: () -> Void
    let onStartStop: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onReset) {
                Text("Reset")
            }
            .controlSize(.mini)
            .buttonStyle(.borderedProminent)
            .tint(!isRunning && !showPicker ? .orange : nil)
            .disabled(showPicker)
            
            Spacer().frame(width: 20)
            
            Button(action: onStartStop) {
                Text(isRunning ? "Stop" : "Start")
            }
            .controlSize(.mini)
            .buttonStyle(.borderedProminent)
            .tint(isRunning ? .green : .red)
        }
    }
}

class TimerManager: ObservableObject {
    @Published private(set) var remainingSeconds = 0
    @Published private(set) var isRunning = false
    
    private var timerCancellable: AnyCancellable?
    
    func setTimer(minute: Int, second: Int) {
        remainingSeconds = minute * 60 + second
    }
    
    func startTimer() {
        guard remainingSeconds > 0 else { return }
        
        isRunning = true
        
        timerCancellable = Timer.publish(every: 1.0, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                
                if self.remainingSeconds > 0 {
                    self.remainingSeconds -= 1
                } else {
                    self.resetTimer()
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
        remainingSeconds = 0
    }
}
