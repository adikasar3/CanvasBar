import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var store: AssignmentStore
    @AppStorage("canvasURL") private var canvasURL = ""

    @State private var statusMessage = ""
    @State private var isTesting = false

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

            Spacer()
        }
        .padding()
        .frame(width: 440, height: 210)
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
}

#Preview {
    SettingsView()
        .environmentObject(AssignmentStore())
}
