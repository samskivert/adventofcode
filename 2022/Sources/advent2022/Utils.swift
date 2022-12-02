import Foundation

func readInput (_ day :Int) throws -> [String] {
    let data = try String(contentsOfFile: "Input/day\(day).txt", encoding: .utf8)
    var lines = data.components(separatedBy: .newlines)
    if (lines.last == "") { lines.removeLast() } // trim trailing newline
    return lines
}