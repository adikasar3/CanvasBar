import SwiftUI

struct AssignmentRow: View {
    @Binding var assignment: Assignment

    private var dueDateText: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM d"
        return formatter.string(from: assignment.dueDate)
    }

    var body: some View {
        HStack {
            Button {
                assignment.isDone.toggle()
            } label: {
                Image(systemName: assignment.isDone ? "checkmark.square.fill" : "square")
                    .foregroundColor(assignment.isDone ? .accentColor : .secondary)
            }
            .buttonStyle(.plain)

            VStack(alignment: .leading, spacing: 2) {
                Text(assignment.title)
                    .font(.body)
                    .strikethrough(assignment.isDone)
                    .foregroundColor(assignment.isDone ? .secondary : .primary)

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
        assignment: .constant(
            Assignment(
                title: "Physics Homework 7",
                course: "PHYS 121",
                dueDate: Date()
            )
        )
    )
}
