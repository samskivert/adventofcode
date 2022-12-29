import Foundation
struct Day19 : Day {
    let sampleInput = [
        "Blueprint 1: Each ore robot costs 4 ore. Each clay robot costs 2 ore. Each obsidian robot costs 3 ore and 14 clay. " +
          "Each geode robot costs 2 ore and 7 obsidian.",
        "Blueprint 2: Each ore robot costs 2 ore. Each clay robot costs 3 ore. Each obsidian robot costs 3 ore and 8 clay. " +
          "Each geode robot costs 3 ore and 12 obsidian.",
    ]

    struct Cost : CustomStringConvertible {
        var mat0 :UInt8 = 0, mat1 :UInt8 = 0, mat2 :UInt8 = 0
        init (_ m0 :Int, _ m1 :Int, _ m2 :Int) {
            mat0 = UInt8(m0)
            mat1 = UInt8(m1)
            mat2 = UInt8(m2)
        }
        public var description: String { "\(mat0) \(mat1) \(mat2)" }
    }

    struct State {
        var mat0 :UInt8 = 0, mat1 :UInt8 = 0, mat2 :UInt8 = 0, mat3 :UInt8 = 0
        var bot0 :UInt8 = 1, bot1 :UInt8 = 0, bot2 :UInt8 = 0, bot3 :UInt8 = 0

        mutating func collect () {
            mat0 += bot0
            mat1 += bot1
            mat2 += bot2
            mat3 += bot3
        }

        func canMake (_ cost :Cost) -> Bool { mat0 >= cost.mat0 && mat1 >= cost.mat1 && mat2 >= cost.mat2 }

        mutating func make (_ cost :Cost, _ bb :Int) {
            mat0 -= cost.mat0
            mat1 -= cost.mat1
            mat2 -= cost.mat2
            switch (bb) {
            case 0: bot0 += 1
            case 1: bot1 += 1
            case 2: bot2 += 1
            case 3: bot3 += 1
            default: break
            }
        }
    }

    struct Blueprint {
        var id :Int
        var costs :[Cost]

        func quality () -> Int { geodes(24) * id }

        func geodes (_ minutes :Int) -> Int {
            var best = 0
            let max0 = costs.map({ $0.mat0 }).max()!
            func search (_ state :State, _ minutes :Int) {
                var nstate = state
                nstate.collect()

                let nminutes = minutes - 1
                let rest = Int(nstate.mat3) + Int(nstate.bot3)*nminutes
                if rest > best { best = rest }
                if rest + (nminutes * (nminutes-1))/2 < best { return }
                if nminutes == 0 { return }

                var ii = costs.count-1 ; while ii >= 0 {
                    if ii == 2 && state.bot2 >= costs[3].mat2 {}
                    else if ii == 1 && state.bot1 >= costs[2].mat1 {}
                    else if ii == 0 && state.bot0 >= max0 {}
                    else if state.canMake(costs[ii]) {
                        var nnstate = nstate
                        nnstate.make(costs[ii], ii)
                        search(nnstate, nminutes)
                    }
                    ii -= 1
                }
                search(nstate, nminutes)
            }
            search(State(), minutes)
            return best
        }
    }

    func parseBlueprints (_ input :[String]) throws -> [Blueprint] {
        let pattern = #"Blueprint (\d+): Each ore robot costs (\d+) ore. Each clay robot costs (\d+) ore. "# +
          #"Each obsidian robot costs (\d+) ore and (\d+) clay. Each geode robot costs (\d+) ore and (\d+) obsidian."#
        let regex = try NSRegularExpression(pattern: pattern)
        return input.map({ input in
            let nsrange = NSRange(input.startIndex ..< input.endIndex, in: input)
            let matches = regex.matches(in: input, options: [], range: nsrange)
            guard let match = matches.first else { return Blueprint(id: 0, costs: []) }
            func group (_ num :Int) -> Int { Int(String(input[Range(match.range(at: num), in: input)!]))! }
            return Blueprint(id: group(1), costs: [
                Cost(group(2), 0, 0), Cost(group(3), 0, 0), Cost(group(4), group(5), 0), Cost(group(6), 0, group(7))
            ])
        })
    }

    func part1 () throws -> String {
        let bps = try parseBlueprints(try readInput(19))
        return String(bps.map({ $0.quality() }).reduce(0, +))
    }

    func part2 () throws -> String {
        let bps = try parseBlueprints(try readInput(19)).prefix(3)
        return String(bps.map({ $0.geodes(32) }).reduce(1, *))
     }
}
