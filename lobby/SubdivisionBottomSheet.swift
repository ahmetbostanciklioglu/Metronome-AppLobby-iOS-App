//
//  SubdivisionBottomSheet.swift
//  lobby
//
//  Created by Ahmet Bostancıklıoğlu on 18.08.2024.
//

import Foundation
import SwiftUI


struct SubdivisionBottomSheet<Content: View>: View {
    @Binding var isPresented: Bool
    let maxHeight: CGFloat
    let content: Content
    
    init(isPresented: Binding<Bool>, maxHeight: CGFloat, @ViewBuilder content: () -> Content) {
        self._isPresented = isPresented
        self.maxHeight = maxHeight
        self.content = content()
    }
    
    private var offset: CGFloat {
        isPresented ? 0 : maxHeight
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                self.content
                    .frame(width: geometry.size.width, height: self.maxHeight)
                    .background(Color.white)
                    .cornerRadius(16)
                    .shadow(radius: 5)
                    .offset(y: self.offset)
                    .animation(.interactiveSpring())
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

