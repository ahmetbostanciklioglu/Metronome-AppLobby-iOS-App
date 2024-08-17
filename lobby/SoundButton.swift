//
//  SoundButton.swift
//  lobby
//
//  Created by Ahmet Bostancıklıoğlu on 18.08.2024.
//



import Foundation
import SwiftUI

struct SoundButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(buttonBackgroundColor)
                .cornerRadius(10)
        }
        .padding(.horizontal, 10)
    }
    
    private var buttonBackgroundColor: Color {
        isSelected ? Color(red: 130/255, green: 89/255, blue: 221/255) :
                     Color(red: 176/255, green: 141/255, blue: 235/255)
    }
}

