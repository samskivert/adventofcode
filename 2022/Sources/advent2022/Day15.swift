import Foundation
struct Day15 : Day {

    struct Sensor {
        let sx :Int, sy :Int
        let bx :Int, by :Int

        var range :Int { abs(bx-sx) + abs(by-sy) }
        func addTo (_ sparse :inout SparseRange, _ y :Int) {
            let xrange = range - abs(y-sy)
            if xrange >= 0 { sparse.add((sx-xrange)...(sx+xrange)) }
        }
    }

    struct SparseRange {
        var bounds = [ClosedRange<Int>]()

        var covered :Int { bounds.map({ $0.upperBound - $0.lowerBound + 1 }).reduce(0, +) }
        var firstGap :Int { bounds.count > 1 ? bounds[0].upperBound+1 : -1 }

        mutating func add (_ range :ClosedRange<Int>) {
            for ii in bounds.indices {
                let b = bounds[ii]
                if shouldMerge(b, range) {
                    bounds[ii] = merge(b, range)
                    mergeAll()
                    return
                }
            }
            bounds.append(range)
        }

        mutating func mergeAll () {
            var ii = 0
            while ii < bounds.count-1 {
                if shouldMerge(bounds[ii], bounds[ii+1]) {
                    bounds[ii] = merge(bounds[ii], bounds[ii+1])
                    bounds.remove(at: ii+1)
                }
                ii += 1
            }
        }

        func contains (_ x :Int) -> Bool {
            for b in bounds { if b.contains(x) { return true }}
            return false
        }

        func shouldMerge (_ a :ClosedRange<Int>, _ b : ClosedRange<Int>) -> Bool {
            a.overlaps(b) || (a.upperBound+1 == b.lowerBound)
        }
        func merge (_ a :ClosedRange<Int>, _ b :ClosedRange<Int>) -> ClosedRange<Int> {
            min(a.lowerBound, b.lowerBound) ... max(a.upperBound, b.upperBound)
        }
    }

    let pattern = #"Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)"#
    func parse (_ input :String) throws -> Sensor {
        let regex = try NSRegularExpression(pattern: pattern)
        let nsrange = NSRange(input.startIndex ..< input.endIndex, in: input)
        let matches = regex.matches(in: input, options: [], range: nsrange)
        guard let match = matches.first else { return Sensor(sx: 0, sy: 0, bx: 0, by: 0) }
        func group (_ num :Int) -> Int { Int(input[Range(match.range(at: num), in: input)!])! }
        return Sensor(sx: group(1), sy: group(2), bx: group(3), by: group(4))
    }

    func part1 () throws -> String {
        let sensors = try readInput(15).map(parse)
        let y = 2000000
        var sparse = SparseRange()
        for s in sensors { s.addTo(&sparse, y) }
        let skip = Set(
            sensors.filter({ $0.sy == y && sparse.contains($0.sx) }).map({ $0.sx }) +
            sensors.filter({ $0.by == y && sparse.contains($0.bx) }).map({ $0.bx }))
        return String(sparse.covered - skip.count)
    }

    func part2 () throws -> String {
        let sensors = try readInput(15).map(parse)
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