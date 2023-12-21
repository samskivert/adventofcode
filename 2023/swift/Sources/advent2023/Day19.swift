struct Day19 : Day {

  struct Rule {
    let idx, n :Int
    let gt :Bool
    let dest :String
    init (_ idx :Int, _ gt :Bool, _ n :Int, _ dest :String) {
      self.idx = idx ; self.gt = gt ; self.n = n ; self.dest = dest
    }

    func apply (_ part :[Int]) -> Bool { gt ? part[idx] > n : part[idx] < n }

    func refine (_ ranges :[Range<Int>]) -> ([Range<Int>], [Range<Int>]) {
      var inr = ranges, outr = ranges
      if gt {
        inr[idx] = ranges[idx].clamped(to: n+1 ..< 4001)
        outr[idx] = ranges[idx].clamped(to: 1 ..< n+1)
      } else {
        inr[idx] = ranges[idx].clamped(to: 1 ..< n)
        outr[idx] = ranges[idx].clamped(to: n ..< 4001)
      }
      return (inr, outr)
    }

    static func parse (_ rule :String) -> Rule {
      let idx = vars.firstIndex(of: rule.first!)!
      let gt = rule.dropFirst().first! == ">"
      let bits = rule.dropFirst(2).components(separatedBy: ":")
      return Rule(idx, gt, Int(bits[0])!, bits[1])
    }
    private static let vars :[Character] = ["x", "m", "a", "s"]
  }

  struct Flow {
    let rules :[Rule]
    let other :String

    func apply (_ part :[Int]) -> String {
      rules.first(where: { $0.apply(part) }).map { $0.dest } ?? other
    }

    func refine (_ ranges :[Range<Int>]) -> [(String, [Range<Int>])] {
      var remain = ranges
      var outs = [(String, [Range<Int>])]()
      for rule in rules {
        let (inr, outr) = rule.refine(remain)
        if rule.dest != "R" { outs.append((rule.dest, inr)) }
        remain = outr
      }
      if other != "R" { outs.append((other, remain)) }
      return outs
    }

    static func parse (_ flows :String) -> (String, Flow) {
      let outer = flows.components(separatedBy: "{")
      let inner = outer[1].dropLast().components(separatedBy: ",")
      return (outer[0], Flow(rules: inner.dropLast().map(Rule.parse), other: inner.last!))
    }
  }

  func apply (_ flows :[String: Flow], _ part :[Int]) -> Bool {
    var name = "in"
    while name != "A" && name != "R" { name = flows[name]!.apply(part) }
    return name == "A"
  }

  func count (_ flows :[String: Flow]) -> Int {
    var accepted = 0
    func step (_ flow :String, _ state :[Range<Int>]) {
      for (rflow, rstate) in flows[flow]!.refine(state) {
        if rflow == "A" { accepted += rstate.reduce(1, { $0 * ($1.upperBound-$1.lowerBound) }) }
        else { step(rflow, rstate) }
      }
    }
    let range = 1 ..< 4001
    step("in", [range, range, range, range])
    return accepted
  }

  func parse (_ input :[String]) -> ([String: Flow], [[Int]]) {
    let parts = input.split(separator: "")
    func parseVar (_ varstr :String) -> Int { Int(varstr.components(separatedBy: "=")[1])! }
    func parsePart (_ part :String) -> [Int] {
      part.dropFirst().dropLast().components(separatedBy: ",").map(parseVar)
    }
    return (Dictionary(uniqueKeysWithValues: parts[0].map(Flow.parse)), parts[1].map(parsePart))
  }

  func part1 (_ input :[String]) -> Int {
    let (flows, parts) = parse(input)
    return parts.filter({ apply(flows, $0) }).sum(by: { $0.reduce(0, +) })
  }

  func part2 (_ input :[String]) -> Int { count(parse(input).0) }
}
