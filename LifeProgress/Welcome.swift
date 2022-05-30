import SwiftUI

struct Welcome: View {
    @State private var showingProfile = false
    
    var body: some View {
        VStack {
            Image(systemName: "calendar")
                .foregroundColor(.accentColor)
                .font(.system(size: 100))

            Text("Welcome!")
                .font(.title)
                .padding([.top])

            Text("Before we continue, let's set up your profile")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button("I'm ready") {
                showingProfile = true
            }
            .padding([.top])
            .buttonStyle(.bordered)
        }
        .padding()
        .sheet(isPresented: $showingProfile) {
            Profile(onDone: {
                showingProfile = false
            })
        }
    }
}

struct Welcome_Previews: PreviewProvider {
    static var previews: some View {
        Welcome()
    }
}
