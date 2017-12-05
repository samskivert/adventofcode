object Advent02 extends AdventApp {
  val data = readlines("data/input02.txt") map(_ split("\t") map(_.toInt)) toSeq
  def maxmin (nums :Array[Int]) = nums.max - nums.min
  def finddiv (nums :Array[Int]) = (for (a <- nums; b <- nums if (a != b && a % b == 0))
                                    yield a/b).head
  def answer = (data map maxmin sum, data map finddiv sum)
}
