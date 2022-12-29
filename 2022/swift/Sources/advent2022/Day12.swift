struct Day12 : Day {

    let sampleInput = [
        "Sabqponm",
        "abcryxxl",
        "accszExk",
        "acctuvwj",
        "abdefghi" ]

    func grid (_ input :[String]) -> [[Character]] { input.map { Array($0) }}

    struct Pos : Hashable {
        let row, col :Int
        func hash (into :inout Hasher) { into.combine(row) ; into.combine(col) }
        func get (_ grid :[[Character]]) -> Character { grid[row][col] }
        func onNeighbors (op :(Pos) -> Void) {
            for (dr, dc) in ndeltas { op(Pos(row: row+dr, col: col+dc)) }
        }
        static func == (a: Pos, b: Pos) -> Bool { return a.row == b.row && a.col == b.col }
    }
    static let ndeltas = [(-1, 0), (0, -1), (1, 0), (0, 1)]

    func indices (_ input :[[Character]]) -> [Pos] {
        input.indices.flatMap { row in input[row].indices.map { col in Pos(row: row, col: col) } }
    }

    func heightOf (_ c :Character) -> Int { c == "S" ? 0 : c == "E" ? heightOf("z") : Int(c.asciiValue!) - 97 }
    func height (_ elev :[[Character]], _ pos :Pos) -> Int { heightOf(pos.get(elev)) }

    func search (_ elev :[[Character]], _ start :Pos, _ end :Pos) -> Int? {
        var scan = [(start, 0)]
        var minDist = [start: 0]
        let gwidth = elev[0].count, gheight = elev.count
        while (scan.count > 0) {
            let (pos, dist) = scan.removeFirst()
            if pos == end { return dist }
            let h = height(elev, pos), ndist = dist+1
            pos.onNeighbors { npos in
                if npos.row < 0 || npos.col < 0 || npos.row >= gheight || npos.col >= gwidth { return }
                if height(elev, npos) - h > 1 { return }
                if let odist = minDist[npos], odist <= ndist { return }
                minDist[npos] = ndist
                scan.insertSorted((npos, ndist), { (a, b) in a.1 < b.1 })
            }
        }
        return nil
    }

    func pos (_ input :[[Character]], of c :Character) -> Pos {
        indices(input).first(where: { $0.get(input) == c }) ?? Pos(row: 0, col: 0)
    }

    func part1 () throws -> String {
        let elevs = grid(try readInput(12))
        return String(search(elevs, pos(elevs, of: "S"), pos(elevs, of: "E")) ?? 0)
    }

    func part2 () throws -> String {
        let elevs = grid(try readInput(12))
        let starts = indices(elevs).filter({ height(elevs, $0) == 0 }), end = pos(elevs, of: "E")
        return String(starts.compactMap({ search(elevs, $0, end) }).min() ?? 0)
    }
}