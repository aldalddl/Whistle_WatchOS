//
//  PageManager.swift
//  Whistle_WatchOS WatchKit Extension
//
//  Created by 강민지 on 11/7/24.
//

import SwiftUI

struct PageManager<Content: View>: View {
    let pageCount: Int
    @Binding var currentIndex: Int
    let content: Content

    init(pageCount: Int, currentIndex: Binding<Int>, @ViewBuilder content: () -> Content) {
        self.pageCount = pageCount
        self._currentIndex = currentIndex
        self.content = content()
    }
    
    @GestureState private var translation: CGFloat = 0

    var body: some View {
        GeometryReader { geometry in
            VStack {
                HStack(spacing: 0) {
                    self.content.frame(width: geometry.size.width)
                }
                .frame(width: geometry.size.width, alignment: .leading)
                .offset(x: -CGFloat(self.currentIndex) * geometry.size.width)
                .offset(x: self.translation)
                .gesture(
                    DragGesture().updating(self.$translation) { value, state, _ in
                        state = value.translation.width
                    }.onEnded { value in
                        let offset = value.translation.width / geometry.size.width
                        let newIndex = (CGFloat(self.currentIndex) - offset).rounded()
                        self.currentIndex = min(max(Int(newIndex), 0), self.pageCount - 1)
                    }
                )
                        
                Spacer()
                
                HStack{
                    ForEach(0..<pageCount, id: \.self) { index in
                        Circle()
                            .frame(width: 8, height: 8)
                            .foregroundColor(index == currentIndex ? Color.gray : Color.white)
                    }
                }
                .background(Color.clear)
                .overlay(.clear)
            }
        }
    }
}

