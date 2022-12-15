struct Day13 : Day {

    enum Input : Equatable {
        case single (_ value :Int)
        case list (_ values :[Input])
    }

    func parseInput (_ line :String) -> Input {
        var pos :Substring = Substring(line)
        func parse () -> Input {
            if pos[pos.startIndex] == "[" {
                var values = [Input]()
                repeat {
                    pos = pos.suffix(from: pos.index(pos.startIndex, offsetBy: 1)) // skip [ or ,
                    if pos[pos.startIndex] != "]" { values.append(parse()) }
                } while pos[pos.startIndex] == ","
                pos = pos.suffix(from: pos.index(pos.startIndex, offsetBy: 1)) // skip ]
                return .list(values)
            } else {
                let num = pos.prefix(while: { $0.isNumber })
                pos = pos.suffix(from: pos.index(pos.startIndex, offsetBy: num.count))
                return .single(Int(num)!)
            }
        }
        return parse()
    }

    func parsePairs (_ path :String) throws -> [(Input, Input)] {
        let data = try String(contentsOfFile: path, encoding: .utf8)
        func parsePair (_ pair :String) -> (Input, Input) {
            let parts = pair.components(separatedBy: .newlines)
            return (parseInput(parts[0]), parseInput(parts[1]))
        }
        return data.components(separatedBy: "\n\n").map(parsePair)
    }

    func compare (_ i1 :Input, _ i2 :Input) -> Int {
        switch i1 {
        case let .single(v1):
            switch i2 {
            case let .single(v2): return v1 - v2
            case .list: return compare(.list([i1]), i2)
            }
        case let .list(l1):
            switch i2 {
            case .single: return compare(i1, .list([i2]))
            case let .list(l2):
                for ii in l1.indices {
                    if l2.count <= ii { return 1 }
                    let cmp = compare(l1[ii], l2[ii])
                    if cmp != 0 { return cmp }
                }
                return l1.count == l2.count ? 0 : -1
            }
        }
    }

    func part1 () throws -> String { String(try parsePairs("Input/day13.txt").enumerated().map({
        (ii, pp) in compare(pp.0, pp.1) < 0 ? ii+1 : 0 }).reduce(0, +)) }

    func part2 () throws -> String {
        var inputs = try readInput(13).filter({ $0 != "" }).map(parseInput)
        let div1 = Input.list([.list([.single(2)])]), div2 = Input.list([.list([.single(6)])])
        inputs += [div1, div2]
        inputs.sort(by: { compare($0, $1) <= 0 })
        return String((1+inputs.firstIndex(of: div1)!) * (1+inputs.firstIndex(of: div2)!))
     }
}