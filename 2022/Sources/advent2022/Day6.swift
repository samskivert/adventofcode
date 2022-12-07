import Algorithms

struct Day6 : Day {
    let sampleInput = "nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg"

    func allDifferent (code :String.SubSequence) -> Bool { Set(code).count == code.count }
    func startMarker (_ input :String, _ size :Int) -> Int {
        let windows = input.windows(ofCount: size)
        return windows.distance(from: windows.startIndex, to: windows.firstIndex(where: allDifferent)!) + size
    }

    func part1 () throws -> String { String(startMarker(try readInput(6)[0], 4)) }
    func part2 () throws -> String { String(startMarker(try readInput(6)[0], 14)) }
}
