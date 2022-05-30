import SwiftUI
import Defaults

struct Profile: View {
    @State var birthday = Defaults[.birthday] ?? Date.now
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
                            ForEach(28 ..< 128) { age in
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
                        onDone()
                    }
                }
            }
        }
    }
}

extension Defaults.Keys {
    static let lifeExpectancy = Key<Int>("lifeExpectancy", default: 72)
    static let birthday = Key<Date?>("birthday")
}


struct Profile_Previews: PreviewProvider {
    static var previews: some View {
        Profile(onDone: {})
    }
}
