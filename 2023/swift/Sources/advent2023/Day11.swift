struct Day11 : Day {

  func parse (_ input :[String]) -> [(Int, Int)] {
    input.enumerated().flatMap({ (y, line) in
      line.enumerated().flatMap({ (x, c) in c == "#" ? [(x, y)] : [] })
    })
  }

  func shift (_ galaxies :[(Int, Int)], _ shift :Int) -> [(Int, Int)] {
    func exp (_ max :Int, _ gs :[Int]) -> [Int] {
      (0 ... max).reductions(0, { (exp, v) in exp + (gs.contains(v) ? 0 : shift) })
    }
    let gxs = galaxies.map({ $0.0 }), xexp = exp(gxs.max()!, gxs)
    let gys = galaxies.map({ $0.1 }), yexp = exp(gys.max()!, gys)
    return galaxies.map({ gg in (gg.0 + xexp[gg.0+1], gg.1 + yexp[gg.1+1]) })
  }

  func dist (_ g1 :(Int, Int), _ g2 : (Int, Int)) -> Int { abs(g1.0-g2.0) + abs(g1.1-g2.1) }
  func sumdists (_ galaxies :[(Int, Int)]) -> Int {
    galaxies.combinations(ofCount: 2).sum(by: { dist($0[0], $0[1]) })
  }

  func part1 (_ input :[String]) -> Int { sumdists(shift(parse(input), 1)) }
  func part2 (_ input :[String]) -> Int { sumdists(shift(parse(input), 999999)) }
}
