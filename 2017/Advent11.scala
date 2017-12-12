object Advent11 extends AdventApp {
  case class V (x :Int, y :Int) {
    def hexdist = { val h = Math.abs(x) ; val v = (Math.abs(y) - h)/2 ; h + v }
    def move (d :V) = V(x+d.x, y+d.y)
  }
  def toVec (dir :String) = dir match {
    case "nw" => V(-1,  1)
    case "n"  => V( 0,  2)
    case "ne" => V( 1,  1)
    case "se" => V( 1, -1)
    case "s"  => V( 0, -2)
    case "sw" => V(-1, -1)
  }
  val input = readline("data/input11.txt").split(",").map(toVec).toList
  def wander = input.foldLeft(V(0, 0))((c, m) => c move m)
  def maxwander = input.foldLeft((V(0,0), 0)) { case ((c, d), m) => (c move m, d max c.hexdist) }
  def answer = (wander.hexdist, maxwander._2)
}
