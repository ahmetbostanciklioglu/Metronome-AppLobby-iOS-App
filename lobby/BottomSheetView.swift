//
//  BottomSheetView.swift
//  lobby
//
//  Created by Ahmet Bostancıklıoğlu on 18.08.2024.
//

import Foundation
import SwiftUI

struct BottomSheetView<Content: View>: View {
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
                
                content
                    .frame(width: geometry.size.width, height: maxHeight)
                    .background(
                        LinearGradient(
                            gradient: Gradient(colors:[
                                Color(red: 237/255, green: 227/255, blue: 253/255),
                                Color(red: 214/255, green: 184/255, blue: 247/255),
                                Color(red: 201/255, green: 156/255, blue: 241/255)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .cornerRadius(16)
                    .shadow(radius: 5)
                    .offset(y: offset)
                    .animation(.interactiveSpring(), value: isPresented)
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}
