struct Day4 : Day {

    let sampleInput = [
        "2-4,6-8",
        "2-3,4-5",
        "5-7,7-9",
        "2-8,3-7",
        "6-6,4-6",
        "2-6,4-8"
    ]

    func parse (line :String) -> ((Int, Int), (Int, Int)) {
        let ranges = line.split(separator: ",").map({ range in 
            let parts = range.split(separator: "-")
            return (Int(parts[0])!, Int(parts[1])!)
        })
        return (ranges[0], ranges[1])
    }

    func subsumes (_ r1 :(Int, Int), _ r2: (Int, Int)) -> Bool { 
        (r1.0 <= r2.0 && r1.1 >= r2.1) || (r2.0 <= r1.0 && r2.1 >= r1.1)
    }
    func part1 () throws -> String { String(try readInput(4).map(parse).filter(subsumes).count) }

    func contains (_ r :(Int, Int), _ n :Int) -> Bool { r.0 <= n && r.1 >= n }
    func overlaps (_ r1 :(Int, Int), _ r2: (Int, Int)) -> Bool {
        contains(r1, r2.0) || contains(r1, r2.1) || contains(r2, r1.0) || contains(r2, r1.1)
    }
    func part2 () throws -> String { String(try readInput(4).map(parse).filter(overlaps).count) }
}
