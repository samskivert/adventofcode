struct Day14 : Day {
    let sampleInput = [
        "498,4 -> 498,6 -> 496,6",
        "503,4 -> 502,4 -> 502,9 -> 494,9",
    ]

    struct Pos : Hashable {
        var x, y :Int

        func below (_ dx :Int) -> Pos { Pos(x: x+dx, y: y+1) }
        func apply (_ to :Pos, _ op :(Pos) -> Void) {
            let dx = (to.x-x).signum(), dy = (to.y-y).signum()
            var pos = self
            while pos != to { op(pos) ; pos.x += dx ; pos.y += dy }
            op(pos)
        }

        func hash (into :inout Hasher) { into.combine(x) ; into.combine(y) }
        static func == (a: Pos, b: Pos) -> Bool { return a.x == b.x && a.y == b.y }
    }

    func parse (_ line :String) -> [Pos] { line.components(separatedBy: " -> ").map({ text in
        let parts = text.split(separator: ",")
        return Pos(x: Int(parts[0])!, y: Int(parts[1])!)
    }) }

    func flow (_ input :[String], _ entry :Pos, _ useFloor :Bool) -> Int {
        var cave = [Pos :Character]()
        for verts in input.map(parse) {
            for ii in verts.indices.suffix(from: 1) {
                verts[ii-1].apply(verts[ii], { cave[$0] = "#" })
            }
        }

        let rocks = cave.count
        let maxY = cave.keys.map({ $0.y }).max()!
        func drop (_ pos :Pos) -> Pos? {
            if !useFloor && pos.y >= maxY { return nil }
            if useFloor && pos.y >= maxY+1 { return pos }
            for dx in [0, -1, 1] {
                if cave[pos.below(dx)] == nil { return drop(pos.below(dx)) }
            }
            return pos
        }

        while let pos = drop(entry) {
            cave[pos] = "O"
            if pos == entry { break }
        }
        return cave.count-rocks
    }

    func part1 () throws -> String { String(flow(try readInput(14), Pos(x: 500, y: 0), false)) }
    func part2 () throws -> String { String(flow(try readInput(14), Pos(x: 500, y: 0), true)) }
}
