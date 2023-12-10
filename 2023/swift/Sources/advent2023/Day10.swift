import Algorithms

struct Day10 : Day {

  enum Dir : Int, CaseIterable {
    case N, E, S, W
    var opp :Dir { Dir(rawValue: (self.rawValue + 2) % 4)! }
  }

  struct Pos : Hashable, CustomStringConvertible {
    let x :Int
    let y :Int
    var description :String { "+\(x)+\(y)" }
    var next :Pos { Pos(x: x+1, y: y) }
    func neighbor (_ dir :Dir) -> Pos {
      Pos(x: (dir == .E ? x+1 : dir == .W ? x-1 : x),
          y: (dir == .N ? y-1 : dir == .S ? y+1 : y))
    }
  }

  enum Pipe :Unicode.Scalar, CaseIterable {
    case NS = "|"
    case EW = "-"
    case NE = "L"
    case NW = "J"
    case SW = "7"
    case SE = "F"
    case G  = "."
    case S  = "S"

    var ends :[Dir] {
      switch self {
        case .NS: [.N, .S]
        case .EW: [.E, .W]
        case .NE: [.N, .E]
        case .NW: [.N, .W]
        case .SW: [.S, .W]
        case .SE: [.E, .S]
        default: []
      }
    }

    func follow (_ dir :Dir, _ pos :Pos) -> (Dir, Pos) {
      let go = { (d :Dir) in (d, pos.neighbor(d)) }
      return switch self {
        case .NS, .EW: go(dir)
        case .NE: go(dir == .S ? .E : .N)
        case .NW: go(dir == .S ? .W : .N)
        case .SE: go(dir == .N ? .E : .S)
        case .SW: go(dir == .N ? .W : .S)
        default: (dir, pos)
      }
    }
  }

  func parse (_ input :[String]) -> ((Pos) -> Pipe, Pos) {
    var grid = Dictionary(uniqueKeysWithValues: input.enumerated().flatMap {
      (y, l) in l.unicodeScalars.enumerated().map {
        (x, c) in (Pos(x: x, y: y), Pipe(rawValue: c)!) }})
    let start = grid.first(where: { $1 == .S })!.key
    let pipe = { (pos :Pos) in grid[pos] ?? Pipe.G }
    let dirs = Dir.allCases.filter({ pipe(start.neighbor($0)).ends.contains($0.opp) })
    grid[start] = Pipe.allCases.first(where: { $0.ends == dirs })!
    return (pipe, start)
  }

  func fold<Z> (_ pipe :(Pos) -> Pipe, _ start :Pos, _ z :Z, _ op :(Z, Pos, Pos) -> Z) -> Z {
    let dirs = pipe(start).ends, da = dirs[0], db = dirs[1]
    var pa = (da, start.neighbor(da)), pb = (db, start.neighbor(db))
    var cz = op(z, pa.1, pb.1)
    while pa.1 != pb.1 {
      pa = pipe(pa.1).follow(pa.0, pa.1)
      pb = pipe(pb.1).follow(pb.0, pb.1)
      cz = op(cz, pa.1, pb.1)
    }
    return cz
  }

  func part1 (_ input :[String]) -> Int {
    let (pipe, start) = parse(input)
    return fold(pipe, start, 0, { (steps, a, b) in steps+1 })
  }

  func part2 (_ input :[String]) -> Int {
    let (pipe, start) = parse(input)
    let rim = fold(pipe, start, Set([start]), { (seen, a, b) in seen.union([a, b]) })
    let wid = input[0].count, hei = input.count
    // test if a point is inside by counting crosses of the rim
    func inside (_ pos :Pos) -> Bool {
      if rim.contains(pos) { return false }
      var crosses = 0, p = pos.next
      while p.x < wid {
        // to avoid counting ┏━┓ and ┗━┛, we only count ┃, ┛ and ┗ as crossings;
        // thus ┗━┛ is two crossings and ┏━┓ is zero, but ┃, ┏━┛ and ┗━┓ are 1
        if rim.contains(p) && pipe(p).ends[0] == .N { crosses += 1 }
        p = p.next
      }
      return crosses % 2 == 1
    }
    return product(0 ..< wid, 0 ..< hei).filter({ inside(Pos(x: $0, y: $1)) }).count
  }
}
