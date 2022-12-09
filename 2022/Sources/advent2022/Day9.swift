struct Day9 : Day {
    let sampleInput = ["R 4", "U 4", "L 3", "D 1", "R 4", "D 1", "L 5", "R 2"]
    let sampleInput2 = ["R 5", "U 8", "L 8", "D 3", "R 17", "D 10", "L 25", "U 20"]
    func parse (_ input :[String]) -> [(Character, Int)] { input.map { line in
        (line[line.startIndex], Int(line.suffix(from: line.index(line.startIndex, offsetBy: 2)))!)
    }}

    struct Knot :Hashable {
        var x = 0, y = 0
        mutating func move (_ dir :Character) {
            x += dir == "R" ? 1 : dir == "L" ? -1 : 0
            y += dir == "D" ? 1 : dir == "U" ? -1 : 0
        }
        mutating func follow (_ head :Knot) {
            let dx = head.x - x, adx = abs(dx)
            let dy = head.y - y, ady = abs(dy)
            if adx >= 2 || ady >= 2 {
                if adx > 0 { x += dx / adx }
                if ady > 0 { y += dy / ady }
            }
        }
        func hash (into hasher :inout Hasher) { hasher.combine(x) ; hasher.combine(y) }
        static func == (a :Knot, b :Knot) -> Bool { a.x == b.x && a.y == b.y }
    }

    func simulate (_ input :[String], _ length :Int) -> Int {
        var rope = Array(repeating: Knot(), count: length), seen = Set<Knot>()
        for (dir, count) in parse(input) {
            for _ in 0 ..< count {
                rope[0].move(dir)
                for ii in rope.indices.dropFirst(1) {
                    rope[ii].follow(rope[ii-1])
                }
                seen.insert(rope.last!)
            }
        }
        return seen.count
    }

    func plot (_ rope :[Knot]) {
        let xs = rope.map({ $0.x }), minX = xs.min()!, maxX = xs.max()!
        let ys = rope.map({ $0.y }), minY = ys.min()!, maxY = ys.max()!
        for y in minY...maxY {
            var line = ""
            for x in minX...maxX {
                if let ii = rope.firstIndex(of: Knot(x: x, y: y)) { line.append(String(ii)) }
                else { line.append(" ") }
            }
            print(line)
        }
    }

    func part1 () throws -> String { String(simulate(try readInput(9), 2)) }
    func part2 () throws -> String { String(simulate(try readInput(9), 10)) }
}
