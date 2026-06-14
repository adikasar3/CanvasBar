import Foundation

struct ICSParser {
    static func parse(_ icsText: String) -> [Assignment] {
        let lines = unfold(icsText)

        var assignments: [Assignment] = []
        var insideEvent = false
        var currentSummary: String?
        var currentDateString: String?

        for line in lines {
            if line == "BEGIN:VEVENT" {
                insideEvent = true
                currentSummary = nil
                currentDateString = nil
                continue
            }

            if line == "END:VEVENT" {
                if let summary = currentSummary,
                   let dateString = currentDateString,
                   let dueDate = parseDate(dateString) {

                    let info = splitTitleAndCourse(summary)

                    assignments.append(
                        Assignment(
                            title: info.title,
                            course: info.course,
                            dueDate: dueDate
                        )
                    )
                }

                insideEvent = false
                continue
            }

            if insideEvent {
                if line.hasPrefix("SUMMARY:") {
                    let summary = String(line.dropFirst("SUMMARY:".count))
                    currentSummary = cleanText(summary)
                }

                if line.hasPrefix("DTSTART"),
                   let colonIndex = line.lastIndex(of: ":") {
                    currentDateString = String(line[line.index(after: colonIndex)...])
                }
            }
        }

        return assignments
    }

    private static func unfold(_ text: String) -> [String] {
        let rawLines = text
            .replacingOccurrences(of: "\r\n", with: "\n")
            .components(separatedBy: "\n")

        var lines: [String] = []

        for line in rawLines {
            if line.hasPrefix(" ") || line.hasPrefix("\t") {
                if let last = lines.popLast() {
                    lines.append(last + line.dropFirst())
                }
            } else {
                lines.append(line)
            }
        }

        return lines
    }

    private static func splitTitleAndCourse(_ summary: String) -> (title: String, course: String) {
        if let openBracket = summary.lastIndex(of: "["),
           let closeBracket = summary.lastIndex(of: "]"),
           openBracket < closeBracket {

            let title = summary[..<openBracket]
                .trimmingCharacters(in: .whitespaces)

            let course = summary[summary.index(after: openBracket)..<closeBracket]
                .trimmingCharacters(in: .whitespaces)

            return (title, course)
        }

        return (summary, "Canvas")
    }

    private static func cleanText(_ text: String) -> String {
        text
            .replacingOccurrences(of: "\\n", with: " ")
            .replacingOccurrences(of: "\\N", with: " ")
            .replacingOccurrences(of: "\\,", with: ",")
            .replacingOccurrences(of: "\\;", with: ";")
            .replacingOccurrences(of: "\\\\", with: "\\")
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private static func parseDate(_ value: String) -> Date? {
        let utcFormatter = DateFormatter()
        utcFormatter.dateFormat = "yyyyMMdd'T'HHmmss'Z'"
        utcFormatter.timeZone = TimeZone(identifier: "UTC")

        if let date = utcFormatter.date(from: value) {
            return date
        }

        let dateTimeFormatter = DateFormatter()
        dateTimeFormatter.dateFormat = "yyyyMMdd'T'HHmmss"
        dateTimeFormatter.timeZone = TimeZone.current

        if let date = dateTimeFormatter.date(from: value) {
            return date
        }

        let dateOnlyFormatter = DateFormatter()
        dateOnlyFormatter.dateFormat = "yyyyMMdd"
        dateOnlyFormatter.timeZone = TimeZone.current

        return dateOnlyFormatter.date(from: value)
    }
}
