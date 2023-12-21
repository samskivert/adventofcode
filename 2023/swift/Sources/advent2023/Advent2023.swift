import ArgumentParser

protocol Day {
  associatedtype R1
  associatedtype R2
  func part1 (_ input :[String]) -> R1
  func part2 (_ input :[String]) -> R2
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
    case 3: try compute(day, Day3(), inputA, inputB)
    case 4: try compute(day, Day4(), inputA, inputB)
    case 5: try compute(day, Day5(), inputA, inputB)
    case 6: try compute(day, Day6(), inputA, inputB)
    case 7: try compute(day, Day7(), inputA, inputB)
    case 8: try compute(day, Day8(), inputA, inputB)
    case 9: try compute(day, Day9(), inputA, inputB)
    case 10: try compute(day, Day10(), inputA, inputB)
    case 11: try compute(day, Day11(), inputA, inputB)
    case 12: try compute(day, Day12(), inputA, inputB)
    case 13: try compute(day, Day13(), inputA, inputB)
    case 14: try compute(day, Day14(), inputA, inputB)
    case 15: try compute(day, Day15(), inputA, inputB)
    case 16: try compute(day, Day16(), inputA, inputB)
    case 17: try compute(day, Day17(), inputA, inputB)
    default:
      print("No solution for day \(day) yet.")
    }
  }

  func compute (_ dayNo :Int, _ day :any Day, _ inputA :[String], _ inputB :[String]) throws {
    print("Day \(dayNo), part 1: \(day.part1(inputA))")
    print("Day \(dayNo), part 2: \(day.part2(inputB))")
  }
}
