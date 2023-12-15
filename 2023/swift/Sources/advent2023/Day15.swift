struct Day15 : Day {

  let hash = { (s :String) in s.unicodeScalars.reduce(0, { h, c in ((h + Int(c.value)) * 17) % 256 }) }

  func part1 (_ input :[String]) -> Int {
    input[0].components(separatedBy: ",").map(hash).reduce(0, +)
  }

  func part2 (_ input :[String]) -> Int {
    var boxes = [[(String, Int)]](repeating: [], count: 256)
    for code in input[0].components(separatedBy: ",") {
      let last = String(code.last!)
      if last == "-" {
        let label = String(code.dropLast(1)), h = hash(label)
        boxes[h].removeAll(where: { $0.0 == label })
      } else {
        let label = String(code.dropLast(2)), h = hash(label), box = (label, Int(last)!)
        if let idx = boxes[h].firstIndex(where: { $0.0 == label }) { boxes[h][idx] = box }
        else { boxes[h].append(box) }
      }
    }
    func power (_ m :Int, _ bs :[(String, Int)]) -> Int {
      bs.enumerated().map({ li, ll in ll.1 * (li+1) * m }).reduce(0, +)
    }
    return boxes.enumerated().map({ bi, bs in power(bi+1, bs) }).reduce(0, +)
  }
}
