import Algorithms

struct Day10 : Day {

  enum Dir : Int, CaseIterable {
    case N, E, S, W
    var opp :Dir { Dir(rawValue: (self.rawValue + 2) % 4)! }
    var dx :Int { self == .E ? 1 : self == .W ? -1 : 0 }
    var dy :Int { self == .S ? 1 : self == .N ? -1 : 0 }
  }

  struct Pos : Hashable, CustomStringConvertible {
    let x, y :Int
    var description :String { "+\(x)+\(y)" }
    var next :Pos { Pos(x: x+1, y: y) }
    func neighbor (_ dir :Dir) -> Pos { Pos(x: x+dir.dx, y: y+dir.dy) }
  }

  enum Pipe :Unicode.Scalar, CaseIterable {
    case NS = "|", EW = "-", NE = "L", NW = "J", SW = "7", SE = "F", G = ".", S = "S"
    var ends :[Dir] { Self.ends[self]! }
    private static let ends :[Pipe: [Dir]] = [
      .NS: [.N, .S], .EW: [.E, .W], .NE: [.N, .E], .NW: [.N, .W], .SW: [.S, .W], .SE: [.E, .S],
      .G: []
    ]
  }

  func parse (_ input :[String]) -> ((Pos) -> Pipe, Set<Pos>) {
    var grid = Dictionary(uniqueKeysWithValues: input.enumerated().flatMap {
      (y, l) in l.unicodeScalars.enumerated().map {
        (x, c) in (Pos(x: x, y: y), Pipe(rawValue: c)!) }})
    let pipe = { (pos :Pos) in grid[pos] ?? Pipe.G }

    let start = grid.first(where: { $1 == .S })!.key
    let dirs = Dir.allCases.filter({ pipe(start.neighbor($0)).ends.contains($0.opp) })
    grid[start] = Pipe.allCases.first(where: { $0.ends == dirs })!

    var rim = Set<Pos>(), pos = start, dir = dirs[0].opp
    repeat {
      rim.insert(pos)
      let ends = pipe(pos).ends
      dir = dir.opp == ends[0] ? ends[1] : ends[0]
      pos = pos.neighbor(dir)
    } while pos != start
    return (pipe, rim)
  }

  func part1 (_ input :[String]) -> Int { parse(input).1.count/2 }

  func part2 (_ input :[String]) -> Int {
    let (pipe, rim) = parse(input)
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
