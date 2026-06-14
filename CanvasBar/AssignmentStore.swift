import Foundation
import SwiftUI
import Combine

class AssignmentStore: ObservableObject {
    @Published var assignments: [Assignment] = []
    @Published var isLoading = false
    @Published var errorMessage: String?

    init() {
        loadSampleAssignments()
    }

    func loadSampleAssignments() {
        assignments = []
    }

    @MainActor
    func refreshAssignments(from urlString: String) async {
        guard !urlString.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            errorMessage = "Canvas URL not set"
            return
        }

        isLoading = true
        errorMessage = nil

        do {
            let icsText = try await CalendarFetcher.fetchCalendar(urlString: urlString)
            let parsed = ICSParser.parse(icsText)

            let calendar = Calendar.current
            let startOfToday = calendar.startOfDay(for: Date())

            guard let startOfTomorrow = calendar.date(byAdding: .day, value: 1, to: startOfToday) else {
                assignments = []
                isLoading = false
                return
            }

            assignments = parsed
                .filter { $0.dueDate >= startOfToday && $0.dueDate < startOfTomorrow }
                .sorted { $0.dueDate < $1.dueDate }

        } catch {
            errorMessage = "Could not load Canvas calendar."
        }

        isLoading = false
    }
}
