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

                    Section("Learn more") {
                        learnMore
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

    var learnMore: some View {
        Group {
            VStack(alignment: .leading) {
                Text("\"Your Life in Weeks\"")
                    .font(.headline)

                Text(
                    "This idea was originally introduced in an article by **Tim Urban**."
                )
                .font(.subheadline)
                .foregroundColor(.secondary)

                Link("Visit the article",
                     destination: URL(
                         string: "https://waitbutwhy.com/2014/05/life-weeks.html"
                     )!)
            }

            VStack(alignment: .leading) {
                Text("\"What Are You Doing With Your Life? The Tail End\"")
                    .font(.headline)

                Text(
                    "**Kurzgesagt**'s phenomenal video on the topic."
                )
                .font(.subheadline)
                .foregroundColor(.secondary)

                Link("See the video on YouTube",
                     destination: URL(
                         string: "https://www.youtube.com/watch?v=JXeJANDKwDc"
                     )!)
            }

            VStack(alignment: .leading) {
                Text("The project is open source!")
                    .font(.headline)

                Link("Check out the code on GitHub",
                     destination: URL(
                         string: "https://github.com/tienphaw/LifeProgress"
                     )!)
            }
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
                    SimplifiedLifeCalendarView(life: life)
                        .frame(width: 150, height: 200)
                        .padding(.leading, 100)
                        .padding(.top, 100)

                    ZoomedInCalendar()
                }
            }

            VStack(alignment: .leading) {
                Text(
                    "Each row of 52 weeks makes up one year"
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
        VStack {
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
}

struct AboutScreen_Previews: PreviewProvider {
    static var previews: some View {
        AboutScreen(life: Life.example)
    }
}
