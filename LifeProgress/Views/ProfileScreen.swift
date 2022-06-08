import Defaults
import SwiftUI
import WidgetKit

struct ProfileScreen: View {
    @State private var birthday = Defaults[.birthday] ?? getDefaultBirthday()
    @State private var lifeExpectancy = Defaults[.lifeExpectancy]

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationView {
            List {
                DatePicker(selection: $birthday, displayedComponents: .date) {
                    Text("Your Birthday")
                        .font(.headline)
                }

                Section {
                    VStack(alignment: .leading) {
                        Text("Life Expectancy")
                            .font(.headline)
                        
                        Picker("Life Expectancy", selection: $lifeExpectancy) {
                            ForEach(
                                minimumLifeExpectancy ..< minimumLifeExpectancy + 128,
                                id: \.self) { age in
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
                        Defaults[.birthday] = birthday
                        Defaults[.lifeExpectancy] = lifeExpectancy

                        WidgetCenter.shared.reloadAllTimelines()
                        
                        dismiss()
                    }
                }
            }
        }
    }
    
    var minimumLifeExpectancy: Int {
        let ageComponents = Calendar.current.dateComponents(
            [.year],
            from: birthday,
            to: .now
        )

        return (ageComponents.year ?? 0) + 1
    }


    static func getDefaultBirthday() -> Date {
        let defaultUserAge = 22
        let defaultBirthday = Calendar.current.date(
            byAdding: .year,
            value: -defaultUserAge,
            to: .now
        )

        return defaultBirthday ?? .now
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen()
    }
}
