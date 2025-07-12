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
        didSet { UserDefaults.standard.set(isSoundEnabled, forKey: "isSoundEnabled") }
    }

    init() {
        self.userName = UserDefaults.standard.string(forKey: "userName") ?? "Buddy"
        self.workoutDuration = UserDefaults.standard.double(forKey: "workoutDuration")
        self.restDuration = UserDefaults.standard.double(forKey: "restDuration")
        self.isLooping = UserDefaults.standard.bool(forKey: "isLooping")
        self.isSoundEnabled = UserDefaults.standard.object(forKey: "isSoundEnabled") as? Bool ?? true

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
