struct Day5 : Day {

    let sampleInput = [
        "    [D]    ",
        "[N] [C]    ",
        "[Z] [M] [P]",
        " 1   2   3 ",
        "",
        "move 1 from 2 to 1",
        "move 3 from 1 to 3",
        "move 2 from 2 to 1",
        "move 1 from 1 to 2",
    ]

    func parseStacks (_ input :[String]) -> [[Character]] {
        var stacks = (0 ... (input[0].count/4)).map({ _ in [Character]() })
        for line in input.prefix(while: { $0.firstIndex(of: "[") != nil }) {
            var ii = 0
            while let lpos = line.index(line.startIndex, offsetBy: ii*4+1, limitedBy: line.endIndex) {
                if stacks.count <= ii { stacks.append([Character]()) }
                let crate = line[lpos]
                if crate != " " { stacks[ii].insert(crate, at: 0) }
                ii += 1
            }
        }
        return stacks
    }

    func execute (_ input :[String], _ move :(inout [[Character]], Int, Int, Int) -> Void) -> String {
        var stacks = parseStacks(input)
        for line in input.lazy.filter({ $0.starts(with: "move ") }) {
            let parts = line.split(separator: " ")
            move(&stacks, Int(parts[1])!, Int(parts[3])!-1, Int(parts[5])!-1)
        }
        return stacks.map({ String($0.last!) }).joined(separator: "")
    }

    func move9000 (_ stacks :inout [[Character]], _ count :Int, _ src :Int, _ dest :Int) {
        for _ in 0 ..< count { stacks[dest].append(stacks[src].removeLast()) }
    }
    func part1 () throws -> String { execute(try readInput(5), move9000) }

    func move9001 (_ stacks :inout [[Character]], _ count :Int, _ src :Int, _ dest :Int) {
        stacks[dest] += stacks[src].suffix(count)
        stacks[src].removeSubrange((stacks[src].count-count)...)
    }
    func part2 () throws -> String { execute(try readInput(5), move9001) }
}
