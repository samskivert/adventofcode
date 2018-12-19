import scala.collection.immutable.TreeMap
object Advent13 extends AdventApp {
  def mkMap (s :String) = s.grouped(3).map(s => (s(0), s(1))).toMap
  val deltaX    = Map('>' -> 1, '<' -> -1, '^' ->  0, 'v' -> 0)
  val deltaY    = Map('>' -> 0, '<' ->  0, '^' -> -1, 'v' -> 1)
  val cartPaths = mkMap(">- <- ^| v|")
  val turnSlash = mkMap(">^ <v ^> v<")
  val turnBack  = mkMap(">v <^ ^< v>")
  val turnIsect = Array(mkMap(">^ <v ^< v>"), mkMap(">> << ^^ vv"), mkMap(">v <^ ^> v<"))
  val input = readlines("data/input13.txt").toArray
  val carts = TreeMap() ++ (for (y <- 0 until input.length ; x <- 0 until input.head.length ;
                                 c = input(y)(x) ; if (cartPaths.contains(c)))
                            yield (y, x) -> (c, 0))
  val paths = input.map(_.map(c => cartPaths.getOrElse(c, c)))
  type Carts = Map[(Int,Int),(Char,Int)]
  def step (carts :Carts, boom :Boolean) :(Int,Int) = {
    val rcarts = carts.iterator
    def stepCart (ncarts :Carts) :Carts = {
      if (!rcarts.hasNext) ncarts
      else {
        val ((y, x), (c, o)) = rcarts.next ; val next = (y + deltaY(c), x + deltaX(c))
        val weHitThem = ncarts.contains(next) ; val theyHitUs = ncarts.contains((y, x))
        if (!weHitThem && !theyHitUs) stepCart(ncarts + (paths(next._1)(next._2) match {
          case '-'  => next -> (c, o)
          case '|'  => next -> (c, o)
          case '/'  => next -> (turnSlash(c), o)
          case '\\' => next -> (turnBack(c), o)
          case '+'  => next -> (turnIsect(o)(c), (o+1)%3)
        }))
        else if (boom) Map() + (next -> ncarts(next))
        else stepCart(ncarts - next)
      }
    }
    val ncarts = stepCart(TreeMap())
    if (ncarts.size == 1) (ncarts.keys.head._2, ncarts.keys.head._1)
    else step(ncarts, boom)
  }
  def answer = (step(carts, true), step(carts, false))
}
