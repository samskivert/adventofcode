struct Day12 : Day {

  enum Spring : Unicode.Scalar { case OK = ".", Broken = "#", Unknown = "?" }

  func count (_ springs :[Spring], _ groups :[Int]) -> Int {
    var cache :[Int: Int] = [:]

    func cached (_ spos :Int, _ gpos :Int) -> Int {
      if spos >= springs.count || gpos >= groups.count { return compute(spos, gpos) }
      let key = spos*1000+gpos
      if let r = cache[key] { return r }
      let v = compute(spos, gpos)
      cache[key] = v
      return v
    }

    func compute (_ spos :Int, _ gpos :Int) -> Int {
      if gpos == groups.count {
        return springs.dropFirst(spos).allSatisfy { $0 != .Broken } ? 1 : 0
      }
      if spos >= springs.count { return 0 }

      let first = springs[spos]
      let skip = first != .Broken ? cached(spos+1, gpos) : 0
      if first == .OK { return skip }

      let ng = groups[gpos]
      func match (_ at :Int, _ group :Int) -> Bool {
        group == 0 || (at < springs.count && springs[at] != .OK && match(at+1, group-1))
      }
      if !match(spos, ng) { return skip }
      if springs.count > spos+ng && springs[spos+ng] == .Broken { return skip }

      return skip + cached(spos+ng+1, gpos+1)
    }

    return cached(0, 0)
  }

  func unfold (_ text :String, _ sep :String, _ count :Int) -> String {
    Array(repeating: text, count: count).joined(separator: sep)
  }

  func process (_ input :[String], _ unfolds :Int) -> Int {
    input.sum(by: { line in
      let (sstr, gstr) = line.split2(" ")
      let springs = unfold(sstr, "?", unfolds).unicodeScalars.map { Spring(rawValue: $0)! }
      let groups = unfold(gstr, ",", unfolds).splitInts(",")
      return count(springs, groups)
    })
  }

  func part1 (_ input :[String]) -> Int { process(input, 1) }
  func part2 (_ input :[String]) -> Int { process(input, 5) }
}
