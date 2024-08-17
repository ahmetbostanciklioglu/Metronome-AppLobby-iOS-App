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
    @Binding var beatsDivision : String // Add a binding for the beats/division value
    @Binding var audioPlayer: AVAudioPlayer?
    @Binding var isMuted : Bool
    
    var body: some View {
        HStack {
            Spacer()
            Button(action: {
                self.selectedContent = .subdivision
                self.isBottomSheetPresented.toggle()
            }) {
                    Text(beatsDivision)
                        .font(.headline)
                        .foregroundColor(.white)
            }
            Spacer()
            Spacer()
                .frame(width: 20)
            
            Button(action: {
                self.selectedContent = .sound
                self.isBottomSheetPresented.toggle()
            }) {
               
                    Image(systemName: "music.note")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 16, height: 20)
                
            }
            Spacer()
            Spacer()
                .frame(width: 20)
            Button(action: {
                toggleMute()
            }) {
                    Image(systemName: isMuted ? "speaker.slash.fill" : "speaker.wave.2.fill")
                        .resizable()
                        .foregroundColor(.white)
                        .frame(width: 20, height: 20, alignment: .center)
            }
            Spacer()
        }
        .padding()
        .background(
            LinearGradient(
                gradient: Gradient(
                    colors:[
                        Color(
                            UIColor(
                                red: 152/255,
                                green: 134/255,
                                blue: 246/255,
                                alpha: 1.0
                            )
                        ),
                        Color(
                            UIColor(
                                red: 112/255,
                                green: 74/255,
                                blue: 197/255,
                                alpha: 1.0
                            )
                        )
                    ]
                ),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
        .cornerRadius(12)
        .shadow(radius: 5)
        .frame(height: 100)
        
    }
    
    func toggleMute() {
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


