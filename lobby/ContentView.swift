//
//  ContentView.swift
//  lobby
//
//  Created by Ahmet Bostancıklıoğlu on 18.08.2024.
//

import SwiftUI
import AVFoundation

extension Color {
    static let backgroundGradientTopPart = Color(
        red: 0.2,
        green: 0.5,
        blue: 0.7
    )
    static let backgroundGradientBottomPart = Color.purple
}



struct ContentView: View {
    // State variable to hold the slider value
    @State var bpmValue: Int = 50
    @State private var isBottomSheetPresented = false
    @State private var playButtonImage: Bool = true
    @State private var selectedContent : BottomSheetContent = .subdivision
   
    @State private var beats: Int = 1
    @State private var timer: Timer?
    
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPlaying: Bool = false
    @State private var isMuted = false
    @State private var blink = false
    @State private var blinkTimer: Timer?
    @State private var blinkLevel = 0
    
    var beatsDivision : String  {
        "\(beats)/\(subdivision)"
    }
    
    var subdivisionInterval: Double {
        let beatInterval = 60.0 / Double(bpmValue)
        return beatInterval / Double(subdivision)
    }

    @State private var subdivision: Int = 1 {
        didSet {
            if isPlaying {
                stopSound() // Mevcut timer'ları ve sesi durdur
                startBlinkEffect() // Blink efektini yeniden başlat
                start() // Timer ve sesi yeniden başlat
            }
        }
    }
    
    @State private var selectedSound: String = "TAP" {
        didSet {
            if isPlaying {
                stopSound() // Mevcut sesi ve timer'ı durdur
                start() // Yeni sesle timer'ı ve sesi yeniden başlat
            }
        }
    }
    
    
    var body: some View {
        
        ZStack {
            VStack {
                
                Text(
                    "METRONOME"
                )
                .fontWeight(
                    .semibold
                )
                .font(
                    .title
                )
                .fontDesign(
                    .monospaced
                )
                .foregroundColor(
                    .white
                )
                .padding(
                    .top,
                    72
                )
                
                
                Text(
                    getTempoRangeText(tempo: bpmValue)
                )
                .fontWeight(
                    .semibold
                )
                .font(
                    .title
                )
                .foregroundColor(
                    .white
                )
                .padding(
                    .vertical,
                    40
                )
                
                Text("\(Int(bpmValue))")
                .fontWeight(
                    .bold
                )
                .font(
                    .largeTitle
                )
                .foregroundColor(
                    .white
                )
                .padding(
                    .vertical,
                    20
                )
                
                Text(
                    "BPM"
                )
                .fontWeight(
                    .bold
                )
                .font(
                    .title3
                )
                .fontDesign(
                    .rounded
                )
                .foregroundColor(
                    .white
                )
                .padding(
                    .vertical,
                    12
                )
                
                SwiftUISlider(
                    thumbColor: UIColor(
                        red: 199/255,
                        green: 190/255,
                        blue: 250/255,
                        alpha: 1.0
                    ),
                    minTrackColor: UIColor(
                        red: 101/255,
                        green: 59/255,
                        blue: 182/255,
                        alpha: 1.0
                    ),
                    maxTrackColor: .white,
                    value: Binding(get: {
                        Double(
                            self.bpmValue
                        )
                    },
                                   set: { newValue in
                                       
                                       self.bpmValue = Int(
                                        newValue
                                       )
                                       if isPlaying {
                                           start()  // Eğer oynatma durumu aktifse, timer'ı yeniden başlat
                                       }
                                   })
                ).padding(
                    .horizontal,
                    40
                )
                .padding(
                    .vertical,
                    30
                )
                
                
                
                
                Button(action: {
                    isPlaying.toggle()
                    isPlaying ? start() : stopSound()
                  
                    
                    
                },
                       label: {
                    Image(
                        systemName: isPlaying ?  "pause.fill" : "play.fill"
                    )
                    .resizable()
                    .frame(
                        width: 32,
                        height: 32,
                        alignment: .center
                    )
                    .foregroundColor(
                        Color(
                            uiColor: UIColor(
                                red: 137/255,
                                green: 96/255,
                                blue: 221/255,
                                alpha: 1.0
                            )
                        )
                    )
                    .padding(
                        .leading,
                        6
                    )
                    .frame(
                        maxWidth: .infinity,
                        maxHeight: .infinity
                    )
                })
                .frame(
                    width: 50,
                    height: 50,
                    alignment: .center
                )
                .padding()
                .background(
                    Color.white
                )
                .foregroundColor(
                    .white
                )
                .cornerRadius(
                    40
                )
                
                Spacer()
                    .frame(
                        height: 20
                    )
                
                HStack {
                    
                    ForEach(
                        0..<beats,
                        id: \.self
                    ) { index in
                        Circle()
                            .fill(
                                Color.white
                            )
                            .frame(
                                width: 24,
                                height: 24
                            )
                            .opacity(isPlaying ? (index == blinkLevel ?  getOpacityForSubdivision() : 1.0) : 1.0)
                                      .animation(.easeInOut(duration: subdivisionInterval), value: blink)
                        
                        // Add a Spacer between circles, but not after the last one
                        if index < beats - 1 {
                            Spacer()
                        }
                    }
                    
                }
                .frame(
                    maxWidth: .infinity,
                    maxHeight: .infinity,
                    alignment: .top
                )
                .padding(
                    .top,
                    30
                )
                .padding(
                    .horizontal,
                    60
                )
                
                Spacer()
                BottomBarView(
                    isBottomSheetPresented: $isBottomSheetPresented,
                    selectedContent: $selectedContent,
                    beatsDivision: .constant(
                        beatsDivision
                    ),
                    audioPlayer: $audioPlayer,
                    isMuted : $isMuted
                ) // Add the bottom bar
                .padding(
                    .bottom,
                    20
                )
                .frame(
                    height: 100
                )
                
            }
            .frame(
                maxWidth: .infinity,
                maxHeight: .infinity,
                alignment: .top
            )
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
                    startPoint: .top,
                    endPoint: .bottomTrailing
                )
            )
            .edgesIgnoringSafeArea(
                .all
            )
            
            
            if isBottomSheetPresented {
                BottomSheetView(
                    isPresented: $isBottomSheetPresented,
                    maxHeight: 370
                ) {
                    VStack(
                        alignment: .center
                    ) {
                        Spacer().frame(
                            height: 12
                        )
                        switch selectedContent {
                        case .subdivision:
                            Text(
                                "CHANGE METER"
                            )
                            .font(
                                .system(
                                    size: 28
                                )
                            )
                            .fontWeight(
                                .semibold
                            )
                            .padding()
                            .foregroundColor(
                                Color(
                                    UIColor(
                                        red: 123/255,
                                        green: 89/255,
                                        blue: 201/255,
                                        alpha: 1.0
                                    )
                                )
                            )
                            
                            Spacer()
                                .frame(
                                    height: 30
                                )
                                .frame(
                                    minHeight: 45
                                )
                            HStack(alignment: .center,
                                   spacing: 40,
                                   content: {
                                Spacer()
                                VStack(
                                    spacing: 4
                                ) {
                                    Button(
                                        "+"
                                    ) {
                                        if self.beats < 4 {
                                            self.beats += 1
                                        }
                                    }
                                    .font(
                                        .system(
                                            size: 32
                                        )
                                    )
                                    .padding(
                                        .horizontal
                                    )
                                    .fontWeight(
                                        .medium
                                    )
                                    .padding(
                                        .all,
                                        8
                                    )
                                    .background(
                                        Color.white
                                    )
                                    .foregroundColor(
                                        Color(
                                            UIColor(
                                                red: 130/255,
                                                green: 89/255,
                                                blue: 221/255,
                                                alpha: 1.0
                                            )
                                        )
                                    )
                                    .cornerRadius(
                                        10
                                    )
                                    
                                    Spacer()
                                        .frame(
                                            height: 2
                                        )
                                    Text(
                                        "\(self.beats)"
                                    )
                                    .font(
                                        .largeTitle
                                    )
                                    .foregroundColor(
                                        Color(
                                            UIColor(
                                                red: 127/255,
                                                green: 85/255,
                                                blue: 215/255,
                                                alpha: 1.0
                                            )
                                        )
                                    )
                                    Spacer()
                                        .frame(
                                            height: 2
                                        )
                                    Button(
                                        "-"
                                    ) {
                                        if self.beats > 1 {
                                            self.beats -= 1
                                            
                                        }
                                    }
                                    .font(
                                        .system(
                                            size: 32
                                        )
                                    )
                                    .padding(
                                        .horizontal
                                    )
                                    .fontWeight(
                                        .medium
                                    )
                                    .padding(
                                        .all,
                                        10
                                    )
                                    .background(
                                        Color.white
                                    )
                                    .foregroundColor(
                                        Color(
                                            UIColor(
                                                red: 130/255,
                                                green: 89/255,
                                                blue: 221/255,
                                                alpha: 1.0
                                            )
                                        )
                                    )
                                    .cornerRadius(
                                        10
                                    )
                                }
                                .padding(
                                    .all,
                                    4
                                ) // Etrafına boşluk ekliyor
                                .background(
                                    Color(
                                        UIColor(
                                            red: 239/255,
                                            green: 229/255,
                                            blue: 254/255,
                                            alpha: 1.0
                                        )
                                    )
                                )
                                .cornerRadius(
                                    10
                                ) // Beyaz arka planın köşelerini yuvarlatmak için
                                .shadow(
                                    radius: 5
                                ) // İsteğe bağlı olarak gölge ekleyebilirsiniz
                                .frame(
                                    width: 90,
                                    height: 40
                                )
                                
                                
                                Text(
                                    "/"
                                )
                                .font(
                                    .largeTitle
                                )
                                .foregroundColor(
                                    Color(
                                        UIColor(
                                            red: 127/255,
                                            green: 85/255,
                                            blue: 215/255,
                                            alpha: 1.0
                                        )
                                    )
                                )
                                
                                VStack(
                                    spacing: 4
                                ) {
                                    Button(
                                        "+"
                                    ) {
                                        if self.subdivision < 4 {
                                            self.subdivision += 1
                                        }
                                    }
                                    .font(
                                        .system(
                                            size: 32
                                        )
                                    )
                                    .padding(
                                        .horizontal
                                    )
                                    .fontWeight(
                                        .medium
                                    )
                                    .padding(
                                        .all,
                                        8
                                    )
                                    .background(
                                        Color.white
                                    )
                                    .foregroundColor(
                                        Color(
                                            UIColor(
                                                red: 130/255,
                                                green: 89/255,
                                                blue: 221/255,
                                                alpha: 1.0
                                            )
                                        )
                                    )
                                    .cornerRadius(
                                        10
                                    )
                                    
                                    Spacer()
                                        .frame(
                                            height: 2
                                        )
                                    Text(
                                        "\(self.subdivision)"
                                    )
                                    .font(
                                        .largeTitle
                                    )
                                    .foregroundColor(
                                        Color(
                                            UIColor(
                                                red: 127/255,
                                                green: 85/255,
                                                blue: 215/255,
                                                alpha: 1.0
                                            )
                                        )
                                    )
                                    Spacer()
                                        .frame(
                                            height: 2
                                        )
                                    Button(
                                        "-"
                                    ) {
                                        if self.subdivision > 1 {
                                            self.subdivision -= 1
                                            
                                        }
                                    }
                                    .font(
                                        .system(
                                            size: 32
                                        )
                                    )
                                    .padding(
                                        .horizontal
                                    )
                                    .fontWeight(
                                        .medium
                                    )
                                    .padding(
                                        .all,
                                        10
                                    )
                                    .background(
                                        Color.white
                                    )
                                    .foregroundColor(
                                        Color(
                                            UIColor(
                                                red: 130/255,
                                                green: 89/255,
                                                blue: 221/255,
                                                alpha: 1.0
                                            )
                                        )
                                    )
                                    .cornerRadius(
                                        10
                                    )
                                }
                                .padding(
                                    .all,
                                    4
                                ) // Etrafına boşluk ekliyor
                                .background(
                                    Color(
                                        UIColor(
                                            red: 239/255,
                                            green: 229/255,
                                            blue: 254/255,
                                            alpha: 1.0
                                        )
                                    )
                                )
                                .cornerRadius(
                                    10
                                ) // Beyaz arka planın köşelerini yuvarlatmak için
                                .shadow(
                                    radius: 5
                                ) // İsteğe bağlı olarak gölge ekleyebilirsiniz
                                .frame(
                                    width: 90,
                                    height: 40
                                )
                                
                                Spacer()
                            }
                            )
                            
                            Spacer()
                                .frame(
                                    height: 100
                                )
                            
                            Button(action: {
                                self.isBottomSheetPresented.toggle()
                            },
                                   label: {
                                Text(
                                    "SAVE"
                                )
                                .font(
                                    .title2
                                )
                                .fontWeight(
                                    .medium
                                )
                                .foregroundColor(
                                    .white
                                )
                                .frame(
                                    maxWidth: .infinity,
                                    maxHeight: 60
                                )
                                .padding(
                                    .vertical
                                )
                            })
                            .background(
                                Color(
                                    UIColor(
                                        red: 131/255,
                                        green: 90/255,
                                        blue: 222/255,
                                        alpha: 1.0
                                    )
                                )
                            )
                            .frame(
                                maxWidth: .infinity,
                                maxHeight: 60
                            ) // Fill all width and set height to 40
                            .cornerRadius(
                                30
                            ) // Optional: Rounded corners
                            .padding(
                                .horizontal
                            ) // Optional: Add padding to the sides
                            
                            Spacer()
                                .frame(
                                    height: 60
                                )
                        case .sound:
                            VStack(
                                spacing: 10
                            ) {
                                Text(
                                    "CHANGE SOUND"
                                )
                                .font(
                                    .title
                                )
                                .fontWeight(
                                    .bold
                                )
                                .foregroundColor(
                                    Color(
                                        UIColor(
                                            red: 123/255,
                                            green: 89/255,
                                            blue: 201/255,
                                            alpha: 1.0
                                        )
                                    ).opacity(
                                        0.7
                                    )
                                )
                                
                                Spacer().frame(
                                    height: 12
                                )
                                HStack(
                                    alignment: .top,
                                    spacing: 20
                                ) {
                                    SoundButton(
                                        title: "TAP",
                                        isSelected: selectedSound == "TAP"
                                    ) {
                                        selectedSound = "TAP"
                                    }
                                    SoundButton(
                                        title: "CLICK",
                                        isSelected: selectedSound == "CLICK"
                                    ) {
                                        selectedSound = "CLICK"
                                    }
                                }
                                
                                HStack(
                                    spacing: 20
                                ) {
                                    SoundButton(
                                        title: "CLAP",
                                        isSelected: selectedSound == "CLAP"
                                    ) {
                                        selectedSound = "CLAP"
                                    }
                                    SoundButton(
                                        title: "BEEP",
                                        isSelected: selectedSound == "BEEP"
                                    ) {
                                        selectedSound = "BEEP"
                                    }
                                }
                                
                                Spacer()
                                    .frame(
                                        height: 16
                                    )
                                
                                Button(action: {
                                    self.isBottomSheetPresented.toggle()
                                },
                                       label: {
                                    Text(
                                        "SAVE"
                                    )
                                    .font(
                                        .title2
                                    )
                                    .fontWeight(
                                        .medium
                                    )
                                    .foregroundColor(
                                        .white
                                    )
                                    .frame(
                                        maxWidth: .infinity,
                                        maxHeight: 60
                                    )
                                    .padding(
                                        .vertical
                                    )
                                })
                                .background(
                                    Color(
                                        UIColor(
                                            red: 131/255,
                                            green: 90/255,
                                            blue: 222/255,
                                            alpha: 1.0
                                        )
                                    )
                                )
                                .frame(
                                    maxWidth: .infinity,
                                    maxHeight: 60
                                ) // Fill all width and set height to 40
                                .cornerRadius(
                                    30
                                ) // Optional: Rounded corners
                                .padding(
                                    .horizontal,
                                    10
                                ) // Optional: Add padding to the sides
                                
                                Spacer()
                                
                                
                            }
                            .padding()
                            
                            .cornerRadius(
                                20
                            )
                            .shadow(
                                radius: 5
                            )
                            
                        }
                        
                    }
                }
                .transition(
                    .move(
                        edge: .bottom
                    )
                )
                .background(
                    Color(
                        UIColor(
                            red: 152/255,
                            green: 134/255,
                            blue: 246/255,
                            alpha: 1.0
                        )
                    )
                )
                .frame(
                    alignment: .top
                )
            }
            
        }
        
    }
    
    
    func getOpacityForSubdivision() -> Double {
        return blink ? 0.2 : 1.0
    }
    
    
    
    func playSelectedSound() {
        var soundFileName = ""
        
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
        
        
        if let path = Bundle.main.path(
            forResource: soundFileName,
            ofType: "mp3"
        ) {
            do {
                audioPlayer = try AVAudioPlayer(
                    contentsOf: URL(
                        fileURLWithPath: path
                    )
                )
                // Loop indefinitely
                audioPlayer?.prepareToPlay()
                
                audioPlayer?.volume = isMuted ? 0.0 : 1.0
            } catch {
                print(
                    "Error: Could not find and play the sound file."
                )
            }
        }
        
    }
    
    func start() {
        
        stopSound()  // Mevcut timer'ı durdur
        playSelectedSound()  // Ses dosyasını yükle
    
        
        startBlinkEffect()  // Blink efektini başlat
        
        isPlaying = true
        timer = Timer.scheduledTimer(
            withTimeInterval: 2 * 60.0 / Double(bpmValue * subdivision ) ,
            repeats: true
        ) { _ in
            self.playSound()
        }
        
        audioPlayer?.volume = isMuted ? 0.0 : 1.0
    }
    
    func startBlinkEffect() {
        
         blinkLevel = 0
         blinkTimer?.invalidate()

        let blinkInterval: Double = 60.0 / Double(bpmValue)
        let animationDuration: Double = blinkInterval
   
        blinkTimer = Timer.scheduledTimer(withTimeInterval: blinkInterval, repeats: true) { _ in
              withAnimation(.easeOut(duration: animationDuration)) {
                        // Blink'i güncelle
                  self.blink.toggle()
                  
                  if self.blink {
                      if self.subdivision > 1 {
                          self.playSoundIfNeeded()
                      }
                  } else {
                           // blink efektinin ilerlemesini kontrol edin
                           self.blinkLevel = (self.blinkLevel + 1) % self.beats
                  }

              }
          }
        
    }

    private func playSoundIfNeeded() {
        if subdivision == 3 {
            // Subdivision 3 iken sadece 3 defa ses ver
            if blinkLevel < 3 {
                self.playSound()
            }
        } else {
            // Diğer subdivision'lar için normal ses çalma mantığı
            self.playSound()
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
        audioPlayer?.currentTime = 0 // Sesi başa sarar
        audioPlayer?.play()
    
    }
    
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
            default :
                return "Presto"
            }
        }
}

#Preview {
    ContentView()
}
