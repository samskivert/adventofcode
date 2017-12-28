import scala.collection.mutable.{Map => MMap}
object Advent25 extends AdventApp {
  val states = Map('A' -> Array((1,  1, 'B'), (0, -1, 'C')),
                   'B' -> Array((1, -1, 'A'), (1, -1, 'D')),
                   'C' -> Array((1,  1, 'D'), (0,  1, 'C')),
                   'D' -> Array((0, -1, 'B'), (0,  1, 'E')),
                   'E' -> Array((1,  1, 'C'), (1, -1, 'F')),
                   'F' -> Array((1, -1, 'E'), (1,  1, 'A')))
  def eval (state :Char, head :Int, tape :MMap[Int,Int], iter :Int, max :Int) :Int =
    if (iter == max) tape.values.sum
    else {
      val (write, move, next) = states(state)(tape.getOrElse(head, 0))
      tape.put(head, write)
      eval(next, head+move, tape, iter+1, max)
    }
  def answer = eval('A', 0, MMap(), 0, 12172063)
}
