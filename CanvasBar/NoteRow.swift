import SwiftUI

struct NoteRow: View {
    @Binding var note: Note

    var body: some View {
        HStack {
            Button {
                note.isDone.toggle()
            } label: {
                Image(systemName: note.isDone ? "checkmark.square.fill" : "square")
                    .foregroundColor(note.isDone ? .accentColor : .secondary)
            }
            .buttonStyle(.plain)

            Text(note.text)
                .font(.body)
                .strikethrough(note.isDone)
                .foregroundColor(note.isDone ? .secondary : .primary)

            Spacer()
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NoteRow(note: .constant(Note(text: "Bring calculator to class")))
}
