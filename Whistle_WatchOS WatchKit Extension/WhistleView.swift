//
//  WhistleView.swift
//  Whistle_WatchOS WatchKit Extension
//
//  Created by 강민지 on 11/7/24.
//

import SwiftUI
import AVFoundation

struct WhistleView: View {
    @State private var volume: Float = 0.0
    @State private var player: AVAudioPlayer? = AVAudioPlayer()
    
    var body: some View {
        ScrollView(.vertical) {
            Button(action: {
                player?.play()
            }) {
                Image("whistleImg")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .listRowInsets(EdgeInsets())
            }
            
            Slider(value: $volume, in: 0...10, step: 1)
                .onChange(of: volume) { newValue in
                    player?.volume = newValue
                }
            .tint(.green)
        }
        .padding(.top, -25)
        .onAppear {
            setupAudioPlayer()
        }
    }
    
    func setupAudioPlayer() {
        guard let url = Bundle.main.url(forResource: "whistleSound", withExtension: "wav") else {
            print("no audio file")
            return
        }
        
        do {
            player = try AVAudioPlayer(contentsOf: url)
            player?.volume = volume
        } catch {
            print("cannot create audio player", error)
        }
    }
    
    func playSound() {
        guard let player = player else { return }
        
        if player.isPlaying {
            player.stop()
            player.currentTime = 0
        }
        
        player.play()
    }
}
