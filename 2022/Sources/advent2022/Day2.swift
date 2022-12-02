struct Day2 : Day {
    enum ParseError : Error {
        case InvalidToken (_ text :Substring)
    }

    enum Play :Int {
        case Rock = 1, Paper = 2, Scissors = 3
    }
    func toPlay (_ token :Substring) throws -> Play {
        switch token {
        case "A", "X": return .Rock
        case "B", "Y": return .Paper
        case "C", "Z": return .Scissors
        default: throw ParseError.InvalidToken(token)
        }
    }

    enum Action { 
        case Win, Lose, Draw
    }
    func toAction (_ token :Substring) throws -> Action {
        switch token {
        case "X": return .Lose
        case "Y": return .Draw
        case "Z": return .Win
        default: throw ParseError.InvalidToken(token)
        }
    }

    let sampleInput = ["A Y", "B X", "C Z"];
    func readStrategy<A, B> (_ cvt1 :(Substring) throws -> A, _ cvt2 :(Substring) throws -> B) throws -> [(A, B)] {
        // let lines = sampleInput 
        let lines = try readInput(2)
        return try lines.map { line in
            let tokens = line.split(separator: " ")
            return (try cvt1(tokens[0]), try cvt2(tokens[1]))
        }
    }

    func playScore (_ p1 :Play, _ p2 :Play) -> Int {
        switch p2 {
        case .Rock: return p1 == .Paper ? 0 : p1 == .Scissors ? 6 : 3
        case .Paper: return p1 == .Scissors ? 0 : p1 == .Rock ? 6 : 3
        case .Scissors: return p1 == .Rock ? 0 : p1 == .Paper ? 6 : 3
        }
    }
    func score1 (_ p1 :Play, _ p2 :Play) -> Int { playScore(p1, p2) + p2.rawValue }
    func part1 () throws -> Int { try readStrategy(toPlay, toPlay).map(score1).reduce(0, +) }

    func pickAction (_ p1 :Play, _ a2 :Action) -> Play {
        switch a2 {
        case .Win: return p1 == .Rock ? .Paper : p1 == .Paper ? .Scissors : .Rock
        case .Lose: return p1 == .Rock ? .Scissors : p1 == .Paper ? .Rock : .Paper
        case .Draw: return p1
        }
    }
    func score2 (_ p1 :Play, a2 :Action) -> Int { score1(p1, pickAction(p1, a2)) }
    func part2 () throws -> Int { try readStrategy(toPlay, toAction).map(score2).reduce(0, +) }
}
