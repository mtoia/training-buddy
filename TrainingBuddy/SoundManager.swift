import AVFoundation

class SoundManager: NSObject, AVAudioPlayerDelegate {
    static let shared = SoundManager()

    private var audioPlayer: AVAudioPlayer?

    func playSound(named name: String) {
        // Verifica se i suoni sono abilitati
        guard UserDefaults.standard.bool(forKey: "isSoundEnabled") else {
            print("🔇 Suoni disattivati")
            return
        }

        // Configura la sessione per ducking (abbassamento temporaneo volume musica)
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.playback, mode: .default, options: [.duckOthers])
            try session.setActive(true)
        } catch {
            print("❌ Errore configurazione AVAudioSession: \(error)")
        }

        // Carica e riproduce il suono
        guard let url = Bundle.main.url(forResource: name, withExtension: "wav") else {
            print("❌ Suono \(name).wav non trovato")
            return
        }

        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.delegate = self
            audioPlayer?.play()
            print("✅ Riproduzione suono: \(name).wav")
        } catch {
            print("❌ Errore riproduzione audio: \(error.localizedDescription)")
        }
    }

    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        // Al termine del suono, disattiva la sessione per restituire il controllo al sistema
        do {
            try AVAudioSession.sharedInstance().setActive(false, options: [.notifyOthersOnDeactivation])
        } catch {
            print("❌ Errore al termine riproduzione audio: \(error.localizedDescription)")
        }
    }
}
