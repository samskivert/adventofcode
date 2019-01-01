object Advent22 extends AdventApp {
  val depth = 4002
  val (tx, ty) = (5, 746)

  val cave = scala.collection.mutable.Map[(Int,Int),Int]()
  def erosion (x :Int, y :Int) :Int = cave.getOrElseUpdate(
    (x, y), ((if ((x == 0 && y == 0) || (x == tx && y == ty)) 0
              else if (y == 0) x * 16807
              else if (x == 0) y * 48271
              else erosion(x, y-1) * erosion(x-1, y)) + depth) % 20183)

  def totalrisk = (for (y <- 0 to ty ; x <- 0 to tx) yield erosion(x, y) % 3).sum

  enum Tool { case Gear, Torch, Nada } ; import Tool._
  val Usable = Array(Set(Gear, Torch), // Rocky
                     Set(Gear, Nada),  // Wet
                     Set(Torch, Nada)) // Narrow

  def search = {
    var search = scala.collection.mutable.PriorityQueue((0, 0, 0, Torch))(
      Ordering.fromLessThan((a, b) => b._1 < a._1))
    val costs = scala.collection.mutable.Map[(Int,Int,Tool),Int]()
    var tcost = 0xFFFF
    costs((0, 0, Torch)) = 0
    while (!search.isEmpty) {
      val (ccost, x, y, ctool) = search.dequeue()
      if (ccost <= costs.getOrElse((x, y, ctool), 0xFFFF)) {
        val ctype = erosion(x, y) % 3
        def check (nx :Int, ny :Int) :Unit = {
          val ntype = erosion(nx, ny) % 3
          val tools = Usable(ctype) & Usable(ntype)
          if (!tools.isEmpty) {
            val isTarget = nx == tx && ny == ty
            val ntool = if (isTarget) Torch else if (tools(ctool)) ctool else tools.head
            val ncost = ccost + 1 + (if (ntool == ctool) 0 else 7)
            val ncoord = (nx, ny, ntool)
            val nbest = costs.getOrElse(ncoord, 0xFFFF)
            if (ncost < nbest && ncost < tcost) {
              costs.put(ncoord, ncost)
              search += ((ncost, nx, ny, ntool))
              if (isTarget && ncost < tcost) tcost = ncost
            }
          }
        }
        check(x+1, y) ; if (x > 1) check(x-1, y)
        check(x, y+1) ; if (y > 1) check(x, y-1)
      }
    }
    costs((tx, ty, Torch))
  }
  def answer = (totalrisk, search)
}
