import ArgumentParser

protocol Day {
  func part1 (_ input :[String]) throws -> String
  func part2 (_ input :[String]) throws -> String
}

@main
struct Advent2023 : ParsableCommand {
  @Argument(help: "The number of the day to run.")
  var day :Int = 1

  @Flag(name: [.long, .customShort("e")], help: "Use example data rather than real data.")
  var example = false

  mutating func run () throws {
    let prefix = example ? "Input/example" : "Input/day"
    let input = try tryReadFile("\(prefix)\(day).txt")
    let inputA = try tryReadFile("\(prefix)\(day)a.txt") ?? input ?? [""]
    let inputB = try tryReadFile("\(prefix)\(day)b.txt") ?? input ?? [""]
    switch day {
    case 1: try compute(day, Day1(), inputA, inputB)
    case 2: try compute(day, Day2(), inputA, inputB)
    // case 3: try compute(day, Day3())
    // case 4: try compute(day, Day4())
    // case 5: try compute(day, Day5())
    // case 6: try compute(day, Day6())
    // case 7: try compute(day, Day7())
    // case 8: try compute(day, Day8())
    // case 9: try compute(day, Day9())
    // case 10: try compute(day, Day10())
    // case 11: try compute(day, Day11())
    // case 12: try compute(day, Day12())
    // case 13: try compute(day, Day13())
    // case 14: try compute(day, Day14())
    // case 15: try compute(day, Day15())
    // case 16: try compute(day, Day16())
    // case 17: try compute(day, Day17())
    // case 18: try compute(day, Day18())
    // case 19: try compute(day, Day19())
    // case 20: try compute(day, Day20())
    // case 21: try compute(day, Day21())
    // case 22: try compute(day, Day22())
    // case 23: try compute(day, Day23())
    // case 24: try compute(day, Day24())
    // case 25: try compute(day, Day25())
    default:
      print("No solution for day \(day) yet.")
    }
  }

  func compute (_ dayNo :Int, _ day :Day, _ inputA :[String], _ inputB :[String]) throws {
    let r1 = try day.part1(inputA)
    print("Day \(dayNo), part 1: \(r1)")
    let r2 = try day.part2(inputB)
    print("Day \(dayNo), part 2: \(r2)")
  }
}
