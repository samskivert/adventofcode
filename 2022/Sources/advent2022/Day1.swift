struct Day1 : Day {
    let sampleInput = [
        "1000", "2000", "3000", "", "4000", "", "5000", "6000", "", "7000", "8000", "9000", "", "10000"
    ]
    func readElves () throws -> [Int] {
        let lines = try readInput(1)
        // let lines = sampleInput
        return lines.reduce([0], { es, elem in
            elem == "" ? es + [0] : es.prefix(es.count-1) + [es.last! + Int(elem)!]
        })
    }

    func part1 () throws -> Int { try readElves().max()! }

    func part2 () throws -> Int { 
        var elves = try readElves()
        elves.sort(by: >)
        return elves.prefix(3).reduce(0, +)
     }
}
