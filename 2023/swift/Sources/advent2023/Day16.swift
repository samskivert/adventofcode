struct Day16 : Day {

  enum Dir : Int {
    case N = 0, E = 1, S = 2, W = 3
    func rotate (_ dd :Int) -> Dir { Dir(rawValue: (rawValue+dd)%4)! }
    var opposite :Dir { rotate(2) }
    var horiz :Bool { self == .E || self == .W }
    var dx :Int { self == .E ? 1 : self == .W ? -1 : 0 }
    var dy :Int { self == .S ? 1 : self == .N ? -1 : 0 }
    var bit :Int { 1 << rawValue }
  }

  enum Mirror : Unicode.Scalar {
    case UD = "|", LR = "-", LD = "\\", LU = "/", NO = "."

    func reflect (_ dir :Dir) -> (Dir, Bool) {
      switch self {
      case .UD: return dir.horiz ? (.N, true) : (dir, false)
      case .LR: return dir.horiz ? (dir, false) : (.W, true)
      case .LD: return dir.horiz ? (dir.rotate(1), false) : (dir.rotate(3), false)
      case .LU: return dir.horiz ? (dir.rotate(3), false) : (dir.rotate(1), false)
      case .NO: return (dir, false)
      }
    }
  }

  struct Cell {
    let mirror :Mirror
    var entries :Int = 0
    func entered (_ dir :Dir) -> Bool { dir.bit & entries != 0 }
    mutating func noteEntered (_ dir :Dir) { entries |= dir.bit }
  }

  func propagate (_ beams :inout [(Int, Int, Dir)], _ cells :inout [[Cell]]) {
    for (idx, beam) in beams.enumerated().reversed() {
      let (bx, by, bdir) = beam, nx = bx+bdir.dx, ny = by+bdir.dy
      if nx < 0 || ny < 0 || nx >= cells.count || ny >= cells.count || cells[ny][nx].entered(bdir) {
        beams.remove(at: idx)
      } else {
        cells[ny][nx].noteEntered(bdir)
        let (ndir, split) = cells[ny][nx].mirror.reflect(bdir)
        beams[idx] = (nx, ny, ndir)
        if split { beams.append((nx, ny, ndir.opposite)) }
      }
    }
  }

  func energize (_ cells :[[Cell]], _ start :(Int, Int, Dir)) -> Int {
    var mcells = cells, beams = [start]
    while beams.count > 0 { propagate(&beams, &mcells) }
    return mcells.reduce(0, { s, r in r.reduce(s, { s, c in s + (c.entries == 0 ? 0 : 1)}) })
  }

  func parse (_ input :[String]) -> [[Cell]] {
    input.map({ $0.unicodeScalars.map({ Cell(mirror: Mirror(rawValue: $0)!) }) })
  }

  func part1 (_ input :[String]) -> Int { energize(parse(input), (-1, 0, Dir.E)) }

  func part2 (_ input :[String]) -> Int {
    let cells = parse(input)
    let starts = (0 ..< cells.count).flatMap { ii in
      [(ii, -1, Dir.S), (ii, cells.count, .N), (-1, ii, .E), (cells.count, ii, .W)] }
    return starts.map({ energize(cells, $0) }).max()!
  }
}
