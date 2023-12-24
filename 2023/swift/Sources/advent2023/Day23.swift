struct Day23 : Day {

  enum Cell : Unicode.Scalar {
    case F = "#", P = ".", U = "^", D = "v", L = "<", R = ">"
  }

  enum Dir : Int, CaseIterable {
    case N, E, S, W
    var opp :Dir { Dir.allCases[(rawValue + 2)%4] }
    func n (_ p :(Int, Int)) -> (Int, Int) { (x: p.0+dx[self.rawValue], y: p.1+dy[self.rawValue]) }
  }
  static let dx = [0, 1, 0, -1], dy = [-1, 0, 1, 0]

  let dirCells :[Cell] = [.U, .R, .D, .L]
  func downhill (_ cell :Cell, _ dir :Dir) -> Bool { cell == dirCells[dir.rawValue] }

  func toGraph (_ input :[String],  _ icy :Bool) -> [[(Int, Int)]] {
    let forest = input.map { $0.unicodeScalars.map { Cell(rawValue: $0)! }}
    let wid = forest[0].count, hei = forest.count
    let start = (x: forest[0].firstIndex(of: Cell.P)!, y: 0)
    func canStep (_ pos :(Int, Int)) -> Bool {
      pos.0 >= 0 && pos.1 >= 0 && pos.0 < wid && pos.1 < hei && forest[pos.1][pos.0] != .F
    }

    var nodes = [(Int, Int)](), edges = [[(Int, Int)]](), heads = [(0, 0, start, Dir.S)]
    while heads.count > 0 {
      let (fidx, dist, pos, dir) = heads.removeFirst()
      var oneway = false
      func step (_ pos :(Int, Int), _ dist :Int, _ dir :Dir) {
        let f = forest[pos.1][pos.0], fdir = dir.opp
        if icy && downhill(f, dir) { oneway = true }
        else if icy && downhill(f, fdir) { return } // can't go uphill
        let exits = Dir.allCases.filter({ dd in canStep(dd.n(pos)) })
        if exits.count == 2 {
          let exit = exits[0] == fdir ? exits[1] : exits[0]
          step(exit.n(pos), dist+1, exit)
        } else if let nidx = nodes.firstIndex(where: { $0 == pos }) {
          edges[fidx].append((nidx, dist+1))
        } else {
          nodes.append(pos)
          edges.append([])
          let nidx = nodes.count-1
          edges[fidx].append((nidx, dist+1))
          for exit in exits {
            if oneway && exit == fdir { continue }
            heads.append((nidx, 0, exit.n(pos), exit))
          }
        }
      }
      step(pos, dist, dir)
    }
    return edges
  }

  func longestPath (_ edges :[[(Int, Int)]]) -> Int {
    var path = [0]
    func search (_ node :Int, _ dist :Int) -> Int {
      if node == edges.count-1 { return dist }
      var longest = 0
      for (next, ndist) in edges[node] {
        if path.contains(next) { continue }
        path.append(next)
        longest = max(search(next, dist+ndist), longest)
        path.removeLast()
      }
      return longest
    }
    return search(0, 0)
  }

  func part1 (_ input :[String]) -> Int { longestPath(toGraph(input, true)) }
  func part2 (_ input :[String]) -> Int { longestPath(toGraph(input, false)) }
}
