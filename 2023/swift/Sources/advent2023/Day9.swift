struct Day9 : Day {

  func parse (_ input :[String]) -> [[Int]] {
    input.map { $0.components(separatedBy: " ").map { Int($0)! }}
  }

  func next (_ seq :[Int]) -> Int {
    seq.allSatisfy { $0 == 0 } ? 0 : seq.last! + next(seq.adjacentPairs().map { $1 - $0 })
  }
  func part1 (_ input :[String]) -> Int { parse(input).sum(by: next) }

  func prev (_ seq :[Int]) -> Int {
    seq.allSatisfy { $0 == 0 } ? 0 : seq.first! - prev(seq.adjacentPairs().map { $1 - $0 })
  }
  func part2 (_ input :[String]) -> Int { parse(input).sum(by: prev) }
}
