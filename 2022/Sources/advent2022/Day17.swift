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

        mutating func shiftDown () {
            let width = Chamber.width
            if findEmpty(0) > 200 {
                grid.replaceSubrange(0..<200*width, with: grid[100*width..<300*width])
                grid.replaceSubrange(200*width..<300*width, with: blank)
                offset += 100
            }
        }

        func cell (_ row :Int, _ col :Int) -> Int8 { grid[row*Chamber.width+col] }
        mutating func setCell (_ row :Int, _ col :Int, _ v :Int8) { grid[row*Chamber.width+col] = v }

        func occupied (_ row :Int) -> Bool {
            var ii = 0 ; while ii < Chamber.width {
                if cell(row, ii) != 0 { return true }
                ii += 1
            }
            return false
        }

        func findEmpty (_ fromRow :Int) -> Int {
            var empty = fromRow ; while empty < Chamber.height {
                if occupied(empty) { empty += 1 }
                else { break }
            }
            return empty
        }

        mutating func blow (_ pstart :Int, _ pheight :Int, _ wind :Character) {
            let left = wind == "<"
            let sc = left ? 0 : Chamber.width-1, ec = left ? Chamber.width-1 : 0
            let dc = left ? 1 : -1

            var dr = 0 ; while dr < pheight {
                let prow = pstart+dr
                var cc = sc ; while (cc != ec) {
                    if cell(prow, cc+dc) == 1 {
                        if cell(prow, cc) != 0 { return }
                        else { break }
                    }
                    cc += dc
                }
                dr += 1
            }

            dr = 0 ; while dr < pheight {
                let prow = pstart+dr
                var cc = sc ; while (cc != ec) {
                    if cell(prow, cc+dc) == 1 {
                        setCell(prow, cc, 1)
                        setCell(prow, cc+dc, 0)
                    }
                    cc += dc
                }
                dr += 1
            }
        }

        mutating func drop (_ pstart :Int, _ pheight :Int) -> Bool {
            if pstart == 0 { return true }
            var cc = 0 ; while (cc < Chamber.width) {
                var rr = pstart ; while (rr < pstart+pheight) {
                    if cell(rr, cc) == 1 && cell(rr-1, cc) == 2 { return true }
                    rr += 1
                }
                cc += 1
            }
            var dr = 0 ; while dr < pheight {
                var cc = 0 ; while (cc < Chamber.width) {
                    if cell(pstart+dr, cc) == 1 {
                        setCell(pstart+dr-1, cc, 1)
                        setCell(pstart+dr, cc, 0)
                    }
                    cc += 1
                }
                dr += 1
            }
            return false
        }

        mutating func add (piece :[[Int8]], _ wind :String, _ wpos :inout Int) {
            let firstEmpty = findEmpty(0)
            let pheight = piece.count
            var pstart = firstEmpty+3
            var row = pstart ; for prow in piece {
                var cc = 0, ll = prow.count ; while (cc < ll) {
                    setCell(row, cc+2, prow[cc])
                    cc += 1
                }
                row += 1
            }

            var landed = false
            while !landed {
                blow(pstart, pheight, wind[wind.index(wind.startIndex, offsetBy: wpos)])
                wpos = (wpos + 1) % wind.count
                landed = drop(pstart, pheight)
                if landed {
                    var row = pstart ; for prow in piece {
                        var cc = 0 ; while (cc < Chamber.width) {
                            if cell(row, cc) == 1 { setCell(row, cc, 2) }
                            cc += 1
                        }
                        row += 1
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
            chamber.add(piece: pieces[ppos % pieces.count], wind, &wpos)
            ppos += 1
        }
        return String(chamber.findEmpty(0) + chamber.offset)
    }

    func part2 () throws -> String {
        let wind = try readInput(17)[0]
        var wpos = 0, ppos = 0
        var chamber = Chamber()
        var cycle = 0, cheight = 0
        let max = 1000000000000
        var ii = 0 ; while ii < max {
            chamber.add(piece: pieces[ppos], wind, &wpos)
            ii += 1
            if ppos == 0 && wpos == 22 { // TODO: detect first cycle
                let top = chamber.findEmpty(0)+chamber.offset
                if cycle == 0 {
                    cycle = ii
                    cheight = top
                } else {
                    cycle = ii-cycle
                    cheight = top-cheight
                    let remain = max-ii
                    let cycles = remain/cycle
                    chamber.offset += cycles * cheight
                    ii += cycles * cycle
                }
            }
            ppos = (ppos + 1) % pieces.count
        }
        return String(chamber.findEmpty(0) + chamber.offset)
    }
}
