object Advent10 extends AdventApp {
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
  val input = readline("data/input10.txt")
  def answer = ({
    val nums = (0 until 256).toArray
    hash(nums, input.split(",").map(_.toInt).toList, 0, 0)
    nums(0) * nums(1)
  }, knothash(input))
}
