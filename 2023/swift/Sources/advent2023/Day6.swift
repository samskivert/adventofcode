struct Day6 : Day {

  func wins (_ race :(Int, Int)) -> Int {
    let losses = (0 ..< race.0/2).lazy.prefix(while: { t in (race.0 - t) * t <= race.1 }).count
    return race.0+1 - 2*losses
  }

  func part1 (_ input :[String]) -> Int {
    let parse = { (line :String) in line.after(": ").split(separator: " ").map({ Int($0)! }) }
    return zip(parse(input[0]), parse(input[1])).map(wins).reduce(1, *)
  }

  func part2 (_ input :[String]) -> Int {
    let parse = { (line :String) in
      Int(String(line.after(": ")).replacingOccurrences(of: " ", with: ""))! }
    return wins((parse(input[0]), parse(input[1])))
  }
}
