struct Day22 : Day {

  static func overlaps (_ min0 :Int, _ max0 :Int, _ min1 :Int, _ max1 :Int) -> Bool {
    min0 <= max1 && max0 >= min1
  }

  struct Brick : CustomStringConvertible {
    var minx, miny, minz :Int
    var maxx, maxy, maxz :Int
    var description :String { "x:\(minx)-\(maxx) y:\(miny)-\(maxy) z:\(minz)-\(maxz)" }

    func cocol (_ other :Brick) -> Bool {
      overlaps(minx, maxx, other.minx, other.maxx) && overlaps(miny, maxy, other.miny, other.maxy)
    }
  }

  func parse (_ input :[String]) -> [Brick] { input.map {
    let parsePoint = { (s :String) in s.splitInts(",") }
    let (fst, snd) = $0.split2("~"), pa = parsePoint(fst), pb = parsePoint(snd)
    return Brick(minx: min(pa[0], pb[0]), miny: min(pa[1], pb[1]), minz: min(pa[2], pb[2]),
                 maxx: max(pa[0], pb[0]), maxy: max(pa[1], pb[1]), maxz: max(pa[2], pb[2]))
  }}

  @discardableResult func fall (_ bricks :inout [Brick]) -> Int {
    bricks.sort(by: { $0.minz < $1.minz })
    var fell = 0
    for (ii, brick) in bricks.enumerated() {
      let maxz = bricks[0 ..< ii].filter({ brick.cocol($0) }).map({ $0.maxz }).reduce(0, max)
      let delta = brick.minz - (maxz+1)
      if delta > 0 {
        bricks[ii].minz -= delta
        bricks[ii].maxz -= delta
        fell += 1
      }
    }
    return fell
  }

  func checkfall (_ bricks :[Brick], _ nix :Int) -> Bool {
    for (ii, brick) in bricks.enumerated() {
      if ii == nix { continue }
      let maxz = bricks[0 ..< ii].enumerated().filter({
        $0.0 != nix && brick.cocol($0.1) }).map({ $0.1.maxz }).reduce(0, max)
      if brick.minz > (maxz+1) { return true }
    }
    return false
  }

  func part1 (_ input :[String]) -> Int {
    var bricks = parse(input)
    fall(&bricks)
    return (0 ..< bricks.count).sum(by: { checkfall(bricks, $0) ? 0 : 1 })
  }

  func part2 (_ input :[String]) -> Int {
    var bricks = parse(input)
    fall(&bricks)
    return (0 ..< bricks.count).sum(by: {
      var tbricks = bricks
      tbricks.remove(at: $0)
      return fall(&tbricks)
    })
  }
}
