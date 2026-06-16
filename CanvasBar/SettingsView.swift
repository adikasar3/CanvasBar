import SwiftUI
import ServiceManagement

struct SettingsView: View {
    @EnvironmentObject var store: AssignmentStore
    @AppStorage("canvasURL") private var canvasURL = ""

    @State private var statusMessage = ""
    @State private var isTesting = false
    @State private var launchAtLogin = SMAppService.mainApp.status == .enabled

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Canvas Settings")
                .font(.title3)
                .fontWeight(.semibold)

            Text("Calendar Feed URL")
                .font(.caption)
                .foregroundColor(.secondary)

            TextField("Paste Canvas .ics link", text: $canvasURL)
                .textFieldStyle(.roundedBorder)

            Button(isTesting ? "Testing..." : "Test Feed") {
                Task {
                    await testFeed()
                }
            }
            .disabled(isTesting)

            if !statusMessage.isEmpty {
                Text(statusMessage)
                    .font(.caption)
                    .foregroundColor(statusMessage.hasPrefix("Success") ? .green : .red)
            }

            Text("Find this in Canvas under Calendar, then Calendar Feed.")
                .font(.caption)
                .foregroundColor(.secondary)

            Divider()

            Toggle("Launch at startup", isOn: $launchAtLogin)
                .onChange(of: launchAtLogin) { _, newValue in
                    setLaunchAtLogin(newValue)
                }

            Spacer()
        }
        .padding()
        .frame(width: 440, height: 260)
    }

    private func testFeed() async {
        isTesting = true
        statusMessage = ""

        do {
            let text = try await CalendarFetcher.fetchCalendar(urlString: canvasURL)
            let assignments = ICSParser.parse(text)
            statusMessage = "Success. Found \(assignments.count) calendar items."
            await store.refreshAssignments(from: canvasURL)
        } catch {
            statusMessage = "Error. Check your Canvas URL."
        }

        isTesting = false
    }

    private func setLaunchAtLogin(_ enabled: Bool) {
        do {
            if enabled {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            launchAtLogin = SMAppService.mainApp.status == .enabled
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(AssignmentStore())
}
