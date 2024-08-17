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
        Button(action: {
            action()
        }) {
            Text(title)
                .font(.headline)
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(isSelected ?  Color(UIColor(red: 130/255, green: 89/255, blue: 221/255, alpha: 1.0)) :  Color(UIColor(red: 176/255, green: 141/255, blue: 235/255, alpha: 1.0)))
                .cornerRadius(10)
        }
        .padding(.horizontal, 10)
    }
}

