struct Day21 : Day {

  let deltas = [(1, 0), (0, 1), (-1, 0), (0, -1)]

  struct Pos : Hashable, CustomStringConvertible {
    let x, y :Int
    var description :String { "+\(x)+\(y)" }
  }

  let wrap = { (n :Int, mod :Int) in let m = n % mod ; return m < 0 ? m + mod : m }

  func solve (_ input :[String], _ maxsteps :Int) -> Int {
    var grid = input.map { Array($0.unicodeScalars) }
    let wid = grid[0].count, hei = grid.count, start = Pos(x: wid/2, y: hei/2)
    grid[start.y][start.x] = "."

    var seen = [start: 0], spots = [(start, maxsteps)]
    while spots.count > 0 {
      let (next, nextr) = spots.removeFirst()
      if grid[wrap(next.y, hei)][wrap(next.x, wid)] == "#" { continue }
      if let r = seen[next] {
        if r >= nextr { continue }
      }
      seen[next] = nextr
      if nextr == 0 { continue }
      for (dx, dy) in deltas {
        spots.append((Pos(x: next.x+dx, y: next.y+dy), nextr-1))
      }
    }
    return seen.values.sum(by: { $0 % 2 == 0 ? 1 : 0 })
  }

  func part1 (_ input :[String]) -> Int { solve(input, 64) }

  func part2 (_ input :[String]) -> Int {
    let y0 = solve(input, 65), y1 = solve(input, 65+131), y2 = solve(input, 65+131+131)
    let a = y0/2 - y1 + y2/2,  b = -3*y0/2 + 2*y1 - y2/2, c = y0
    let x = (26501365 - 65) / 131
    return a*x*x + b*x + c
  }
}
