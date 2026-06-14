import SwiftUI

struct AssignmentRow: View {
    let assignment: Assignment

    private var dueDateText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: assignment.dueDate)
    }

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 2) {
                Text(assignment.title)
                    .font(.body)

                Text(assignment.course)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()

            Text(dueDateText)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    AssignmentRow(
        assignment: Assignment(
            title: "Physics Homework 7",
            course: "PHYS 121",
            dueDate: Date()
        )
    )
}
