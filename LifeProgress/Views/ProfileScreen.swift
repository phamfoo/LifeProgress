import Defaults
import SwiftUI
import WidgetKit

struct ProfileScreen: View {
    @State var birthday = Defaults[.birthday] ?? getDefaultBirthday()
    @State var lifeExpectancy = Defaults[.lifeExpectancy]

    var onDone: () -> Void

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
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        Defaults[.birthday] = birthday
                        Defaults[.lifeExpectancy] = lifeExpectancy

                        WidgetCenter.shared.reloadAllTimelines()
                        onDone()
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
            to: Date.now
        )

        return defaultBirthday ?? Date.now
    }
}

struct ProfileScreen_Previews: PreviewProvider {
    static var previews: some View {
        ProfileScreen(onDone: {})
    }
}
