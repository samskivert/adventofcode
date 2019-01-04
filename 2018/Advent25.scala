object Advent25 extends AdventApp {
  def distance (p0 :Array[Int])(p1 :Array[Int]) :Int =
    Math.abs(p0(0)-p1(0)) + Math.abs(p0(1)-p1(1)) + Math.abs(p0(2)-p1(2)) + Math.abs(p0(3)-p1(3))
  val input = readlines("data/input25.txt").map(_.split(",").map(_.toInt)).toSet
  def answer = (Seq[Set[Array[Int]]]() /: input)((cs, p) => {
    val (ins, outs) = cs.partition(_.exists(cp => distance(cp)(p) <= 3))
    outs :+ (Set(p) /: ins)((acc, in) => acc | in)
  }).size
}
