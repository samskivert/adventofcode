struct Day21 : Day {

    enum Op { case Add, Sub, Mul, Div }
    enum Monkey {
        case value (_ value :Int)
        case binop (_ left :String, _ op :Op, _ right :String)
    }

    func parseMonkeys (_ input :[String]) -> [String: Monkey] {
        let ops = ["+": Op.Add, "-": Op.Sub, "*": Op.Mul, "/": Op.Div]
        return Dictionary(uniqueKeysWithValues: input.map({
            let parts = $0.components(separatedBy: ": ")
            let args = parts[1].components(separatedBy: " ")
            if args.count == 1 { return (parts[0], .value(Int(parts[1])!)) }
            else { return (parts[0], .binop(args[0], ops[args[1]]!, args[2])) }
        }))
    }

    func eval (_ monkeys :[String: Monkey], _ id :String) -> Int {
        switch monkeys[id]! {
        case let .value(v): return v
        case let .binop(l, op, r):
            let lv = eval(monkeys, l), rv = eval(monkeys, r)
            switch op {
            case .Add: return lv+rv
            case .Sub: return lv-rv
            case .Mul: return lv*rv
            case .Div: return lv/rv
            }
        }
    }

    func part1 () throws -> String { return String(eval(parseMonkeys(try readInput(21)), "root")) }

    func part2 () throws -> String {
        let monkeys = parseMonkeys(try readInput(21))

        func humn (_ id :String) -> Bool {
            if id == "humn" { return true }
            else if case let .binop(l, _, r) = monkeys[id] { return humn(l) || humn(r) }
            else { return false }
        }

        func uneval (_ id :String, _ expect :Int) -> Int {
            switch monkeys[id]! {
            case .value: return expect // humn
            case let .binop(l, op, r):
                if humn(l) {
                    let v = eval(monkeys, r)
                    switch op {
                    case .Add: return uneval(l, expect-v)
                    case .Sub: return uneval(l, expect+v)
                    case .Mul: return uneval(l, expect/v)
                    case .Div: return uneval(l, expect*v)
                    }
                } else {
                    let v = eval(monkeys, l)
                    switch op {
                    case .Add: return uneval(r, expect-v)
                    case .Sub: return uneval(r, v-expect)
                    case .Mul: return uneval(r, expect/v)
                    case .Div: return uneval(r, v/expect)
                    }
                }
            }
        }
        if case let .binop(l, _, r) = monkeys["root"] {
            return String(humn(l) ? uneval(l, eval(monkeys, r)) : uneval(r, eval(monkeys, l)))
        } else { return "?" }
     }
}
