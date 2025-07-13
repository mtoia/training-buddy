//
//  TrainingBuddyApp.swift
//  TrainingBuddy
//
//  Created by Matteo Toia on 10/07/25.
//

import SwiftUI
import AVFoundation

@main
struct TrainingBuddyApp: App {
    init() {
        configureAudioSession()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }

    func configureAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            print("🎧 AVAudioSession configurato per background playback")
        } catch {
            print("❌ Errore AVAudioSession: \(error.localizedDescription)")
        }
    }
}
