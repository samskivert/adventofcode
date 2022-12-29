struct Day25 : Day {

    let sampleInput = [ "1=-0-2", "12111", "2=0=", "21", "2=01", "111", "20012", "112", "1=-1=", "1-12", "12", "1=", "122" ]

    func add (_ a :[Int], _ b :[Int]) -> [Int] {
        let digits = max(a.count, b.count)
        var sum = [Int](), carry = 0
        for dd in 0 ..< digits {
            let ad = a.count > dd ? a[a.count-dd-1] : 0
            let bd = b.count > dd ? b[b.count-dd-1] : 0
            var sd = ad+bd+carry
            carry = 0
            while sd < -2 { carry -= 1 ; sd += 5 }
            while sd > 2 { carry += 1 ; sd -= 5 }
            sum.insert(sd, at: 0)
        }
        if carry != 0 { sum.insert(carry, at: 0) }
        return sum
    }

    func part1 () throws -> String {
        let s2D :[Character: Int] = ["2": 2, "1": 1, "0": 0, "-": -1, "=": -2]
        let sum = try readInput(25).map({ $0.map({ s2D[$0]! }) }).reduce([Int](), add)
        let d2S = Dictionary(uniqueKeysWithValues: s2D.map({ ($0.value, $0.key ) }))
        return String(sum.map({ d2S[$0]! }))
    }

    func part2 () throws -> String { "🎄" }
}