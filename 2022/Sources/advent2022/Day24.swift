struct Day24 : Day {

    let sampleInput = [
        "#.######",
        "#>>.<^<#",
        "#.<..<<#",
        "#>v.><>#",
        "#<^v^^>#",
        "######.#",
    ]

    enum Move : UInt8, CaseIterable {
        case Wait = 0, Up = 0x1, Right = 0x2, Down = 0x4, Left = 0x8
        var dx :Int { self == .Left ? -1 : self == .Right ? 1 : 0 }
        var dy :Int { self == .Up ? -1 : self == .Down ? 1 : 0 }
    }

    struct Valley {
        let width :Int, height :Int
        let entry :Int, exit :Int
        let cells :[UInt8]

        init (_ input :[String]) {
            width = input[0].count - 2
            height = input.count - 2
            entry = input.first!.firstIndexInt(of: ".")!-1
            exit = input.last!.firstIndexInt(of: ".")!-1
            let cellMap :[Character: Move] = [".": .Wait, ">": .Right, "^": .Up, "v": .Down, "<": .Left]
            var cells = [UInt8](repeating: 0, count: width*height)
            for ii in input.indices {
                let yy = ii-1
                if yy < 0 || yy >= height { continue }
                let line = input[ii]
                let idxS = line.index(line.startIndex, offsetBy: 1)
                let idxE = line.index(line.startIndex, offsetBy: line.count-1)
                cells.replaceSubrange(yy*width..<(yy+1)*width, with: line[idxS..<idxE].map({ cellMap[$0]!.rawValue }))
            }
            self.cells = cells
        }

        func blow (_ cells :[UInt8]) -> [UInt8] {
            var ncells = [UInt8](repeating: 0, count: cells.count)
            for yy in 0 ..< height {
                for xx in 0 ..< width {
                    let cell = cells[yy*width+xx]
                    for dir in Move.allCases {
                        if cell & dir.rawValue != 0 {
                            let nx = (xx + dir.dx + width) % width
                            let ny = (yy + dir.dy + height) % height
                            ncells[ny*width+nx] |= dir.rawValue
                        }
                    }
                }
            }
            return ncells
        }

        func startToExit (_ phases :Int) -> Int {
            route(phases, [(entry, -1), (exit, height)]) }
        func startToExitToStartToExit (_ phases :Int) -> Int {
            route(phases, [(entry, -1), (exit, height), (entry, -1), (exit, height)]) }

        func route (_ phases :Int, _ route :[(Int, Int)]) -> Int {
            var steps = 0, ncells = cells
            for ii in route.indices {
                if ii == route.count-1 { break }
                let (sx, sy) = route[ii], (ex, ey) = route[ii+1]
                let (nncells, psteps) = path(phases, ncells, sx, sy, ex, ey)
                steps += psteps
                ncells = nncells
            }
            return steps
        }

        func path (_ phases :Int, _ cells :[UInt8], _ sx :Int, _ sy :Int, _ ex :Int, _ ey :Int) -> ([UInt8], Int) {
            func phaseCoord (_ x :Int, _ y :Int, _ phase :Int) -> Int { phase * 10000 + x * 100 + y }
            var bests = [Int: Int]()
            func h (_ x :Int, _ y :Int) -> Int { (abs(x-ex) + abs(y-ey)) }
            var nexts = [(cells, sx, sy, 0, h(sx, sy))]
            while nexts.count > 0 {
                let (cells, x, y, steps, _) = nexts.removeFirst()
                let ncells = blow(cells), nsteps = steps+1, phase = nsteps % phases
                for dir in Move.allCases {
                    let nx = x + dir.dx, ny = y + dir.dy
                    if nx == ex && ny == ey { return (ncells, nsteps) }
                    if nx == sx && ny == sy && dir == .Wait {} // allow waiting at start even though it's OOB
                    else if nx < 0 || nx >= width || ny < 0 || ny >= height || ncells[ny*width+nx] != 0 { continue }
                    let ncost = nsteps+h(nx, ny), pcoord = phaseCoord(nx, ny, phase)
                    if let bcost = bests[pcoord], bcost <= ncost { continue }
                    bests[pcoord] = ncost
                    nexts.insertSorted((ncells, nx, ny, nsteps, ncost), { (a, b) in a.4 < b.4 })
                }
            }
            return (cells, 0)
        }
    }

    func part1 () throws -> String { String(Valley(try readInput(24)).startToExit(20)) }
    func part2 () throws -> String { String(Valley(try readInput(24)).startToExitToStartToExit(20)) }
}
