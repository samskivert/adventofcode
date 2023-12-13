struct Day13 : Day {

  func transpose<T> (_ blocks: [[T]]) -> [[T]] {
    var txed = [[T]]()
    for ii in 0 ..< blocks[0].count { txed.append(blocks.map { $0[ii] }) }
    return txed
  }

  func check (_ rocks :[[Bool]], _ scale :Int, _ skip :Int) -> Int? {
    func sym (_ ii :Int, _ row :[Bool]) -> Bool {
      let mm = min(ii, row.count-ii)
      return (0 ... mm).allSatisfy { dx in row[ii+dx-1] == row[ii-dx] }
    }
    for ii in rocks[0].indices.dropFirst() where ii != skip {
      if rocks.allSatisfy({ row in sym(ii, row) }) { return ii*scale }
    }
    return nil
  }

  func fixcheck (_ rocks :[[Bool]], _ s :Int) -> Int? {
    var frocks = rocks
    let orig = check(rocks, 1, -1) ?? -1
    for yy in rocks.indices {
      for xx in rocks[0].indices {
        frocks[yy][xx] = !rocks[yy][xx]
        if let v = check(frocks, s, orig) { return v }
        frocks[yy][xx] = rocks[yy][xx]
      }
    }
    return nil
  }

  func parse (_ input :[String]) -> [[[Bool]]] {
    input.split(separator: "").map { $0.map { $0.map { $0 == "#" }}}
  }

  func part1 (_ input :[String]) -> Int {
    parse(input).map({ rks in check(rks, 1, -1) ?? check(transpose(rks), 100, -1)! }).reduce(0, +)
  }

  func part2 (_ input :[String]) -> Int {
    parse(input).map({ rks in fixcheck(rks, 1) ?? fixcheck(transpose(rks), 100)! }).reduce(0, +)
  }
}
