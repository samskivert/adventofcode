struct Day1 : Day {
    let sampleInput = [
        "1000", "2000", "3000", "", "4000", "", "5000", "6000", "", "7000", "8000", "9000", "", "10000"
    ]
    func readElves (_ lines :[String]) throws -> [Int] { lines.reduce([0], { es, elem in
        elem == "" ? es + [0] : es.prefix(es.count-1) + [es.last! + Int(elem)!]
    })}

    func part1 () throws -> String { String(try readElves(try readInput(1)).max()!) }

    func part2 () throws -> String {
        var elves = try readElves(try readInput(1))
        elves.sort(by: >)
        return String(elves.prefix(3).reduce(0, +))
     }
}
