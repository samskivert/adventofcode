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
        var bounds = 0...0
        var spill = 0...0
        var count = 0

        var covered :Int { span(bounds) + (count > 1 ? span(spill) : 0) }
        var firstGap :Int { count < 2 ? -1 : bounds.upperBound+1 }

        mutating func add (_ range :ClosedRange<Int>) {
            if count == 0 {
                bounds = range
                count = 1
            } else if shouldMerge(bounds, range) {
                bounds = merge(bounds, range)
                if count == 2 && shouldMerge(bounds, spill) {
                    bounds = merge(bounds, spill)
                    count = 1
                }
            } else if count == 1 {
                if range.lowerBound < bounds.lowerBound {
                    spill = bounds
                    bounds = range
                } else {
                    spill = range
                }
                count = 2
            } else if (shouldMerge(spill, range)) {
                spill = merge(spill, range)
                if count == 2 && shouldMerge(bounds, spill) {
                    bounds = merge(bounds, spill)
                    count = 1
                }
            } else {
                print("OVERFLOW!")
            }
        }

        func contains (_ x :Int) -> Bool { bounds.contains(x) || (count > 1 && spill.contains(x)) }

        private func span (_ b :ClosedRange<Int>) -> Int { b.upperBound - b.lowerBound + 1 }
        private func shouldMerge (_ a :ClosedRange<Int>, _ b : ClosedRange<Int>) -> Bool {
            a.overlaps(b) || (a.upperBound+1 == b.lowerBound)
        }
        private func merge (_ a :ClosedRange<Int>, _ b :ClosedRange<Int>) -> ClosedRange<Int> {
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