import Foundation
struct Day11 : Day {
    
    let pattern = #"""
        Monkey (\d+):
          Starting items: (.*)
          Operation: new = old (.) (\S+)
          Test: divisible by (\d+)
            If true: throw to monkey (\d+)
            If false: throw to monkey (\d+)
        """#

    class Monkey {
        var items :[Int]
        var op :String
        var rhs :String
        var divis :Int
        var onTrue, onFalse :Int
        var inspected = 0

        init (_ input :String, _ match :NSTextCheckingResult) {
            func group (_ num :Int) -> Substring { input[Range(match.range(at: num), in: input)!] }
            items = group(2).split(separator: ",").map({ Int($0.trimmingCharacters(in: .whitespacesAndNewlines))! })
            op = String(group(3))
            rhs = String(group(4))
            divis = Int(group(5))!
            onTrue = Int(group(6))!
            onFalse = Int(group(7))!
        }

        func turn (_ monkeys :[Monkey], _ reduce :Int, _ mod :Int) {
            for item in items {
                let nitem = (update(item) / reduce) % mod
                monkeys[nitem % divis == 0 ? onTrue : onFalse].items.append(nitem)
                inspected += 1
            }
            items.removeAll()
        }

        func update (_ item :Int) -> Int {
            let n = rhs == "old" ? item : Int(rhs)!
            return op == "*" ? item * n : item + n
        }
    }

    func parse (_ file :String) throws -> [Monkey] {
        let input = try String(contentsOfFile: file, encoding: .utf8)
        let regex = try NSRegularExpression(pattern: pattern)
        let nsrange = NSRange(input.startIndex ..< input.endIndex, in: input)
        var monkeys = [Monkey]()
        regex.enumerateMatches(in: input, options: [], range: nsrange) { (match, _, stop) in
            guard let match = match else { return }
            monkeys.append(Monkey(input, match))
        }
        return monkeys
    }

    func process (_ rounds :Int, _ reduce :Int) throws ->  Int {
        let monkeys = try parse("Input/day11.txt")
        let mod = monkeys.map({ $0.divis }).reduce(1, *)
        for _ in 0 ..< rounds { for monkey in monkeys { monkey.turn(monkeys, reduce, mod) } }
        return monkeys.map({ $0.inspected }).sorted(by: >).prefix(2).reduce(1, *)
    }

    func part1 () throws -> String { String(try process(20, 3)) }
    func part2 () throws -> String { String(try process(10000, 1)) }
}
