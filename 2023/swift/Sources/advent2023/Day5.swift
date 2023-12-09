import Algorithms

struct Day5 : Day {

  func parseRanges<C :Sequence<String>> (_ input :C) -> [(Int, Int, Int)] {
    let triple = { (ns :[Substring]) in (Int(ns[0])!, Int(ns[1])!, Int(ns[2])!) }
    return input.dropFirst(1).map({ $0.split(separator: " ") }).map(triple)
  }
  func parse (_ input :[String]) -> ([Int], [[(Int, Int, Int)]]) {
    let blocks = input.split(separator: "")
    return (blocks[0][0].after(": ").split(separator: " ").map({ Int($0)! }),
            blocks.dropFirst().map(parseRanges))
  }

  func apply (_ n :Int, _ ranges :[(Int, Int, Int)]) -> Int {
    for range in ranges {
      let d = n - range.1
      if d >= 0 && d < range.2 { return range.0 + d }
    }
    return n
  }

  func part1 (_ input :[String]) -> String {
    let (seeds, maps) = parse(input)
    return String(seeds.map({ maps.reduce($0, apply) }).min()!)
  }

  func part2 (_ input :[String]) -> String {
    let (seeds, maps) = parse(input)
    let rmaps = maps.map({ $0.map({ t in (t.1, t.0, t.2) }) }).reversed()
    let ranges = Array(seeds.adjacentPairs().striding(by: 2).map({ $0 ..< ($0+$1) }))
    return String((0...).first(where: { loc in
      let seed = rmaps.reduce(loc, apply)
      return ranges.contains(where: { $0.contains(seed) })
    })!)
  }
}
