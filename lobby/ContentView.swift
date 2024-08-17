//
//  ContentView.swift
//  lobby
//
//  Created by Ahmet Bostancıklıoğlu on 18.08.2024.
//

import Foundation
import SwiftUI
import AVFoundation


// Helper function to get Tempo Range Text
func getTempoRangeText(tempo: Int) -> String {
    switch tempo {
    case 35..<60:
        return "Largo"
    case  60..<66:
        return "Larghetto"
    case 66..<76:
        return "Adagio"
    case 76..<108:
        return "Andante"
    case 108..<120:
        return "Moderate"
    case  120..<168:
        return "Allegro"
    case 168..<200:
        return "Presto"
    default:
        return "Presto"
    }
}



struct ContentView: View {
    
    // State variables
    @State var bpmValue: Int = 50
    @State private var isBottomSheetPresented = false
    @State private var playButtonImage: Bool = true
    @State private var selectedContent: BottomSheetContent = .subdivision
    @State private var beats: Int = 1
    @State private var timer: Timer?
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPlaying: Bool = false
    @State private var isMuted = false
    @State private var blink = false
    @State private var blinkTimer: Timer?
    @State private var blinkLevel = 0
    @State private var subdivision: Int = 1 {
        didSet {
            if isPlaying {
                restart()
            }
        }
    }
    @State private var selectedSound: String = "TAP" {
        didSet {
            if isPlaying {
                restart()
            }
        }
    }
    
    var beatsDivision: String {
        "\(beats)/\(subdivision)"
    }
    
    var subdivisionInterval: Double {
        let beatInterval = 60.0 / Double(
            bpmValue
        )
        return beatInterval / Double(
            subdivision
        )
    }
    
    
    var body: some View {
       ZStack {
           VStack {
               titleView
               bpmDisplayView
               sliderView
               playButtonView
               blinkCirclesView
               bottomBarView
           }
           .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
           .background(backgroundGradient)
           .edgesIgnoringSafeArea(.all)
           
           if isBottomSheetPresented {
               bottomSheetView
           }
       }
    }

}

// MARK: - Subviews
extension ContentView {
    private var titleView: some View {
        Text("METRONOME")
            .fontWeight(.semibold)
            .font(.title)
            .fontDesign(.monospaced)
            .foregroundColor(.white)
            .padding(.top, 72)
    }

    private var bpmDisplayView: some View {
        VStack {
            Text(getTempoRangeText(tempo: bpmValue))
                .fontWeight(.semibold)
                .font(.title)
                .foregroundColor(.white)
                .padding(.vertical, 40)
            
            Text("\(Int(bpmValue))")
                .fontWeight(.bold)
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(.vertical, 20)
            
            Text("BPM")
                .fontWeight(.bold)
                .font(.title3)
                .fontDesign(.rounded)
                .foregroundColor(.white)
                .padding(.vertical, 12)
        }
    }

    private var sliderView: some View {
        SwiftUISlider(
            thumbColor: UIColor(red: 199/255, green: 190/255, blue: 250/255, alpha: 1.0),
            minTrackColor: UIColor(red: 101/255, green: 59/255, blue: 182/255, alpha: 1.0),
            maxTrackColor: .white,
            value: Binding(get: {
                Double(bpmValue)
            }, set: { newValue in
                bpmValue = Int(newValue)
                if isPlaying {
                    start()
                }
            })
        )
        .padding(.horizontal, 40)
        .padding(.vertical, 30)
    }

    private var playButtonView: some View {
        Button(action: togglePlay) {
            Image(systemName: isPlaying ? "pause.fill" : "play.fill")
                .resizable()
                .frame(width: 32, height: 32, alignment: .center)
                .foregroundColor(Color(uiColor: UIColor(red: 137/255, green: 96/255, blue: 221/255, alpha: 1.0)))
                .padding(.leading, 6)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(width: 50, height: 50, alignment: .center)
        .padding()
        .background(Color.white)
        .cornerRadius(40)
    }

    private var blinkCirclesView: some View {
        HStack {
            ForEach(0..<beats, id: \.self) { index in
                Circle()
                    .fill(Color.white)
                    .frame(width: 24, height: 24)
                    .opacity(isPlaying ? (index == blinkLevel ? getOpacityForSubdivision() : 1.0) : 1.0)
                    .animation(.easeInOut(duration: subdivisionInterval), value: blink)
                if index < beats - 1 {
                    Spacer()
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .padding(.top, 30)
        .padding(.horizontal, 60)
    }

    private var bottomBarView: some View {
        BottomBarView(
            isBottomSheetPresented: $isBottomSheetPresented,
            selectedContent: $selectedContent,
            beatsDivision: .constant(beatsDivision),
            audioPlayer: $audioPlayer,
            isMuted: $isMuted
        )
        .padding(.bottom, 20)
        .frame(height: 100)
    }

    private var bottomSheetView: some View {
        BottomSheetView(
            isPresented: $isBottomSheetPresented,
            maxHeight: 370
        ) {
            VStack(alignment: .center) {
                Spacer().frame(height: 12)
                switch selectedContent {
                case .subdivision:
                    subdivisionView
                case .sound:
                    soundView
                }
            }
        }
        .transition(.move(edge: .bottom))
        .background(Color(red: 152/255, green: 134/255, blue: 246/255))
        .frame(alignment: .top)
    }

    private var subdivisionView: some View {
        VStack(spacing: 20) {
            Spacer().frame(height: 30)
            Text("CHANGE METER")
                .font(.system(size: 28))
                .fontWeight(.semibold)
                .padding()
                .foregroundColor(Color(red: 123/255, green: 89/255, blue: 201/255))
            Spacer().frame(height: 30)
            HStack(alignment: .center, spacing: 40) {
                stepperView(title: "\(beats)", increment: { if beats < 4 { beats += 1 } }, decrement: { if beats > 1 { beats -= 1 } })
                Text("/")
                    .font(.largeTitle)
                    .foregroundColor(Color(red: 127/255, green: 85/255, blue: 215/255))
                stepperView(title: "\(subdivision)", increment: { if subdivision < 4 { subdivision += 1 } }, decrement: { if subdivision > 1 { subdivision -= 1 } })
            }
            Spacer().frame(height: 50)
            saveButton(action: { isBottomSheetPresented.toggle() })
            Spacer().frame(height: 60)
        }
    }

    private var soundView: some View {
        VStack(spacing: 10) {
            Spacer().frame(height: 8)
            Text("CHANGE SOUND")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(Color(red: 123/255, green: 89/255, blue: 201/255).opacity(0.7))
            Spacer().frame(height: 12)
            HStack(alignment: .top, spacing: 20) {
                SoundButton(title: "TAP", isSelected: selectedSound == "TAP") { selectedSound = "TAP" }
                SoundButton(title: "CLICK", isSelected: selectedSound == "CLICK") { selectedSound = "CLICK" }
            }
            HStack(spacing: 20) {
                SoundButton(title: "CLAP", isSelected: selectedSound == "CLAP") { selectedSound = "CLAP" }
                SoundButton(title: "BEEP", isSelected: selectedSound == "BEEP") { selectedSound = "BEEP" }
            }
            Spacer().frame(height: 16)
            saveButton(action: { isBottomSheetPresented.toggle() }).frame(maxHeight: 45)
            Spacer()
        }
        .padding()
        .cornerRadius(20)
        .shadow(radius: 5)
    }

    private var backgroundGradient: LinearGradient {
        LinearGradient(
            gradient: Gradient(colors: [
                Color(UIColor(red: 152/255, green: 134/255, blue: 246/255, alpha: 1.0)),
                Color(UIColor(red: 112/255, green: 74/255, blue: 197/255, alpha: 1.0))
            ]),
            startPoint: .top,
            endPoint: .bottomTrailing
        )
    }
}

// MARK: - Reusable Components
extension ContentView {
    private func stepperView(title: String, increment: @escaping () -> Void, decrement: @escaping () -> Void) -> some View {
        VStack(spacing: 4) {
            Button(action: increment) {
                Text("+")
                    .font(.system(size: 32))
                    .padding(.all, 8)
                    .background(Color.white)
                    .foregroundColor(Color(uiColor: UIColor(red: 130/255, green: 89/255, blue: 221/255, alpha: 1.0)))
                    .cornerRadius(10)
            }
            Spacer().frame(height: 2)
            Text(title)
                .font(.largeTitle)
                .foregroundColor(Color(uiColor: UIColor(red: 127/255, green: 85/255, blue: 215/255, alpha: 1.0)))
            Spacer().frame(height: 2)
            Button(action: decrement) {
                Text("-")
                    .font(.system(size: 32))
                    .padding(.all, 10)
                    .background(Color.white)
                    .foregroundColor(Color(red: 130/255, green: 89/255, blue: 221/255))
                    .cornerRadius(10)
            }
        }
        .padding(.all, 4)
        .background(Color(red: 239/255, green: 229/255, blue: 254/255))
        .cornerRadius(10)
        .shadow(radius: 5)
        .frame(width: 90, height: 40)
    }

    private func saveButton(action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text("SAVE")
                .font(.title2)
                .fontWeight(.medium)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity, maxHeight: 60)
                .padding(.vertical)
        }
        .background(Color(red: 131/255, green: 90/255, blue: 222/255))
        .cornerRadius(30)
        .padding(.horizontal)
    }
}

// MARK: - Metronome Logic
extension ContentView {
    func togglePlay() {
        isPlaying.toggle()
        isPlaying ? start() : stopSound()
    }

    func getOpacityForSubdivision() -> Double {
        return blink ? 0.2 : 1.0
    }

    func playSelectedSound() {
        let soundFileName: String
        
        switch selectedSound {
        case "CLAP":
            soundFileName = "clap"
        case "TAP":
            soundFileName = "tap"
        case "CLICK":
            soundFileName = "click"
        case "BEEP":
            soundFileName = "beep"
        default:
            return
        }

        if let path = Bundle.main.path(forResource: soundFileName, ofType: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                audioPlayer?.prepareToPlay()
                audioPlayer?.volume = isMuted ? 0.0 : 1.0
            } catch {
                print("Error: Could not find and play the sound file.")
            }
        }
    }

    func start() {
        stopSound()
        playSelectedSound()
        startBlinkEffect()
        isPlaying = true
        timer = Timer.scheduledTimer(withTimeInterval: 2 * 60.0 / Double(bpmValue * subdivision), repeats: true) { _ in
            playSound()
        }
        audioPlayer?.volume = isMuted ? 0.0 : 1.0
    }

    func startBlinkEffect() {
        blinkLevel = 0
        blinkTimer?.invalidate()
        let blinkInterval = 60.0 / Double(bpmValue)
        blinkTimer = Timer.scheduledTimer(withTimeInterval: blinkInterval, repeats: true) { _ in
            withAnimation(.easeOut(duration: blinkInterval)) {
                blink.toggle()
                if blink {
                    if subdivision > 1 {
                        playSoundIfNeeded()
                    }
                } else {
                    blinkLevel = (blinkLevel + 1) % beats
                }
            }
        }
    }

    private func playSoundIfNeeded() {
        if subdivision == 3 && blinkLevel < 3 {
            playSound()
        } else {
            playSound()
        }
    }

    func stopSound() {
        timer?.invalidate()
        timer = nil
        blinkTimer?.invalidate()
        blinkTimer = nil
        audioPlayer?.stop()
        blink = false
    }

    private func playSound() {
        audioPlayer?.currentTime = 0
        audioPlayer?.play()
    }

    private func restart() {
        stopSound()
        start()
    }
}
#Preview {
    ContentView()
}
