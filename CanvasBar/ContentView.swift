import SwiftUI

struct ContentView: View {
    @EnvironmentObject var store: AssignmentStore
    @Environment(\.openSettings) private var openSettings

    @AppStorage("canvasURL")
    private var canvasURL = ""

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Assignments Due Today")
                .font(.headline)

            statusText

            Divider()

            assignmentList

            Divider()

            buttons
        }
        .padding()
        .frame(width: 450)
        .task {
            await store.refreshAssignments(from: canvasURL)
        }
    }

    private var statusText: some View {
        Group {
            if store.isLoading {
                Text("Loading...")
                    .foregroundColor(.secondary)
            } else if let errorMessage = store.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            } else if store.assignments.isEmpty {
                Text("Nothing due today")
                    .foregroundColor(.secondary)
            } else {
                Text("\(store.assignments.count) assignment(s)")
                    .foregroundColor(.secondary)
            }
        }
        .font(.caption)
    }

    private var assignmentList: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(store.assignments) { assignment in
                AssignmentRow(assignment: assignment)

                if assignment.id != store.assignments.last?.id {
                    Divider()
                }
            }
        }
    }

    private var buttons: some View {
        HStack {
            Button("Refresh") {
                Task {
                    await store.refreshAssignments(from: canvasURL)
                }
            }

            Button("Settings") {
                openSettings()

                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    NSApp.activate(ignoringOtherApps: true)

                    for window in NSApp.windows {
                        if window.title.contains("CanvasBar Settings") ||
                            window.title.contains("Settings") {
                            window.makeKeyAndOrderFront(nil)
                            window.orderFrontRegardless()
                        }
                    }
                }
            }

            Spacer()

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .foregroundColor(.red)
            .font(.system(size: 11))
        }
    }
}

#Preview {
    ContentView()
        .environmentObject(AssignmentStore())
}
