import SwiftUI

struct Settings: View {
    @AppStorage("birthday") private var birthday = Date.now
    @AppStorage("lifeExpectancy") private var lifeExpectancy = 72

    var body: some View {
        Form {
            DatePicker(selection: $birthday, displayedComponents: .date) {
                Text("Your Birthday").bold()
            }

            Section {
                Text("Life Expectancy")
                    .bold()
                Picker("Life Expectancy", selection: $lifeExpectancy) {
                    ForEach(28..<128) { age in
                        Text("\(age) years").tag(age)
                    }
                }
                .pickerStyle(.wheel)
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
        Settings()
    }
}
