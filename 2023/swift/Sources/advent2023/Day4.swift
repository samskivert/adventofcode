struct Day4 : Day {

  func matches (_ card :String) -> Int {
    let nums = card.after(": ").split(separator: "|")
    let (winners, have) = (nums[0].split(separator: " ").map({ Int($0)! }),
                           nums[1].split(separator: " ").map({ Int($0)! }))
    return winners.reduce(0, { $0 + (have.contains($1) ? 1 : 0) })
  }

  func part1 (_ input :[String]) -> Int { input.map({ 1 << (matches($0) - 1) }).reduce(0, +) }

  func part2 (_ input :[String]) -> Int {
    let matches = input.map(matches)
    var counts = Array(repeating: 1, count: input.count)
    for ii in 0 ..< matches.count {
      for jj in 0 ..< matches[ii] { counts[ii+jj+1] += counts[ii] }
    }
    return counts.reduce(0, +)
  }
}
