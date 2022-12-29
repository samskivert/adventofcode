struct Day23 : Day {
    let sampleInput = [
        "..............",
        "..............",
        ".......#......",
        ".....###.#....",
        "...#...#.#....",
        "....#...##....",
        "...#.###......",
        "...##.#.##....",
        "....#..#......",
        "..............",
        "..............",
        "..............",
    ]

    struct Pos : Hashable {
        let x, y :Int
        init (_ x :Int, _ y :Int) { self.x = x ; self.y = y }
        func plus (_ dx :Int, _ dy :Int) -> Pos { Pos(x+dx, y+dy) }
        func hash (into :inout Hasher) { into.combine(x) ; into.combine(y) }
        func anyNs (_ op :(Pos) -> Bool) -> Bool {
            for (dx, dy) in ndeltas { if op(Pos(x+dx, y+dy)) { return true }}
            return false
        }
        static func == (a: Pos, b: Pos) -> Bool { return a.x == b.x && a.y == b.y }
    }
    static let ndeltas = [(-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1)]

    func parseElves (_ input :[String]) -> Set<Pos> {
        var elves = Set<Pos>()
        for y in input.indices {
            var x = 0 ; for c in input[y] {
                if c == "#" { elves.insert(Pos(x, y)) }
                x += 1
            }
        }
        return elves
    }

    static let moves = [(0, -1, 1, 0), (0, 1, 1, 0), (-1, 0, 0, 1), (1, 0, 0, 1)]

    @discardableResult func diffuse (_ elves :inout Set<Pos>, _ round :Int) -> Int {
        var moves = [Pos: Pos]()
        var proposals = [Pos: Int]()
        for pos in elves {
            if !pos.anyNs({ elves.contains($0) }) { continue }
            for mm in Day23.moves.indices {
                let (mx, my, dx, dy) = Day23.moves[(mm+round) % Day23.moves.count]
                let mpos = pos.plus(mx, my)
                if elves.contains(mpos) || elves.contains(mpos.plus(dx, dy)) || elves.contains(mpos.plus(-dx, -dy)) { continue }
                proposals[mpos] = (proposals[mpos] ?? 0) + 1
                moves[pos] = mpos
                break
            }
        }
        for (pos, mpos) in moves {
            if let count = proposals[mpos], count > 1 {
                moves.removeValue(forKey: pos)
            } else {
                elves.remove(pos)
                elves.insert(mpos)
            }
        }
        return moves.count
    }

    func bounds (_ elves :Set<Pos>) -> (Pos, Pos) {
        var minx = elves.first!.x, miny = elves.first!.y, maxx = minx, maxy = miny
        for pos in elves {
            minx = min(minx, pos.x)
            miny = min(miny, pos.y)
            maxx = max(maxx, pos.x)
            maxy = max(maxy, pos.y)
        }
        return (Pos(minx, miny), Pos(maxx, maxy))
    }

    func area (_ elves :Set<Pos>) -> Int {
        let (min, max) = bounds(elves)
        return (max.x - min.x + 1) * (max.y - min.y + 1)
    }

    func part1 () throws -> String {
        var elves = parseElves(try readInput(23))
        for rr in 0 ..< 10 { diffuse(&elves, rr) }
        return String(area(elves)-elves.count)
    }

    func part2 () throws -> String {
        var elves = parseElves(try readInput(23))
        var rr = 0 ; while diffuse(&elves, rr) > 0 { rr += 1 }
        return String(rr+1)
     }
}
