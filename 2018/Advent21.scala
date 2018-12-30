object Advent21 extends AdventApp {
  def answer = {
    var r1 = 0 ; var r3 = 0 ; var r3first = 0
    var seen :List[Int] = Nil
    while (!(seen contains r3)) {
      seen = r3 :: seen
      r1 = r3 | 0x10000
      r3 = 10373714
      var cont = true
      while (cont) {
        r3 += (r1 & 0xFF)
        r3 &= 0xFFFFFF
        r3 *= 65899
        r3 &= 0xFFFFFF
        if (256 > r1) cont = false
        else {
          var r5 = 0
          while ((r5 + 1) * 256 <= r1) r5 += 1
          r1 = r5
        }
      }
      if (r3first == 0) r3first = r3
    }
    (r3first, seen.head)
  }
}
