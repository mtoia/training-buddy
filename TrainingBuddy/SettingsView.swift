import SwiftUI

struct SettingsView: View {
    @ObservedObject var settings: SettingsModel
    
    @State private var workoutValue = 2
    @State private var workoutUnit = "Minuti"
    @State private var restValue = 30
    @State private var restUnit = "Secondi"
    
    let units = ["Secondi", "Minuti"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Il tuo nome")) {
                    TextField("Nome", text: $settings.userName)
                }
                
                Section(header: Text("Tempo di allenamento")) {
                    HStack {
                        Stepper("\(workoutValue)", value: $workoutValue, in: 1...60)
                        Picker("", selection: $workoutUnit) {
                            ForEach(units, id: \.self) { Text($0) }
                        }
                        .pickerStyle(.segmented)
                    }
                }
                
                Section(header: Text("Tempo di riposo")) {
                    HStack {
                        Stepper("\(restValue)", value: $restValue, in: 1...60)
                        Picker("", selection: $restUnit) {
                            ForEach(units, id: \.self) { Text($0) }
                        }
                        .pickerStyle(.segmented)
                    }
                }
                
                Button("Reset") {
                    settings.resetDefaults()
                    workoutValue = 2
                    workoutUnit = "Minuti"
                    restValue = 30
                    restUnit = "Secondi"
                }
                .foregroundColor(.red)
            }
            .navigationTitle("Impostazioni")
            .onDisappear {
                // Salva conversioni in secondi
                settings.workoutDuration = TimeInterval(workoutValue) * (workoutUnit == "Minuti" ? 60 : 1)
                settings.restDuration = TimeInterval(restValue) * (restUnit == "Minuti" ? 60 : 1)
            }
            .onAppear {
                // Inizializza i valori
                workoutValue = Int(settings.workoutDuration / (settings.workoutDuration >= 60 ? 60 : 1))
                workoutUnit = settings.workoutDuration >= 60 ? "Minuti" : "Secondi"
                
                restValue = Int(settings.restDuration / (settings.restDuration >= 60 ? 60 : 1))
                restUnit = settings.restDuration >= 60 ? "Minuti" : "Secondi"
            }
        }
    }
}
