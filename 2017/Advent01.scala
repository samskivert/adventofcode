object Advent01 extends AdventApp {
  val nums = readline("data/input01.txt").map(_.toInt - '0')
  val numC = nums.length
  def consec (stride :Int)(ii :Int) = if (nums(ii) == nums((ii+stride) % numC)) nums(ii) else 0
  def answer = ((0 until nums.length) map(consec(1)) sum,
                (0 until nums.length) map(consec(numC/2)) sum)
}
