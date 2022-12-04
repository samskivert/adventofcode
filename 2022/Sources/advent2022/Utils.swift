import Foundation

func readInput (_ day :Int) throws -> [String] {
    let data = try String(contentsOfFile: "Input/day\(day).txt", encoding: .utf8)
    var lines = data.components(separatedBy: .newlines)
    if (lines.last == "") { lines.removeLast() } // trim trailing newline
    return lines
}

extension Array {

    func chunked (by distance: Int) -> [[Element]] {
        let indicesSequence = stride(from: startIndex, to: endIndex, by: distance)
        let array: [[Element]] = indicesSequence.map {
            let newIndex = $0.advanced(by: distance) > endIndex ? endIndex : $0.advanced(by: distance)
            return Array(self[$0 ..< newIndex])
        }
        return array
    }
}
