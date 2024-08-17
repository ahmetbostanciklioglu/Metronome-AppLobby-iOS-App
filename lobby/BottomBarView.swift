//
//  BottomBarView.swift
//  lobby
//
//  Created by Ahmet Bostancıklıoğlu on 18.08.2024.
//
import Foundation
import SwiftUI
import AVFoundation

struct BottomBarView: View {
    
    @Binding var isBottomSheetPresented: Bool
    @Binding var selectedContent: BottomSheetContent
    @Binding var beatsDivision: String
    @Binding var audioPlayer: AVAudioPlayer?
    @Binding var isMuted: Bool
    
    var body: some View {
        HStack {
            Spacer()
            createButton(title: beatsDivision, action: {
                selectedContent = .subdivision
                isBottomSheetPresented.toggle()
            }).font(.headline).frame(width: 40)
            Spacer()
            createButton(imageName: "music.note", action: {
                selectedContent = .sound
                isBottomSheetPresented.toggle()
            })
            Spacer()
            createButton(imageName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill", action: toggleMute)
            Spacer()
        }
        .padding()
        .background(backgroundGradient)
        .cornerRadius(12)
        .shadow(radius: 5)
        .frame(height: 100)
    }
    
    private func toggleMute() {
        isMuted.toggle()
        audioPlayer?.volume = isMuted ? 0.0 : 1.0
    }
    
    private func createButton(title: String? = nil, imageName: String? = nil, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            if let title = title {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
            } else if let imageName = imageName {
                Image(systemName: imageName)
                    .resizable()
                    .foregroundColor(.white)
                    .frame(width: 20, height: 20)
            }
        }
    }
    
    private var backgroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(
                colors: [
                    Color(red: 152/255, green: 134/255, blue: 246/255),
                    Color(red: 112/255, green: 74/255, blue: 197/255)
                ]
            ),
            startPoint: .leading,
            endPoint: .trailing
        )
    }
}

