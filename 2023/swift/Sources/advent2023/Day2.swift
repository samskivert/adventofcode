struct Day2 : Day {

  func parseGame ( _ input :String) -> (Int, String) {
    let parts = input.splitAndTrim(":")
    return (Int(parts[0].splitAndTrim(" ")[1])!, parts[1])
  }

  func foldGame<Z> (_ z :Z, _ rounds :String, _ op :(Z, String, Int) -> Z) -> Z {
    rounds.splitAndTrim(";").reduce(z, { (z, round) in
      round.splitAndTrim(",").reduce(z, { (z, draw) in
        let parts = draw.splitAndTrim(" ")
        return op(z, parts[1], Int(parts[0])!)
      })
    })
  }

  let maxDraws = ["red": 12, "green": 13, "blue": 14]
  func checkGame (_ input :String) -> Int {
    let (gameId, rounds) = parseGame(input)
    return foldGame(true, rounds, { $0 && $2 <= maxDraws[$1]! }) ? gameId : 0;
  }
  func part1 (_ input :[String]) throws -> String { String(input.map(checkGame).reduce(0, +)) }

  func gamePower (_ input :String) -> Int {
    var maxCubes = ["red": 0, "green": 0, "blue": 0]
    foldGame((), parseGame(input).1, { (cs, draw, count) in
      maxCubes.updateValue(max(maxCubes[draw]!, count), forKey: draw)
    })
    return maxCubes.values.reduce(1, *)
  }
  func part2 (_ input :[String]) throws -> String { String(input.map(gamePower).reduce(0, +)) }
}
