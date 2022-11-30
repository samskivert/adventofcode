import ArgumentParser

protocol Day {
    func compute () -> Int
}

@main
struct Advent2022 : ParsableCommand {
    @Argument(help: "The number of the day to run.")
    var day :Int = 1

    mutating func run () throws {
        switch day {
        case 1: compute(day, Day1())
        default:    
            print("No solution for day \(day) yet.")
        }
    }

    func compute (_ dayNo :Int, _ day :Day) {
        print("Day \(dayNo): \(day.compute())")
    }
}
