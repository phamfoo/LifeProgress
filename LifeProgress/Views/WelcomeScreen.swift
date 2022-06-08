import SwiftUI

struct WelcomeScreen: View {
    @State private var showingProfile = false

    var body: some View {
        VStack(alignment: .leading) {
            Spacer()
            
            Image("icon")
                .resizable()
                .frame(width: 100, height: 100)
                .cornerRadius(12.0)

            VStack(alignment: .leading, spacing: 0) {
                Text("Welcome to")
                    .font(.system(size: 34))
                
                Text("Life Progress")
                    .bold()
                    .font(.system(size: 34, weight: .heavy))
            }
            .padding(.bottom, 4)
            
            Text("Friendly reminder that you're not gonna live forever.")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.leading)
            
            Spacer()
            
            VStack {
                Text("Before we continue, let's set up your profile")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                
                Button {
                    showingProfile = true
                } label: {
                    Text("Continue")
                        .bold()
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
            }
        }
        .padding()
        .sheet(isPresented: $showingProfile) {
            ProfileScreen()
                .interactiveDismissDisabled()
        }
    }
}

struct Welcome_Previews: PreviewProvider {
    static var previews: some View {
        WelcomeScreen()
    }
}
