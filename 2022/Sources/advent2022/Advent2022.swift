import ArgumentParser

protocol Day {
    func part1 () throws -> Int
    func part2 () throws -> Int
}

@main
struct Advent2022 : ParsableCommand {
    @Argument(help: "The number of the day to run.")
    var day :Int = 3

    mutating func run () throws {
        switch day {
        case 1: try compute(day, Day1())
        case 2: try compute(day, Day2())
        case 3: try compute(day, Day3())
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
