import ArgumentParser

protocol Day {
    func part1 () throws -> String
    func part2 () throws -> String
}

@main
struct Advent2022 : ParsableCommand {
    @Argument(help: "The number of the day to run.")
    var day :Int = 8

    mutating func run () throws {
        switch day {
        case 1: try compute(day, Day1())
        case 2: try compute(day, Day2())
        case 3: try compute(day, Day3())
        case 4: try compute(day, Day4())
        case 5: try compute(day, Day5())
        case 6: try compute(day, Day6())
        case 7: try compute(day, Day7())
        case 8: try compute(day, Day8())
        default:    
            print("No solution for day \(day) yet.")
        }
    }

    func compute (_ dayNo :Int, _ day :Day) throws {
        let r1 = try day.part1()
        print("Day \(dayNo), part 1: \(r1)")
        let r2 = try day.part2()
        print("Day \(dayNo), part 2: \(r2)")
}
}
