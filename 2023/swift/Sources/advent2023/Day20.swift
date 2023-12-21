protocol Module {
  var inputs :Int { get }
  var outputs :[String] { get }
  mutating func pulse (_ source :String, _ signal :Bool) -> [(String, Bool)]
}

struct Day20 : Day {

  struct Broadcast : Module {
    var inputs :Int { 0 }
    let outputs :[String]

    func pulse (_ source :String, _ signal :Bool) -> [(String, Bool)] {
      outputs.map { ($0, signal) }
    }
  }

  struct FlipFlop : Module {
    var inputs :Int { 1 }
    let outputs :[String]
    var current = false

    mutating func pulse (_ source :String, _ signal :Bool) -> [(String, Bool)] {
      if signal { return [] }
      else {
        current = !current
        return outputs.map { ($0, current) }
      }
    }
  }

  struct Conjunction : Module {
    let inputs :Int
    let outputs :[String]
    var history = [String: Bool]()

    mutating func pulse (_ source :String, _ signal :Bool) -> [(String, Bool)] {
      history[source] = signal
      let output = history.values.filter({ $0 }).count != inputs
      return outputs.map { ($0, output) }
    }
  }

  func propagate (
    _ mods :inout [String: Module], _ lows :inout Int, _ highs :inout Int,
    _ monitor :String, _ monsigs :inout [String]
  ) {
    var queue = [("", "broadcaster", false)]
    while queue.count > 0 {
      let (inm, outm, sig) = queue.removeFirst()
      if sig { highs += 1 } else { lows += 1 }
      if outm == monitor && sig { monsigs.append(inm) }
      if var mod = mods[outm] {
        for (nmod, nsig) in mod.pulse(inm, sig) { queue.append((outm, nmod, nsig)) }
        mods[outm] = mod
      }
    }
  }

  func parse (_ input :[String]) -> [String: Module] {
    let pairs = input.map {
      let bits = $0.components(separatedBy: " -> ")
      return (bits[0], bits[1].components(separatedBy: ", "))
    }
    return Dictionary(uniqueKeysWithValues: pairs.map { pp in
      let name = String(pp.0.dropFirst())
      if pp.0.first == "%" { return (name, FlipFlop(outputs: pp.1)) }
      else if pp.0.first == "&" {
        let inputs = pairs.sum(by: { $0.1.contains(name) ? 1 : 0 })
        return (name, Conjunction(inputs: inputs, outputs: pp.1)) }
      else { return (pp.0, Broadcast(outputs: pp.1)) }
    })
  }

  func part1 (_ input :[String]) -> Int {
    var mods = parse(input), lows = 0, highs = 0, ignore = [String]()
    for _ in 0 ..< 1000 { propagate(&mods, &lows, &highs, "", &ignore) }
    return lows*highs
  }

  func part2 (_ input :[String]) -> Int {
    var mods = parse(input), lows = 0, highs = 0, presses = 1, pxsigs = [String]()
    let (pxn, pxm) = mods.first(where: { $0.1.outputs.contains("rx") })!
    var pxps = [String: Int]()
    while true {
      propagate(&mods, &lows, &highs, pxn, &pxsigs)
      for pxsig in pxsigs {
        if pxps[pxsig] == nil { pxps[pxsig] = presses }
        if pxps.count == pxm.inputs { return pxps.values.reduce(1, *) }
      }
      presses += 1
    }
  }
}
