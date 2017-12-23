import scala.collection.mutable.{Map => MMap}
object Advent22 extends AdventApp {
  val input = readlines("data/input22.txt").toSeq

  def spreadf (nodes :MMap[(Int,Int),Char], evolve :String, count :Int) = // foldy style
    (((input.size/2, input.size/2, 0, -1, 0) /: (0 until count))((state, _) => {
      val (x, y, dx, dy, infected) = state
      val oldState = nodes.getOrElse((x, y), '.')
      val newState = evolve((evolve.indexOf(oldState)+1) % evolve.length)
      nodes.put((x, y), newState)
      val (ndx, ndy) = oldState match {
        case '.' => ( dy, -dx)
        case 'W' => ( dx,  dy)
        case '#' => (-dy,  dx)
        case 'F' => (-dx, -dy)
      }
      (x+ndx, y+ndy, ndx, ndy, if (newState == '#') infected+1 else infected)
    }))._5

  def spreadl (nodes :MMap[(Int,Int),Char], evolve :String, count :Int) = { // loopy style
    var x = input.size/2 ; var y = input.size/2 ; var dx = 0 ; var dy = -1 ; var infected = 0
    var ii = 0 ; while (ii < count) {
      val oldState = nodes.getOrElse((x, y), '.')
      val newState = evolve((evolve.indexOf(oldState)+1) % evolve.length)
      if (newState == '#') infected += 1
      nodes.put((x, y), newState)
      val (ndx, ndy) = oldState match {
        case '.' => ( dy, -dx)
        case 'W' => ( dx,  dy)
        case '#' => (-dy,  dx)
        case 'F' => (-dx, -dy)
      }
      x += ndx ; y += ndy ; dx = ndx ; dy = ndy ; ii += 1
    }
    infected
  }

  def mkNodes = MMap() ++ (for (y <- 0 until input.size ; x <- 0 until input.size)
                           yield (x, y) -> input(y)(x))
  def answer = (spreadf(mkNodes, ".#", 10000), spreadf(mkNodes, ".W#F", 10000000))
}
