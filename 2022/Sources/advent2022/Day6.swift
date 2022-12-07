import Algorithms

struct Day6 : Day {
    let sampleInput = "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"

    func startMarker (_ input :String, _ size :Int) -> Int {
        let windows = input.windows(ofCount: size)
        let first = windows.firstIndex(where: { Set($0).count == $0.count })!
        return windows.distance(from: windows.startIndex, to: first) + size
    }

    func startMarker2 (_ input :String, _ size :Int) -> Int {
        for start in input.indices {
            let end = input.index(start, offsetBy: size)
            if Set(input[start..<end]).count == size { return input.distance(from: input.startIndex, to: end) }
        }
        return 0
    }

    func part1 () throws -> String { String(startMarker2(try readInput(6)[0], 4)) }
    func part2 () throws -> String { String(startMarker2(try readInput(6)[0], 14)) }
}
