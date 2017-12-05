object Advent05 extends AdventApp {
  def jumps = readlines("data/input05.txt").map(_.toInt).toArray
  def exec (jumps :Array[Int], pc :Int, count :Int, op :Int => Int) :Int =
    if (pc >= jumps.length) count
    else {
      val j = jumps(pc) ; jumps(pc) = op(j)
      exec(jumps, pc + j, count+1, op)
    }
  def answer = (exec(jumps, 0, 0, _ + 1),
                exec(jumps, 0, 0, j => if (j >= 3) j-1 else j+1))
}
