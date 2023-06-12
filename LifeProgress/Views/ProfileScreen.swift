import Defaults
import SwiftUI
import WidgetKit

struct ProfileScreen: View {
    @State private var birthday = Defaults[.birthday]
    @State private var lifeExpectancy = Defaults[.lifeExpectancy]

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            List {
                DatePicker(
                    selection: $birthday,
                    in: ...Date.now,
                    displayedComponents: .date
                ) {
                    Text("Your Birthday")
                        .font(.headline)
                }

                Section {
                    VStack(alignment: .leading) {
                        Text("Life Expectancy")
                            .font(.headline)

                        Picker("Life Expectancy", selection: $lifeExpectancy) {
                            ForEach(
                                minimumLifeExpectancy ... 128,
                                id: \.self
                            ) { age in
                                Text("\(age) years").tag(age)
                            }
                        }
                        .pickerStyle(.wheel)
                    }
                }
            }
            .navigationTitle("Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        if !Defaults[.profileSetupCompleted] {
                            Defaults[.profileSetupCompleted] = true
                        }

                        Defaults[.birthday] = birthday
                        Defaults[.lifeExpectancy] = lifeExpectancy

                        WidgetCenter.shared.reloadAllTimelines()

                        dismiss()
                    }
                }
            }
        }
    }

    private var minimumLifeExpectancy: Int {
        let ageComponents = Calendar.current.dateComponents(
            [.year],
            from: birthday,
            to: .now
        )

        return ageComponents.year! + 1
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
    }
}
