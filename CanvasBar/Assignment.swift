import Foundation

struct Assignment: Identifiable {
    let id = UUID()
    let title: String
    let course: String
    let dueDate: Date
}
