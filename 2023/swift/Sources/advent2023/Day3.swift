import Foundation

struct Day3 : Day {

  struct Pos : Equatable {
    let row :Int
    let col :Int
    init (_ row :Int, _ col :Int) {
      self.row = row
      self.col = col
    }
  }

  func charAt (_ input :[String], _ pos :Pos) -> Character {
    if pos.row < 0 || pos.col < 0 || pos.row >= input.count { return "." }
    let line = input[pos.row]
    if pos.col >= line.count { return "." }
    return line[line.index(line.startIndex, offsetBy: pos.col)]
  }

  let digitSet = CharacterSet.decimalDigits
  func numberAt (_ line :String.UnicodeScalarView, _ pos :Int) -> (Int, Int) {
    let digits = line.dropFirst(pos).prefix(while: { digitSet.contains($0) })
    let isStart = pos == 0 || !digitSet.contains(line[line.index(line.startIndex, offsetBy: pos-1)])
    return isStart && digits.count > 0 ? (Int(String(digits))!, digits.count) : (0, 1)
  }

  func positions (_ input :[String]) -> [Pos] {
    let cols = 0 ..< input[0].count
    return (0 ..< input.count).flatMap({ row in cols.map({ col in Pos(row, col) }) })
  }

  func parts (_ input :[String]) -> [(Pos, Int, [Pos])] {
    positions(input).compactMap({ (pos :Pos) in
      let (n, len) = numberAt(input[pos.row].unicodeScalars, pos.col)
      if n == 0 { return nil }
      let row = { (_ dr :Int) in (pos.col-1 ... pos.col+len).map({ cc in Pos(pos.row+dr, cc) }) }
      let rim = row(1) + row(-1) + [Pos(pos.row, pos.col-1), Pos(pos.row, pos.col+len)]
      return rim.contains(where: { charAt(input, $0) != "." }) ? (pos, n, rim) : nil
    })
  }

  func part1 (_ input :[String]) throws -> String {
    String(parts(input).map({ $0.1 }).reduce(0, +))
  }

  func part2 (_ input :[String]) throws -> String {
    let parts = parts(input)
    return String(positions(input).reduce(0, { (sum, pos) in
      if charAt(input, pos) != "*" { return sum }
      let aparts = parts.filter({ pp in pp.2.contains(pos) })
      return sum + (aparts.count == 2 ? aparts.map({ $0.1 }).reduce(1, *) : 0)
    }))
  }
}
