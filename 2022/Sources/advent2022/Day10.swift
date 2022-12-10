struct Day10 : Day {

    func execute (_ input :[String], _ sampler :(Int, Int) -> Void) {
        var reg = 1
        var cycle = 1
        sampler(cycle, reg)
        for line in input {
            cycle += 1
            if line.starts(with: "addx ") {
                sampler(cycle, reg)
                reg += Int(line.dropFirst(5))!
                cycle += 1
            }
            sampler(cycle, reg)   
        }
    }

    func part1 () throws -> String {
        var signal = 0
        execute(try readInput(10), { (cycle, reg) in 
            if (cycle-20) % 40 == 0 { signal += cycle*reg }
        })
        return String(signal)
    }

    func part2 () throws -> String { 
        var lines = [String]()
        execute(try readInput(10), { (cycle, reg) in 
            let line = (cycle-1) / 40
            if line >= lines.count { lines.append(String()) }
            let col = (cycle-1) % 40
            lines[line].append(reg >= col-1 && reg <= col+1 ? "#" : " ")
        })
        return "\n" + lines.joined(separator: "\n")
     }
}
