struct Day17 : Day {

  struct Node : Hashable {
    let x, y, dir, dist :Int
  }

  func search (_ grid :[[Int]], _ ultra :Bool) -> Int {
    let wid = grid[0].count, hei = grid.count, endx = wid-1, endy = hei-1
    let snode = Node(x: 0, y: 0, dir: 1, dist: 0)
    var nodes = [Node]()
    var costs = [snode: 0]
    let dxs = [-1, 0, 1, 0], dys = [0, -1, 0, 1]

    func move (_ node :Node, _ loss :Int, _ ddir :Int) {
      let ndir = (node.dir + ddir) % 4, nx = node.x + dxs[ndir], ny = node.y + dys[ndir]
      let nnode = Node(x: nx, y: ny, dir: ndir, dist: ddir == 0 ? node.dist+1 : 1)
      if nx < 0 || ny < 0 || nx >= wid || ny >= hei || costs[nnode] != nil { return }
      costs[nnode] = loss + grid[ny][nx]
      nodes.insertSorted(nnode, { costs[$0]! < costs[$1]! })
    }

    move(snode, 0, 1)
    move(snode, 0, 2)

    while nodes.count > 0 {
      let head = nodes.removeFirst(), hloss = costs[head]!
      if head.x == endx && head.y == endy && (!ultra || head.dist >= 4) { return hloss }

      if ultra {
        if head.dist < 10 { move(head, hloss, 0) }
        if head.dist >= 4 {
          move(head, hloss, 1)
          move(head, hloss, 3)
        }
      } else {
        if head.dist < 3 { move(head, hloss, 0) }
        move(head, hloss, 1)
        move(head, hloss, 3)
      }
    }
    return -1
  }

  func parse (_ input :[String]) -> [[Int]] { input.map { $0.map { Int(String($0))! }} }
  func part1 (_ input :[String]) -> Int { search(parse(input), false) }
  func part2 (_ input :[String]) -> Int { search(parse(input), true) }
}
