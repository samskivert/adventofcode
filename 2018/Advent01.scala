object Advent01 extends AdventApp {
  val nums = Seq() ++ readlines("data/input01.txt").map(_.toInt)
  def findfreq (freq :Int, nums :Seq[Int], pos :Int, seen :Set[Int]) :Int = {
    val nextfreq = freq + nums(pos)
    if (seen(nextfreq)) nextfreq
    else findfreq(nextfreq, nums, (pos+1) % nums.size, seen + nextfreq)
  }
  def answer = (nums.foldLeft(0)((sum, change) => sum + change),
                findfreq(0, nums, 0, Set()))
}
