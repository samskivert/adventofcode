object Day4 extends Day(4) {

  class Floor (input :Seq[String]) {
    val cells = input.map(row => row.map(_ == '@').toArray)
    val width = cells(0).length
    val height = cells.length
    def occupied (x :Int, y :Int) =
      x >= 0 && y >= 0 && x < width && y < height && cells(y)(x)
    def neighbors (x :Int, y :Int) = {
      def ocount (x :Int, y :Int) = if (occupied(x, y)) 1 else 0
      ocount(x-1, y-1) + ocount(x, y-1) + ocount(x+1, y-1) + ocount(x-1, y) +
      ocount(x+1, y) + ocount(x-1, y+1) + ocount(x, y+1) + ocount(x+1, y+1)
    }
    def movable (x :Int, y :Int) = occupied(x, y) && neighbors(x, y) < 4
    def totalMovable =
      (for (y <- 0 until height ; x <- 0 until width ; if movable(x, y)) yield 1).sum
    def removeMovable (removed :Int = 0, x :Int = 0, y :Int = 0) :Int = {
      if (y == height) removed
      else if (x == width) removeMovable(removed, 0, y+1)
      else if (!movable(x, y)) removeMovable(removed, x+1, y)
      else {
        cells(y)(x) = false
        removeMovable(removed+1, x+1, y)
      }
    }
  }

  override def answer1 (input :Seq[String]) = Floor(input).totalMovable

  override def answer2 (input :Seq[String]) = {
    def prune (floor :Floor, total :Int) :Int = {
      val removed = floor.removeMovable()
      if (removed > 0) prune(floor, removed + total)
      else total
    }
    prune(new Floor(input), 0)
  }
}
