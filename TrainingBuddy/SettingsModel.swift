import Foundation

class SettingsModel: ObservableObject {
    @Published var userName: String {
        didSet { UserDefaults.standard.set(userName, forKey: "userName") }
    }

    @Published var workoutDuration: TimeInterval {
        didSet { UserDefaults.standard.set(workoutDuration, forKey: "workoutDuration") }
    }

    @Published var restDuration: TimeInterval {
        didSet { UserDefaults.standard.set(restDuration, forKey: "restDuration") }
    }

    @Published var isLooping: Bool {
        didSet { UserDefaults.standard.set(isLooping, forKey: "isLooping") }
    }

    @Published var isSoundEnabled: Bool {
        didSet {
            UserDefaults.standard.set(isSoundEnabled, forKey: "isSoundEnabled")
            print("🔧 isSoundEnabled aggiornato: \(isSoundEnabled)")
        }
    }

    init() {
        self.userName = UserDefaults.standard.string(forKey: "userName") ?? "Buddy"
        self.workoutDuration = UserDefaults.standard.double(forKey: "workoutDuration")
        self.restDuration = UserDefaults.standard.double(forKey: "restDuration")
        self.isLooping = UserDefaults.standard.bool(forKey: "isLooping")

        // Forziamo a true se la chiave non esiste
        if UserDefaults.standard.object(forKey: "isSoundEnabled") == nil {
            self.isSoundEnabled = true
            UserDefaults.standard.set(true, forKey: "isSoundEnabled")
        } else {
            self.isSoundEnabled = UserDefaults.standard.bool(forKey: "isSoundEnabled")
        }

        if workoutDuration == 0 { workoutDuration = 120 }
        if restDuration == 0 { restDuration = 30 }
    }

    func resetDefaults() {
        userName = "Buddy"
        workoutDuration = 120
        restDuration = 30
        isLooping = false
        isSoundEnabled = true
    }
}
