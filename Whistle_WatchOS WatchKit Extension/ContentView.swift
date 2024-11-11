//
//  ContentView.swift
//  Whistle_WatchOS WatchKit Extension
//
//  Created by 강민지 on 11/11/24.
//

import SwiftUI

struct ContentView: View {
    @State private var currentPage = 0
    
    var body: some View {
        
        VStack{
            PagerManager(pageCount: 2, currentIndex: $currentPage) {

            }
        }
        
    }
}
