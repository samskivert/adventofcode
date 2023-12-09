struct Day7 : Day {

  func type (_ grouped :[Unicode.Scalar: [Unicode.Scalar]]) -> Int {
    let max = grouped.values.map({ $0.count }).max()!
    switch (grouped.count) {
      case 1: return 7
      case 2: return max == 4 ? 6 : 5;
      case 3: return max == 3 ? 4 : 3;
      case 4: return 2;
      default: return 1;
    }
  }

  func type1 (_ hand :[Unicode.Scalar]) -> Int { type(hand.grouped(by: { $0 })) }

  func type2 (_ hand :[Unicode.Scalar]) -> Int {
    var grouped = hand.grouped(by: { $0 })
    if let jacks = grouped["J"] {
      grouped.removeValue(forKey: "J")
      return grouped.keys.map({ s in
        var jiss = grouped
        jiss[s] = jiss[s]! + jacks
        return type(jiss)
      }).max() ?? 7 // if it's all jacks we get nil
    }
    return type(grouped)
  }

  static func mkValues (_ j :Int) -> [Unicode.Scalar: Int] {[
    "2": 2, "3": 3, "4": 4, "5": 5, "6": 6, "7": 7, "8": 8, "9": 9,
    "T": 10, "J": j, "Q": 12, "K": 13, "A": 14
  ]}
  let values1 = mkValues(11)
  let values2 = mkValues(1)

  func lessThan (_ a :[Unicode.Scalar], _ b :[Unicode.Scalar], _ two :Bool) -> Bool {
    func compareValues (_ values :[Unicode.Scalar:Int]) -> Bool {
      for (aa, bb) in zip(a, b) {
        let (av, bv) = (values[aa]!, values[bb]!)
        if av != bv { return av < bv }
      }
      return false
    }
    let (ta, tb) = two ? (type2(a), type2(b)) : (type1(a), type1(b))
    return ta != tb ? ta < tb : compareValues(two ? values2 : values1)
  }

  func parse (_ line :String) -> ([Unicode.Scalar], Int) {
    let parts = line.split(separator: " ")
    return (Array(parts[0].unicodeScalars), Int(parts[1])!)
  }

  func winnings (_ input :[String], _ two :Bool) -> Int {
    let sorted = input.map(parse).sorted(by: { (a, b) in lessThan(a.0, b.0, two) })
    return sorted.enumerated().map({ (n, hb) in (n+1)*hb.1 }).reduce(0, +)
  }

  func part1 (_ input :[String]) -> Int { winnings(input, false) }
  func part2 (_ input :[String]) -> Int { winnings(input, true) }
}
