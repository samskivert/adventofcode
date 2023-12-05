import Foundation

func readFile (_ path :String) throws -> [String] {
  let data = try String(contentsOfFile: path, encoding: .utf8)
  var lines = data.components(separatedBy: .newlines)
  if (lines.last == "") { lines.removeLast() } // trim trailing newline
  return lines
}

func tryReadFile (_ path :String) throws -> [String]? {
  if (FileManager.default.fileExists(atPath: path)) { return try readFile(path) }
  else { return nil }
}

extension StringProtocol {

  func firstIndexInt (of c :Character) -> Int? {
    if let idx = self.firstIndex(of: c) { return self.distance(from: self.startIndex, to: idx) }
    else { return nil }
  }

  func after (_ sep :String) -> Self.SubSequence {
    if let range = self.range(of: sep) { return self[range.upperBound...] }
    return self[self.startIndex...]
  }
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

  @discardableResult mutating func insertSorted (
    _ item :Element, _ lessThan :(Element, Element) -> Bool
  ) -> Int {
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
