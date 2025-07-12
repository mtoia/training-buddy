import SwiftUI
import AVFoundation

struct ContentView: View {
    @ObservedObject var settings = SettingsModel()
    
    @State private var countdown: Int = 0
    @State private var timer: Timer? = nil
    @State private var motivationIndex = 0
    @State private var motivationTimer: Timer? = nil
    @State private var path: [String] = []
    @State private var pulse = false
    @State private var animatePhrase = false
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPreCountdown = false
    @State private var preCountdownValue = 3
    @State private var preCountdownTimer: Timer? = nil

    let motivationalPhrases = [
        "Dai il massimo!",
        "Resisti!",
        "Ancora uno sforzo!",
        "Ce la puoi fare!",
        "Sii la tua miglior versione!",
        "Mantieni il ritmo!",
        "Non mollare adesso!",
        "Ogni secondo conta!",
        "La fatica è la tua forza!",
        "Vai come un treno!"
    ]
    
    enum SessionPhase {
        case idle, workout, rest
    }
    
    @State private var phase: SessionPhase = .idle
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 30) {
                
                if phase == .idle && !isPreCountdown {
                    Text("Training Buddy")
                        .font(.system(size: 34, weight: .bold, design: .rounded))
                        .padding(.top, 20)
                }

                Spacer().frame(height: 5)

                if isPreCountdown {
                    Spacer()
                    Text(preCountdownValue > 0 ? "\(preCountdownValue)" : "Via!")
                        .font(.system(size: 72, weight: .bold, design: .rounded))
                        .foregroundColor(.orange)
                        .transition(.scale)
                        .id(preCountdownValue)
                    Spacer()
                } else {
                    switch phase {
                    case .idle:
                        VStack(spacing: 25) {
                            Spacer().frame(height: 10)

                            Text("Ciao \(settings.userName),\npronto per iniziare?")
                                .font(.system(size: 28, weight: .semibold, design: .rounded))
                                .multilineTextAlignment(.center)

                            Button("Inizio") {
                                startPreCountdown()
                            }
                            .buttonStyle(CustomButtonStyle(bgColor: .orange))
                            .padding(.top, 10)

                            Toggle("Ciclo continuo", isOn: $settings.isLooping)
                                .padding(.horizontal)
                                .padding(.top, 10)

                            Toggle("Suoni", isOn: $settings.isSoundEnabled)
                                .padding(.horizontal)

                            Spacer()
                        }

                    case .workout:
                        VStack {
                            Spacer().frame(height: 20)

                            ZStack {
                                Text(motivationalPhrases[motivationIndex])
                                    .font(.system(size: 48, weight: .regular, design: .default))
                                    .italic()
                                    .foregroundColor(.black)
                                    .offset(x: 1.5, y: 1.5)

                                Text(motivationalPhrases[motivationIndex])
                                    .font(.system(size: 48, weight: .regular, design: .default))
                                    .italic()
                                    .foregroundColor(.orange)
                            }
                            .frame(height: 120)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .scaleEffect(animatePhrase ? 1.05 : 0.95)
                            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: animatePhrase)
                            .onAppear {
                                animatePhrase = true
                            }

                            Spacer().frame(height: 40)

                            Text("\(countdown) secondi")
                                .font(.system(size: 48, weight: .bold, design: .rounded))

                            Spacer()

                            Button("Interrompi") {
                                stopCountdown()
                            }
                            .buttonStyle(CustomButtonStyle(bgColor: .red))
                            .padding(.bottom, 30)
                        }

                    case .rest:
                        VStack {
                            Spacer().frame(height: 20)

                            ZStack {
                                Text("Molto bene \(settings.userName)!")
                                    .font(.system(size: 48, weight: .regular, design: .default))
                                    .italic()
                                    .foregroundColor(.black)
                                    .offset(x: 1.5, y: 1.5)

                                Text("Molto bene \(settings.userName)!")
                                    .font(.system(size: 48, weight: .regular, design: .default))
                                    .italic()
                                    .foregroundColor(.green)
                            }
                            .multilineTextAlignment(.center)
                            .padding(.horizontal)
                            .opacity((Date().timeIntervalSince1970.truncatingRemainder(dividingBy: 1)) > 0.5 ? 1 : 0.3)

                            Spacer().frame(height: 40)

                            Text("Riposo: \(countdown) secondi")
                                .font(.system(size: 48, weight: .bold, design: .rounded))

                            Spacer()

                            Button("Interrompi") {
                                stopCountdown()
                            }
                            .buttonStyle(CustomButtonStyle(bgColor: .red))
                            .padding(.bottom, 30)
                        }
                    }
                }
            }
            .padding(.top, 40)
            .padding(.horizontal)
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if phase == .idle && !isPreCountdown {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Menu {
                            Button("Impostazioni") {
                                path.append("settings")
                            }
                            Button("Info su Training Buddy") {
                                path.append("info")
                            }
                        } label: {
                            Image(systemName: "line.3.horizontal")
                                .imageScale(.large)
                                .padding(.trailing, 8)
                        }
                    }
                }
            }
            .navigationDestination(for: String.self) { value in
                switch value {
                case "settings":
                    SettingsView(settings: settings)
                case "info":
                    InfoView()
                default:
                    EmptyView()
                }
            }
        }
    }

    func stopCountdown() {
        timer?.invalidate()
        motivationTimer?.invalidate()
        timer = nil
        countdown = 0
        pulse = false
        animatePhrase = false
        isPreCountdown = false
        preCountdownTimer?.invalidate()
        phase = .idle
    }

    func startCountdown(for seconds: Int) {
        phase = .workout
        countdown = seconds
        motivationIndex = Int.random(in: 0..<motivationalPhrases.count)
        pulse = true

        timer?.invalidate()
        motivationTimer?.invalidate()

        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            countdown -= 1
            if countdown <= 0 {
                t.invalidate()
                motivationTimer?.invalidate()
                playSound(named: "workout_end")
                startRest()
            }
        }

        motivationTimer = Timer.scheduledTimer(withTimeInterval: 10, repeats: true) { _ in
            motivationIndex = (motivationIndex + 1) % motivationalPhrases.count
        }
    }

    func startRest() {
        phase = .rest
        pulse = false
        animatePhrase = false
        countdown = Int(settings.restDuration)

        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { t in
            countdown -= 1
            if countdown <= 0 {
                t.invalidate()

                // Suono rimosso: playSound(named: "rest_end")

                if settings.isLooping {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        startPreCountdown(fromLoop: true)
                    }
                } else {
                    phase = .idle
                }
            }
        }
    }

    func playSound(named soundName: String) {
        guard settings.isSoundEnabled else { return }
        guard let url = Bundle.main.url(forResource: soundName, withExtension: "wav") else {
            print("❌ File audio \(soundName).wav non trovato")
            return
        }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.play()
            print("✅ Suono \(soundName).wav riprodotto")
        } catch {
            print("❌ Errore suono: \(error.localizedDescription)")
        }
    }

    func startPreCountdown(fromLoop: Bool = false) {
        isPreCountdown = true
        preCountdownValue = 3

        playSound(named: "start")

        preCountdownTimer?.invalidate()
        preCountdownTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            preCountdownValue -= 1

            if preCountdownValue < 0 {
                timer.invalidate()
                isPreCountdown = false
                startCountdown(for: Int(settings.workoutDuration))
            }
        }
    }
}
