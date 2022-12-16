import Foundation
struct Day15 : Day {

    struct Sensor {
        let sx :Int, sy :Int
        let bx :Int, by :Int
        let range :Int

        init (_ sx :Int, _ sy :Int, _ bx :Int, _ by :Int) {
            self.sx = sx ; self.sy = sy
            self.bx = bx ; self.by = by
            range = abs(bx-sx) + abs(by-sy)
        }

        func addTo (_ sparse :inout SparseRange, _ y :Int) {
            let xrange = range - abs(y-sy)
            if xrange >= 0 { sparse.add(sx-xrange, sx+xrange) }
        }
    }

    struct SparseRange {
        var boundsL = 0, boundsU = 0
        var spillL = 0, spillU = 0
        var count = 0

        var covered :Int { span(boundsL, boundsU) + (count > 1 ? span(spillL, spillU) : 0) }
        var firstGap :Int { count < 2 ? -1 : boundsU+1 }

        mutating func add (_ l :Int, _ u :Int) {
            if count == 0 {
                boundsL = l ; boundsU = u
                count = 1
            } else if shouldMerge(boundsL, boundsU, l, u) {
                merge(&boundsL, &boundsU, l, u)
                if count == 2 && shouldMerge(boundsL, boundsU, spillL, spillU) {
                    merge(&boundsL, &boundsU, spillL, spillU)
                    count = 1
                }
            } else if count == 1 {
                if l < boundsL {
                    spillL = boundsL ; spillU = boundsU
                    boundsL = l ; boundsU = u
                } else {
                    spillL = l ; spillU = u
                }
                count = 2
            } else if (shouldMerge(spillL, spillU, l, u)) {
                merge(&spillL, &spillU, l, u)
                if count == 2 && shouldMerge(boundsL, boundsU, spillL, spillU) {
                    merge(&boundsL, &boundsU, spillL, spillU)
                    count = 1
                }
            } else {
                print("OVERFLOW!")
            }
        }

        func contains (_ x :Int) -> Bool { contains(boundsL, boundsU, x) || (count > 1 && contains(spillL, spillU, x)) }

        private func span (_ bl :Int, _ bu :Int) -> Int { bu - bl + 1 }
        private func contains (_ al :Int, _ au :Int, _ v :Int) -> Bool { al <= v && au >= v }
        private func overlaps (_ al :Int, _ au :Int, _ bl :Int, _ bu :Int) -> Bool { contains(al, au, bl) || contains(bl, bu, au) }
        private func shouldMerge (_ al :Int, _ au :Int, _ bl :Int, _ bu :Int) -> Bool { overlaps(al, au, bl, bu) || (au+1 == bl) }
        private func merge (_ al :inout Int, _ au :inout Int, _ bl :Int, _ bu :Int) {
            al = min(al, bl)
            au = max(au, bu)
        }
    }

    let pattern = #"Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)"#
    func parse (_ input :String) throws -> Sensor {
        let regex = try NSRegularExpression(pattern: pattern)
        let nsrange = NSRange(input.startIndex ..< input.endIndex, in: input)
        let matches = regex.matches(in: input, options: [], range: nsrange)
        guard let match = matches.first else { return Sensor(0, 0, 0, 0) }
        func group (_ num :Int) -> Int { Int(input[Range(match.range(at: num), in: input)!])! }
        return Sensor(group(1), group(2), group(3), group(4))
    }

    func part1 () throws -> String {
        var sensors = try readInput(15).map(parse)
        sensors.sort(by: { $0.sx < $1.sx })
        let y = 2000000
        var sparse = SparseRange()
        for s in sensors { s.addTo(&sparse, y) }
        let skip = Set(
            sensors.filter({ $0.sy == y && sparse.contains($0.sx) }).map({ $0.sx }) +
            sensors.filter({ $0.by == y && sparse.contains($0.bx) }).map({ $0.bx }))
        return String(sparse.covered - skip.count)
    }

    func part2 () throws -> String {
        var sensors = try readInput(15).map(parse)
        sensors.sort(by: { $0.sx < $1.sx })
        let max = 4000000
        for y in 0 ... max {
            var sparse = SparseRange()
            for s in sensors { s.addTo(&sparse, y) }
            let x = sparse.firstGap
            if x >= 0 && x <= max { return String(x * 4000000 + y) }
        }
        return "?"
    }
}