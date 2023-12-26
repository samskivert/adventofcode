struct Day25 : Day {

  func parse (_ input :[String]) -> [String: Set<String>] {
    var conns = Dictionary(uniqueKeysWithValues: input.map {
      let (k, v) = $0.split2(": ")
      return (k, Set(v.components(separatedBy: " ")))
    })
    for (k, vs) in conns {
      for v in vs {
        if let ks = conns[v] { conns[v] = ks.union([k]) }
        else { conns[v] = Set([k]) }
      }
    }
    return conns
  }

  func psize (_ graph :[String: Set<String>], _ cuts :[(String, String)]) -> Int {
    var seen = Set<String>()
    func follow (_ node :String) {
      if !seen.insert(node).0 { return }
      for n in graph[node]! {
        if !cuts.contains(where: { $0 == (node, n) || $0 == (n, node) }) { follow(n) }
      }
    }
    follow(graph.first!.key)
    return (graph.count - seen.count) * seen.count
  }

  func fcuts (_ graph :[String: Set<String>], _ hops :Int) -> [(String, String)] {
    func isN (_ b :String, _ hops :Int, _ a :String, _ via :String) -> Bool {
      let ans = graph[a]!
      if ans.contains(b) { return true }
      if hops == 0 { return false }
      for an in ans {
        if an == via { continue }
        if isN(b, hops-1, an, a) { return true }
      }
      return false
    }
    var cuts = [(String, String)]()
    for (a, ans) in graph {
      B: for b in ans {
        let bns = graph[b]!
        for bn in bns {
          if bn == a { continue }
          if isN(bn, hops, a, b) { continue B }
        }
        if !cuts.contains(where: { $0 == (b, a) }) { cuts.append((a, b)) }
      }
    }
    return cuts.count < 3 ? fcuts(graph, hops-1) : cuts
  }

  func part1 (_ input :[String]) -> String {
    let graph = parse(input)
    return String(fcuts(graph, 5).combinations(ofCount: 3).map({ psize(graph, $0) }).max()!)
  }

  func part2 (_ input :[String]) -> String { "🎄" }
}
