object Advent14 extends AdventApp {
  // from Advent10
  def revmod (nums :Array[Int], len :Int, pos :Int) = 0 until len/2 foreach { pp =>
    val (a, b) = ((pos + pp) % nums.length, (pos + len-pp-1) % nums.length)
    val tmp = nums(a) ; nums(a) = nums(b) ; nums(b) = tmp
  }
  def hash (nums :Array[Int], lens :List[Int], pos :Int, skip :Int) :(Int, Int) = lens match {
    case Nil         => (pos, skip)
    case len :: rest => revmod(nums, len, pos) ; hash(nums, rest, pos + len + skip, skip + 1)
  }
  def hashN (nums :Array[Int], lens :List[Int], n :Int) =
    (0 until n).foldLeft((0, 0)) { (ps, ii) => hash(nums, lens, ps._1, ps._2) }
  def pad (len :Int)(digits :String) = "0" * (len-digits.length) + digits
  def knothash (input :String) = {
    val nums = (0 until 256).toArray
    val lens = input.map(_.toInt).toList ++ List(17, 31, 73, 47, 23)
    hashN(nums, lens, 64)
    nums.grouped(16).map(_.reduce(_ ^ _)).map(_.toHexString).map(pad(2)).mkString("")
  }
  // end Advent10

  def bits (n :Int) = pad(4)(n.toBinaryString).map(_ - '0')
  val nibbleBits = 0 until 16 map(n => (n.toHexString.charAt(0), bits(n))) toMap
  def grid (input :String) = Array.tabulate(128) { row =>
    knothash(s"$input-$row").flatMap(nibbleBits).toArray }

  def regions (grid :Array[Array[Int]]) = {
    def clear (y :Int, x :Int) :Int =
      if (x < 0 || x >= 128 || y < 0 || y >= 128 || grid(y)(x) == 0) 0 else {
        grid(y)(x) = 0
        clear(y, x-1) ; clear(y-1, x)
        clear(y, x+1) ; clear(y+1, x)
        1
      }
    (for (y <- 0 until 128 ; x <- 0 until 128) yield clear(y, x)) sum
  }

  def answer = (grid(s"hfdlxzhv").map(_.sum).sum, regions(grid(s"hfdlxzhv")))
}
