struct Day2 : Day {
    let sampleInput = ["A Y", "B X", "C Z"];

    enum ParseError : Error {
        case InvalidToken (_ text :Substring)
    }
    typealias Parser<A> = (Substring) throws -> A

    enum Play :Int, CaseIterable {
        case Rock = 1, Paper = 2, Scissors = 3
        func beats (_ p :Play) -> Bool { Play.allCases[self.rawValue % Play.allCases.count] == p }
        func score (_ p :Play) -> Int { self.beats(p) ? 6 : p.beats(self) ? 0 : 3 }
    }
    let toPlay :Parser<Play> = {
        switch $0 {
        case "A", "X": return .Rock
        case "B", "Y": return .Paper
        case "C", "Z": return .Scissors
        default: throw ParseError.InvalidToken($0)
        }
    }

    enum Action {
        case Win, Lose, Draw
    }
    let toAction :Parser<Action> = {
        switch $0 {
            case "X": return .Lose
            case "Y": return .Draw
            case "Z": return .Win
            default: throw ParseError.InvalidToken($0)
        }
    }

    func readStrategy<A, B> (_ input :[String], _ cvt1 :Parser<A>, _ cvt2 :Parser<B>) throws -> [(A, B)] {
        try input.map({ $0.split(separator: " ") }).map({ (try cvt1($0[0]), try cvt2($0[1])) })
    }

    func score1 (_ p1 :Play, _ p2 :Play) -> Int { p1.score(p2) + p2.rawValue }
    func part1 () throws -> String { String(try readStrategy(readInput(2), toPlay, toPlay).map(score1).reduce(0, +)) }

    func pickAction (_ p1 :Play, _ a2 :Action) -> Play {
        switch a2 {
        case .Win: return Play.allCases[p1.rawValue % Play.allCases.count]
        case .Lose: return Play.allCases[(p1.rawValue + 1) % Play.allCases.count]
        case .Draw: return p1
        }
    }
    func score2 (_ p1 :Play, a2 :Action) -> Int { score1(p1, pickAction(p1, a2)) }
    func part2 () throws -> String { String(try readStrategy(readInput(2), toPlay, toAction).map(score2).reduce(0, +)) }
}
