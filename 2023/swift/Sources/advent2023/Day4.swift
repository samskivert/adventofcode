struct Day4 : Day {

  func matches (_ card :String) -> Int {
    let nums = card.splitAndTrim(":")[1].replacingOccurrences(of: "  ", with: " ").splitAndTrim("|")
    let (winners, have) = (nums[0].splitAndTrim(" ").map({ Int($0)! }),
                           nums[1].splitAndTrim(" ").map({ Int($0)! }))
    return winners.reduce(0, { $0 + (have.contains($1) ? 1 : 0) })
  }

  func part1 (_ input :[String]) throws -> String {
    String(input.map({ 1 << (matches($0) - 1) }).reduce(0, +))
  }

  func part2 (_ input :[String]) throws -> String {
    let matches = input.map(matches)
    var counts = Array(repeating: 1, count: input.count)
    for ii in 0 ..< matches.count {
      for jj in 0 ..< matches[ii] { counts[ii+jj+1] += counts[ii] }
    }
    return String(counts.reduce(0, +))
  }
}
