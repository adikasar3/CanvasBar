import SwiftUI

@main
struct CanvasBarApp: App {
    @StateObject private var store = AssignmentStore()

    var body: some Scene {
        MenuBarExtra {
            ContentView()
                .environmentObject(store)
        } label: {
            Text("W")
                .font(.system(size: 16, weight: .bold))
        }
        .menuBarExtraStyle(.window)

        Settings {
            SettingsView()
                .environmentObject(store)
        }
    }
}
