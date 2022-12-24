struct Day22 : Day {

    let sampleInput = [
        "        ...#",
        "        .#..",
        "        #...",
        "        ....",
        "...#.......#",
        "........#...",
        "..#....#....",
        "..........#.",
        "        ...#....",
        "        .....#..",
        "        .#......",
        "        ......#.",
        "",
        "10R5L5R10L4R5L5"
    ]

    enum Seg {
        case move (_ n :Int)
        case turn (_ n :Int) // 1 = right, -1 left
    }

    struct Map {
        let side :Int
        let cells :[[UInt8]]
        let cube :Bool
        let width :Int, height :Int
        let start :(Int, Int)
        let geom :[((Int, Int), Int, (Int, Int), Int)]

        init (_ cells :[[UInt8]], _ side :Int, _ cube :Bool) {
            self.side = side
            self.cells = cells
            self.cube = cube
            width = cells.map({ $0.count }).max()!
            height = cells.count
            start = (cells[0].firstIndex(of: 1)!, 0)
            geom = side == 50 ? [
                ((1, 1), 2, (0, 2), 3),
                ((0, 3), 2, (1, 0), 3),
                ((1, 1), 0, (2, 0), 3),
                ((0, 3), 0, (1, 2), 3),
                ((1, 0), 2, (0, 2), 2),
                ((2, 0), 0, (1, 2), 2),
                ((2, 0), 3, (0, 3), 0),
            ] : [
                ((2, 0), 0, (3, 2), 2),
                ((0, 1), 1, (2, 2), 2),
                ((2, 0), 3, (0, 1), 2),
                ((2, 0), 2, (1, 1), 3),
                ((1, 1), 1, (2, 2), 3),
                ((3, 2), 1, (0, 1), 3),
                ((3, 2), 3, (2, 1), 3),
            ]
        }

        func at (_ x :Int, _ y :Int) -> UInt8 {
            let row = cells[y]
            return row.count <= x ? 0 : row[x]
        }

        private static let deltas = [(1, 0), (0, 1), (-1, 0), (0, -1)]
        private func step (_ x :inout Int, _ y :inout Int, _ orient :inout Int) {
            let (dx, dy) = Map.deltas[orient]
            let of = (x / side, y / side)
            x = (x + dx + width) % width
            y = (y + dy + height) % height

            if cube && of != (x / side, y / side) {
                let sfx = x % side, sfy = y % side
                func cross (_ df :(Int, Int), _ turn :Int) {
                    let xo = df.0*side, yo = df.1*side
                    switch turn {
                    case 0: x = xo + sfx        ; y = yo + sfy
                    case 1: x = xo + side-sfy-1 ; y = yo + sfx
                    case 2: x = xo + side-sfx-1 ; y = yo + side-sfy-1
                    case 3: x = xo + sfy        ; y = yo + side-sfx-1
                    default: break
                    }
                    orient = (orient + turn) % 4
                }

                for (sf, sorient, df, turn) in geom {
                    if                   of == sf && orient == sorient { cross(df, turn) }
                    else if turn == 3 && of == df && orient == (sorient+1)%4 { cross(sf, 1) }
                    else if turn == 2 && of == df && orient == sorient { cross(sf, 2) }
                    else if turn == 0 && of == df && orient == 1 { cross(sf, 0) }
                    else { continue }
                    break
                }
            }
        }

        func next (_ pos :inout (Int, Int), _ orient :inout Int, _ count :Int) {
            var nx = pos.0, ny = pos.1, no = orient
            for _ in 0 ..< count {
                step(&nx, &ny, &no)
                while !cube && at(nx, ny) == 0 { step(&nx, &ny, &no) }
                if at(nx, ny) == 2 { return }
                pos = (nx, ny)
                orient = no
            }
        }

        func follow (_ segs :[Seg], _ start :(Int, Int), _ sorient :Int) -> Int {
            var pos = start, orient = sorient
            for seg in segs {
                switch seg {
                case let .move(n): next(&pos, &orient, n)
                case let .turn(n): orient = (orient + n + 4) % 4
                }
            }
            return (pos.1+1) * 1000 + (pos.0+1) * 4 + orient
        }
    }

    func parseNotes (_ input :[String], _ side :Int, _ cube :Bool) -> (Map, [Seg]) {
        let codes :[Character: UInt8] = [" ": 0, ".": 1, "#": 2]
        let blankIdx = input.firstIndex(of: "")!
        func parse (acc :[Seg], c :Character) -> [Seg] {
            if c == "R" { return acc + [.turn(1)] }
            else if c == "L" { return acc + [.turn(-1)] }
            else if case let .move(n) = acc.last { return acc.prefix(acc.count-1) + [.move(n*10+c.wholeNumberValue!)] }
            else { return acc + [.move(c.wholeNumberValue!)] }
        }
        return (Map(input.prefix(blankIdx).map({ $0.map({ c in codes[c]! }) }), side, cube),
                input[blankIdx+1].reduce([Seg](), parse))
    }


    func part1 () throws -> String {
        let (map, moves) = parseNotes(try readInput(22), 50, false)
        return String(map.follow(moves, map.start, 0))
    }

    func part2 () throws -> String {
        let (map, moves) = parseNotes(try readInput(22), 50, true)
        return String(map.follow(moves, map.start, 0))
     }
}
