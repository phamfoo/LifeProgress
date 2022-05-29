import SwiftUI

struct Settings: View {
    @AppStorage("birthday") private var birthday = Date.now
    @AppStorage("lifeExpectancy") private var lifeExpectancy = 72
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
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        // TODO: Saving these values this way is kinda weird
                        lifeExpectancy = lifeExpectancy
                        birthday = birthday
                        onDone()
                    }
                }
            }
        }
    }
}

extension Date: RawRepresentable {
    private static let formatter = ISO8601DateFormatter()

    public var rawValue: String {
        Date.formatter.string(from: self)
    }

    public init?(rawValue: String) {
        self = Date.formatter.date(from: rawValue) ?? Date()
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings(onDone: {})
    }
}
