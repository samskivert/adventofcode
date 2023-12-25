struct Day24 : Day {

  struct Stone2 {
    let x, y, vx, vy :Int
    var a :Int { vy }
    var b :Int { -vx }
    var c :Int { vy*x - vx*y }

    func minus (_ rvx :Int, _ rvy :Int) -> Stone2 {
      Stone2(x: x, y: y, vx: vx-rvx, vy: vy-rvy) }
  }

  func intersect (_ a :Stone2, _ b :Stone2) -> (Int, Int)? {
    let aa = Double(a.a), ab = Double(a.b), ac = Double(a.c), ay = Double(a.y)
    let ba = Double(b.a), bb = Double(b.b), bc = Double(b.c), by = Double(b.y)
    let d = bb * aa - ab * ba
    if d == 0 { return nil } // parallel
    let x = (bb * ac - ab * bc) / d
    let y = (bc * aa - ac * ba) / d
    if (y-ay >= 0) != (a.vy >= 0) || (y-by >= 0) != (b.vy >= 0) { return nil } // met in "past"
    return (Int(x.rounded()), Int(y.rounded()))
  }

  struct Stone3 {
    let x, y, z, vx, vy, vz :Int
    var xy :Stone2 { Stone2(x: x, y :y, vx: vx, vy: vy) }
    var yz :Stone2 { Stone2(x: y, y :z, vx: vy, vy: vz) }
    init (_ p :[Int], _ v :[Int]) {
      x = Int(p[0]) ; y = Int(p[1]) ; z = Int(p[2])
      vx = Int(v[0]) ; vy = Int(v[1]) ; vz = Int(v[2])
    }
  }

  func parse (_ input :[String]) -> [Stone3] {
    input.map {
      let (pstr, vstr) = $0.replacingOccurrences(of: " ", with: "").split2("@")
      return Stone3(pstr.splitInts(","), vstr.splitInts(","))
    }
  }

  func part1 (_ input :[String]) -> Int {
    let stones = parse(input).map { $0.xy }
    let min = stones.count == 5 ?  7 : 200000000000000
    let max = stones.count == 5 ? 27 : 400000000000000
    return stones.enumerated().sum(by: { (ai, a) in
      stones.suffix(from: ai+1).filter({
        guard let (ix, iy) = intersect(a, $0) else { return false }
        return min <= ix && max >= ix && min <= iy && max >= iy
      }).count
    })
  }

  func findRock (_ stones :[Stone2]) -> Stone2? {
    func check (_ vx :Int, _ vy :Int) -> Stone2? {
      var abi :(Int, Int)? = nil, pairs = 0
      for (ii, a) in stones.enumerated() {
        for b in stones.suffix(from: ii+1) {
          guard let ab = intersect(a.minus(vx, vy), b.minus(vx, vy)) else { continue }
          guard let pab = abi else { abi = ab ; continue }
          guard pab == ab else { return nil }
          pairs += 1
          if pairs > 2 { return Stone2(x: ab.0, y: ab.1, vx: vx, vy: vy) }
        }
      }
      return nil
    }
    let max = 300
    for vx in -max ..< max { for vy in -max ..< max {
      if let p = check(vx, vy) { return p }
    }}
    return nil
  }

  func part2 (_ input :[String]) -> Int {
    let stones = parse(input)
    let xy = findRock(stones.map{ $0.xy })!, yz = findRock(stones.map{ $0.yz })!
    return xy.x + xy.y + yz.y
  }
}
