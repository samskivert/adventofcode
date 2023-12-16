struct Day14 : Day {

  enum Cell : Unicode.Scalar { case Empty = ".", Round = "O", Square = "#" }

  func slide1 (_ grid :inout [[Cell]], _ tx :Int, _ dx :Int, _ ty :Int, _ dy :Int) -> Void {
    if grid[ty][tx] != .Empty { return }
    let ex = dx == 1 ? grid.count : -1, ey = dy == 1 ? grid.count : -1
    var cx = tx+dx, cy = ty+dy
    while grid[cy][cx] != .Round {
      if grid[cy][cx] == .Square { return }
      cx += dx
      cy += dy
      if cx == ex || cy == ey { return }
    }
    grid[ty][tx] = grid[cy][cx]
    grid[cy][cx] = .Empty
  }

  func slide (_ grid :[[Cell]], _ dx :Int, _ dy :Int) -> [[Cell]] {
    let fwd = stride(from: 0, to: grid.count-1, by: 1)
    let bkw = stride(from: grid.count-1, to: 0, by: -1)
    var ngrid = grid
    if dx == 0 {
      for xx in grid.indices { for yy in (dy == 1 ? fwd : bkw) {
        slide1(&ngrid, xx, dx, yy, dy)
      }}
    } else {
      for yy in grid.indices { for xx in (dx == 1 ? fwd : bkw) {
        slide1(&ngrid, xx, dx, yy, dy)
      }}
    }
    return ngrid
  }

  func parse (_ input :[String]) -> [[Cell]] {
    input.map { $0.unicodeScalars.map { Cell(rawValue: $0)! }}
  }
  func load (_ grid :[[Cell]]) -> Int {
    grid.enumerated().sum(by: { r, l in l.filter({ $0 == .Round }).count * (grid.count-r) })
  }

  func part1 (_ input :[String]) -> Int { load(slide(parse(input), 0, 1)) }

  func part2 (_ input :[String]) -> Int {
    var grid = parse(input)
    let slides = [(0, 1), (1, 0), (0, -1), (-1, 0)]
    var grids = [[[Cell]]]()
    while true {
      for (dx, dy) in slides { grid = slide(grid, dx, dy) }
      if let head = grids.firstIndex(of: grid) {
        let tail = (1_000_000_000 - head) % (grids.count-head)
        return load(grids[head+tail-1])
      }
      grids.append(grid)
    }
  }
}
