struct Day18 : Day {

  enum Dir : Unicode.Scalar, CaseIterable {
    case R = "R", D = "D", L = "L", U = "U"
    var dx :Int { self == .R ? 1 : self == .L ? -1 : 0 }
    var dy :Int { self == .D ? 1 : self == .U ? -1 : 0 }
  }

  func shoelace (_ instrs :[(Dir, Int)]) -> Int {
    var pos = (0, 0), sum = 0
    for (dir, count) in instrs {
      let npos = (pos.0 + dir.dx * count, pos.1 + dir.dy * count)
      sum += (pos.0 * npos.1 - pos.1 * npos.0) + count
      pos = npos
    }
    return sum/2 + 1
  }

  func part1 (_ input :[String]) -> Int {
    shoelace(input.map({
      let bits = $0.components(separatedBy: " ")
      return (Dir(rawValue: bits[0].unicodeScalars.first!)!, Int(bits[1])!)
    }))
  }

  func part2 (_ input :[String]) -> Int {
    shoelace(input.map({
      let bits = $0.components(separatedBy: " ")
      let (numstr, dirstr) = (bits[2].dropFirst(2).prefix(5), bits[2].dropLast().last!)
      return (Dir.allCases[Int(String(dirstr))!], Int(numstr, radix: 16)!)
    }))
  }
}
