struct Day8 : Day {

  func parse (_ input :[String]) -> ([Unicode.Scalar], [String: (String, String)]) {
    (Array(input[0].unicodeScalars),
     Dictionary(uniqueKeysWithValues: input.dropFirst(2).map({ line in
      let parts = line.dropLast(1).components(separatedBy: " = (")
      let nodes = parts[1].components(separatedBy: ", ")
      return (String(parts[0]), (String(nodes[0]), String(nodes[1])))
    })))
  }

  func traverse (
    _ graph :[String: (String, String)], _ turns :[Unicode.Scalar], _ start :String
  ) -> Int {
    var cnode = start, steps = 0, tidx = 0
    while (true) {
      if cnode.last == "Z" { return steps }
      cnode = turns[tidx] == "R" ? graph[cnode]!.1 : graph[cnode]!.0
      steps += 1
      tidx = (tidx+1) % turns.count
    }
  }

  func part1 (_ input :[String]) -> Int {
    let (turns, graph) = parse(input)
    return traverse(graph, turns, "AAA")
  }

  // this is very not general, but the provided data results in each *A node arriving at a *Z node
  // after a whole number of cycles through the turn list and looping precisely from there; so we
  // can cut all sorts of corners
  func part2 (_ input :[String]) -> Int {
    let (turns, graph) = parse(input)
    let steps = graph.keys.filter({ $0.last == "A" }).map({ traverse(graph, turns, $0) })
    return steps.reduce(1, { $0 * $1/turns.count }) * turns.count
  }
}
