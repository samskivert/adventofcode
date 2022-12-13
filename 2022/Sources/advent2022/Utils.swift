import Foundation

func readExample (_ day :Int) throws -> [String] { try readFile("Input/example\(day).txt") }

func readInput (_ day :Int) throws -> [String] { try readFile("Input/day\(day).txt") }

func readFile (_ path :String) throws -> [String] {
    let data = try String(contentsOfFile: path, encoding: .utf8)
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

    @discardableResult mutating func insertSorted (_ item :Element, _ lessThan :(Element, Element) -> Bool) -> Int {
        var lo = 0, hi = self.count - 1
        while lo <= hi {
            let mid = (lo + hi)/2
            if lessThan(self[mid], item) { lo = mid + 1 }
            else if lessThan(item, self[mid]) { hi = mid - 1 }
            else {
                self.insert(item, at: mid)
                return mid
            }
        }
        self.insert(item, at: lo)
        return lo
    }
}