import ArgumentParser

protocol Day {
  func part1 (_ input :[String]) -> String
  func part2 (_ input :[String]) -> String
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
    default:
      print("No solution for day \(day) yet.")
    }
  }

  func compute (_ dayNo :Int, _ day :Day, _ inputA :[String], _ inputB :[String]) throws {
    print("Day \(dayNo), part 1: \(day.part1(inputA))")
    print("Day \(dayNo), part 2: \(day.part2(inputB))")
  }
}
