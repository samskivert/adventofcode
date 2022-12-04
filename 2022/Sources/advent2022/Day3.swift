struct Day3 : Day {

    let sampleInput = [
        "vJrwpWtwJgWrhcsFMMfFFhFp",
        "jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL",
        "PmmdzqPrVvPwwTWBwg",
        "wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn",
        "ttgJtRGJQctTZtZT",
        "CrZsJsPPZsGzwwsLwLmpwMDw"
    ]

    func split (_ sack :String) -> (Set<Character>, Set<Character>) {
        (Set(sack.prefix(sack.count/2)), Set(sack.suffix(sack.count/2)))
    }
    func mispacked (_ left :Set<Character>, _ right :Set<Character>) -> Character {
        left.first(where: { right.contains($0) }) ?? "🤔"
    }
    func priority (_ c :Character) -> Int {
        if let v = c.asciiValue { return (Int)(v >= 97 ? v - 96 : (v - 38))  }
        else { return 0 }
    }

    func part1 () throws -> Int { try readInput(3).map(split).map(mispacked).map(priority).reduce(0, +) }

    func badge (_ sacks :[Set<Character>]) -> Character {
        sacks[0].first(where: { c in sacks.suffix(from: 1).allSatisfy({ $0.contains(c) }) }) ?? "🤔"
    }

    func part2 () throws -> Int { 
        try readInput(3).map({ Set($0) }).chunked(by: 3).map(badge).map(priority).reduce(0, +)
    }
}
