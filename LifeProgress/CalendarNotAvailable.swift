import SwiftUI

struct CalendarNotAvailable: View {
    var onSetupRequest: () -> Void

    var body: some View {
        VStack {
            Image(systemName: "calendar")
                .foregroundColor(.accentColor)
                .font(.system(size: 100))

            // TODO: Replace these texts with better texts
            Text("Sed ut perspiciatis")
                .font(.title)
                .padding([.top])

            Text("Ut enim ad minima veniam, quis nostrum exercitationem")
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)

            Button("Set up now") {
                onSetupRequest()
            }
            .padding([.top])
            .buttonStyle(.bordered)
        }
        .padding()
    }
}

struct CalendarNotAvailable_Previews: PreviewProvider {
    static var previews: some View {
        CalendarNotAvailable(onSetupRequest: {})
    }
}
