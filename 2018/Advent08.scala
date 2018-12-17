object Advent08 extends AdventApp {
  val input = readline("data/input08.txt").split(" ").map(_.toInt)
  def fold[Z] (pos :Int, z :Z, op :(Z, Int) => Z) :(Z, Int) = {
    val (nz, mpos) = ((z, (pos+2)) /: (0 until input(pos))) {
      case ((cz, cpos), cc) => fold(cpos, cz, op)
    }
    val mcount = input(pos+1)
    ((nz /: (0 until mcount)) { (mz, mm) => op(mz, input(mpos+mm)) }, mpos + mcount)
  }
  def value (pos :Int) :(Int, Int) = {
    val (valfn :(Int => Int), mpos) =
      if (input(pos) == 0) ((m :Int) => m, pos+2)
      else ((Map[Int,Int]().withDefaultValue(0), pos+2) /: (0 until input(pos))) {
        case ((m, cpos), cc) => {
          val (cv, cp) = value(cpos)
          (m + ((cc+1) -> cv), cp)
        }
      }
    val mcount = input(pos+1)
    ((0 until mcount map { mm => valfn(input(mpos+mm)) }).sum, mpos + mcount)
  }
  def answer = (fold(0, 0, _ + _)._1, value(0)._1)
}
