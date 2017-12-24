object Advent24 extends AdventApp {
  val parts = readlines("data/input24.txt").map(_.split("/").map(_.toInt)).toSeq
  def build (bridge :(Int,Int,Int), parts :Seq[Array[Int]]) :Seq[(Int,Int)] = {
    val (head, str, len) = bridge
    def extend (p :Array[Int]) = (if (p(0) == head) p(1) else p(0), str+p(0)+p(1), len+1)
    val matches = parts.filter(p => p(0) == head || p(1) == head)
    if (matches.isEmpty) Seq((str, len))
    else matches.flatMap(m => build(extend(m), parts.filter(_ != m)))
  }
  val bridges = build((0, 0, 0), parts)
  def answer = (bridges.maxBy(_._1)._1, bridges.maxBy(p => p._2*100 + p._1)._1)
}
