//
//  ContentView.swift
//  Whistle_WatchOS WatchKit Extension
//
//  Created by 강민지 on 11/7/24.
//

import SwiftUI

struct ContentView: View {
    @State private var currentPage = 0
    
    var body: some View {
        VStack{
            PageManager(pageCount: 2, currentIndex: $currentPage) {
                WhistleView()
                TimerView()
            }
        }
    }
}
