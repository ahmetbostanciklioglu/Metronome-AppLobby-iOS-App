//
//  SwiftUISlider.swift
//  lobby
//
//  Created by Ahmet Bostancıklıoğlu on 18.08.2024.
//


import Foundation
import SwiftUI

struct SwiftUISlider: UIViewRepresentable {

    class Coordinator: NSObject {
        var value: Binding<Double>

        init(value: Binding<Double>) {
            self.value = value
        }

        @objc func valueChanged(_ sender: UISlider) {
            value.wrappedValue = Double(sender.value)
        }
    }

    var thumbColor: UIColor = .white
    var minTrackColor: UIColor?
    var maxTrackColor: UIColor?
    @Binding var value: Double

    func makeUIView(context: Context) -> UISlider {
        let slider = UISlider()
        configureSlider(slider)
        slider.value = Float(value)
        slider.addTarget(
            context.coordinator,
            action: #selector(Coordinator.valueChanged(_:)),
            for: .valueChanged
        )
        return slider
    }

    func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.value = Float(value)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(value: $value)
    }

    private func configureSlider(_ slider: UISlider) {
        slider.thumbTintColor = thumbColor
        slider.minimumTrackTintColor = minTrackColor
        slider.maximumTrackTintColor = maxTrackColor
        slider.minimumValue = 35
        slider.maximumValue = 200
    }
}

