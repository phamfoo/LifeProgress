import SwiftUI

struct AboutScreen: View {
    var life: Life

    var body: some View {
        NavigationView {
            VStack {
                List {
                    Section("How it works") {
                        howItWorks
                            // Text gets cut off without this
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.vertical)
                    }

                    Section("Sponsor") {
                        sponsor
                            .padding(.vertical)
                    }
                }
            }
            .navigationTitle("About Life Progress")
            .navigationBarTitleDisplayMode(.inline)
        }
    }

    var howItWorks: some View {
        VStack(alignment: .leading, spacing: 48) {
            VStack(alignment: .leading) {
                Text("A calendar for your life")
                    .font(.headline)

                Text(
                    "Each square you see on screen represents a week in your life. The first square (the one at the top left) is the week you were born."
                )
                .font(.subheadline)
                .foregroundColor(.secondary)

                ZStack(alignment: .topLeading) {
                    SimplifiedLifeProgressView(life: life)
                        .frame(width: 150, height: 200)
                        .padding(.leading, 100)
                        .padding(.top, 100)

                    ZoomedInCalendar()
                }
            }

            VStack(alignment: .leading) {
                Text(
                    "Each row of weeks makes up one year"
                )
                .font(.headline)

                Text(
                    "This is what your current year looks like, see if you can spot it on the calendar."
                )
                .font(.subheadline)
                .foregroundColor(.secondary)

                CurrentYearProgressView(life: life)
            }

            VStack(alignment: .leading) {
                Text("Last thing!")
                    .font(.headline)

                Text(
                    "Try tapping on the calendar and see what happens."
                )
                .font(.subheadline)
                .foregroundColor(.secondary)
            }
        }
    }

    var sponsor: some View {
        HStack {
            Image("PneumaLogo")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.primary)
                .frame(width: 49, height: 45)
                .padding(.horizontal)

            VStack(alignment: .leading) {
                Text("Pneuma Media")
                    .font(.headline)

                Link("pneumallc.co",
                     destination: URL(
                         string: "https://www.pneumallc.co"
                     )!)
            }
        }
    }
}

struct AboutScreen_Previews: PreviewProvider {
    static var previews: some View {
        AboutScreen(life: Life.example)
    }
}
