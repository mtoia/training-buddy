import SwiftUI

struct InfoView: View {
    var body: some View {
        VStack(spacing: 10) {
            Text("Training Buddy")
                .font(.system(size: 16, weight: .regular, design: .serif))
                .italic()
            Text("by zteow")
                .font(.system(size: 16, weight: .regular, design: .serif))
                .italic()
            Text("Versione 1.1")
                .font(.system(size: 16, weight: .regular, design: .serif))
                .italic()
            Text("") // Riga vuota
            Text("www.zteo.org")
                .font(.system(size: 16, weight: .regular, design: .serif))
                .italic()
        }
        .padding(.top, 60)
        .multilineTextAlignment(.center)
    }
}
