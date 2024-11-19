//
//  WhistleView.swift
//  Whistle_WatchOS WatchKit Extension
//
//  Created by 강민지 on 11/11/24.
//

import SwiftUI
import Combine
import AVFoundation

struct WhistleView: View {
    @StateObject private var whistleManager = WhistleManager()
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                Button(action: {
                    whistleManager.playSound()
                }) {
                    Image("whistleImg")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .buttonStyle(BorderedButtonStyle())
                }
                .buttonStyle(.plain)
                
                Slider(value: $whistleManager.volume, in: 0...10, step: 1)
                    .tint(.green)
            }
            .padding(5)
        }
        .padding([.leading, .trailing], 10)
        .onAppear {
            whistleManager.setupAudioPlayer()
        }
        .onDisappear {
            whistleManager.cancelSubscriptions()
        }
    }
}

class WhistleManager: ObservableObject {
    @Published var volume: Float = 5
    
    private var player: AVAudioPlayer?
    private var volumeCancellable: AnyCancellable?
    
    func setupAudioPlayer() {
        guard let url = Bundle.main.url(forResource: "whistleSound", withExtension: "mp3") else {
            print("No audio file")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.volume = volume
        } catch {
            print("Cannot create audio player: \(error)")
        }
        
        setupVolumePublisher()
    }
    
    func playSound() {
        guard let player = player else { return }
        
        if player.isPlaying {
            player.stop()
            player.currentTime = 0
        }
        
        player.play()
    }
    
    private func setupVolumePublisher() {
        volumeCancellable = $volume
            .sink { [weak self] newVolume in
                self?.player?.volume = newVolume
            }
    }
    
    func cancelSubscriptions() {
        volumeCancellable?.cancel()
    }
}
