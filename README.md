<div align="center">

# 🎵 Metronome

**A clean, gradient-styled SwiftUI metronome with adjustable tempo, meter, and sounds.**

[![Platform](https://img.shields.io/badge/Platform-iOS-lightgrey?style=flat-square&logo=apple)](https://developer.apple.com/ios/)
[![Swift](https://img.shields.io/badge/Swift-5.0-orange?style=flat-square&logo=swift)](https://swift.org)
[![SwiftUI](https://img.shields.io/badge/SwiftUI-blue?style=flat-square&logo=swift)](https://developer.apple.com/xcode/swiftui/)
[![Xcode](https://img.shields.io/badge/Xcode-15+-147EFB?style=flat-square&logo=xcode)](https://developer.apple.com/xcode/)
[![Stars](https://img.shields.io/github/stars/ahmetbostanciklioglu/Metronome-AppLobby-iOS-App?style=flat-square&color=6E48AA)](https://github.com/ahmetbostanciklioglu/Metronome-AppLobby-iOS-App/stargazers)
[![Last Commit](https://img.shields.io/github/last-commit/ahmetbostanciklioglu/Metronome-AppLobby-iOS-App?style=flat-square&color=4776E6)](https://github.com/ahmetbostanciklioglu/Metronome-AppLobby-iOS-App/commits)

</div>

## 📖 Overview

Metronome is a native iOS app built entirely with SwiftUI that helps musicians keep time. Drag the slider to set the tempo and the app labels the range with its classical Italian marking (Largo, Andante, Allegro, Presto, and more). A play button drives an audio click alongside blinking beat indicators, and bottom sheets let you change the meter and pick from four different tick sounds. Audio playback is handled with `AVFoundation`.

## ✨ Features

- **Adjustable tempo** — a custom `UISlider`-backed control sets BPM, with a live label showing the matching tempo range (Largo → Presto).
- **Visual beat indicators** — pulsing circles blink in sync with each beat of the current meter.
- **Configurable meter** — a stepper sheet lets you set beats and subdivisions (up to 4/4).
- **Selectable sounds** — choose between TAP, CLICK, CLAP, and BEEP tick sounds.
- **Mute toggle** — silence the metronome while keeping the visual beat running.
- **Gradient UI** — a purple gradient theme with monospaced typography and rounded controls.

## 🚀 Getting Started

```bash
git clone https://github.com/ahmetbostanciklioglu/Metronome-AppLobby-iOS-App.git
cd Metronome-AppLobby-iOS-App
open lobby.xcodeproj
```

Then select a simulator or device in Xcode and press **⌘R** to build and run.

## 📋 Requirements

- iOS 17.5 or later
- Xcode 15 or later
- Swift 5.0

## 🧑‍💻 Author

**Ahmet Bostancıklıoğlu** — [@ahmetbostanciklioglu](https://github.com/ahmetbostanciklioglu) · ahmetbostancikli@gmail.com

> ⭐ If this helped you, consider giving the repo a star!
