struct Day17 : Day {
    let pieces :[[[Int8]]] = [
        [[1, 1, 1, 1]],
        [[0, 1, 0], [1, 1, 1], [0, 1, 0]],
        [[1, 1, 1], [0, 0, 1], [0, 0, 1]],
        [[1], [1], [1], [1]],
        [[1, 1], [1, 1]],
    ]
    let sampleInput = ">>><<><>><<<>><>>><<<>>><<<><<<>><>><<>>"

    struct Chamber {
        static let width = 7, height = 300
        var grid = [Int8](repeating: 0, count: width*height)
        var blank = [Int8](repeating: 0, count: width*100)
        var offset = 0

        private mutating func shiftDown () {
            let width = Chamber.width
            if findEmpty(0) > 200 {
                grid.replaceSubrange(0..<200*width, with: grid[100*width..<300*width])
                grid.replaceSubrange(200*width..<300*width, with: blank)
                offset += 100
            }
        }

        private func row (_ row :Int) -> ArraySlice<Int8> { grid.dropFirst(row*Chamber.width).prefix(Chamber.width) }
        private func cell (_ row :Int, _ col :Int) -> Int8 { grid[row*Chamber.width+col] }
        private mutating func setCell (_ row :Int, _ col :Int, _ v :Int8) { grid[row*Chamber.width+col] = v }

        var height :Int { findEmpty(0) + offset }

        private func findEmpty (_ fromRow :Int) -> Int {
            func occupied (_ row :Int) -> Bool {
                for cc in self.row(row) { if cc != 0 { return true }}
                return false
            }
            var empty = fromRow ; while empty < Chamber.height {
                if occupied(empty) { empty += 1 }
                else { break }
            }
            return empty
        }

        private mutating func blow (_ pstart :Int, _ pheight :Int, _ wind :Character) {
            let left = wind == "<"
            let sc = left ? 0 : Chamber.width-1, ec = left ? Chamber.width-1 : 0
            let dc = left ? 1 : -1
            // if any cells on the edge of the piece cannot be blown over, do nothing
            for prow in pstart ..< pstart+pheight {
                var cc = sc ; while (cc != ec) {
                    if cell(prow, cc+dc) == 1 {
                        if cell(prow, cc) != 0 { return }
                        else { break }
                    }
                    cc += dc
                }
            }
            // otherwise shift everything over
            for prow in pstart ..< pstart+pheight {
                var cc = sc ; while (cc != ec) {
                    if cell(prow, cc+dc) == 1 {
                        setCell(prow, cc, 1)
                        setCell(prow, cc+dc, 0)
                    }
                    cc += dc
                }
            }
        }

        private mutating func drop (_ pstart :Int, _ pheight :Int) -> Bool {
            if pstart == 0 { return true }
            // if any cells on the bottom edge of the piece can't drop, we landed
            for cc in 0 ..< Chamber.width {
                for rr in pstart ..< pstart+pheight {
                    if cell(rr, cc) == 1 && cell(rr-1, cc) == 2 { return true }
                }
            }
            for prow in pstart ..< pstart+pheight {
                for cc in 0 ..< Chamber.width {
                    if cell(prow, cc) == 1 {
                        setCell(prow-1, cc, 1)
                        setCell(prow, cc, 0)
                    }
                }
            }
            return false
        }

        mutating func add (piece :[[Int8]], _ wind :String, _ wpos :inout Int) {
            let firstEmpty = findEmpty(0)
            var pstart = firstEmpty+3
            var row = pstart ; for prow in piece {
                let offset = row*Chamber.width + 2
                grid.replaceSubrange(offset ..< offset+prow.count, with: prow)
                row += 1
            }

            let pheight = piece.count
            var landed = false
            while !landed {
                blow(pstart, pheight, wind[wind.index(wind.startIndex, offsetBy: wpos)])
                wpos = (wpos + 1) % wind.count
                landed = drop(pstart, pheight)
                if landed {
                    for row in pstart ..< pstart+piece.count {
                        for cc in 0 ..< Chamber.width {
                            if cell(row, cc) == 1 { setCell(row, cc, 2) }
                        }
                    }
                } else { pstart -= 1 }
            }
            shiftDown()
        }
    }

    func part1 () throws -> String {
        let wind = try readInput(17)[0]
        var wpos = 0, ppos = 0
        var chamber = Chamber()
        for _ in 0 ..< 2022 {
            chamber.add(piece: pieces[ppos], wind, &wpos)
            ppos = (ppos + 1) % pieces.count
        }
        return String(chamber.height)
    }

    func part2 () throws -> String {
        let wind = try readInput(17)[0]
        var wpos = 0, ppos = 0
        var chamber = Chamber()
        var zeros = [(Int, Int, Int)]()
        let max = 1000000000000
        var ii = 0 ; while ii < max {
            chamber.add(piece: pieces[ppos], wind, &wpos)
            ii += 1
            if ppos == 0 && ii < max/2 {
                let height = chamber.height
                // if we see a repeat of the same wind position on piece 0 (twice in a row) then we've detected a cycle
                if let cc = zeros.firstIndex(where: { $0.0 == wpos }), zeros[cc-1].0 == zeros.last!.0 {
                    let (_, cii, cheight) = zeros[cc]
                    let cycle = ii-cii, cycles = (max-ii)/cycle
                    chamber.offset += cycles * (height-cheight)
                    ii += cycles * cycle
                } else {
                    zeros.append((wpos, ii, height))
                }
            }
            ppos = (ppos + 1) % pieces.count
        }
        return String(chamber.height)
    }
}
