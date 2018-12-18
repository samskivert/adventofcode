object Advent09 extends AdventApp {
  class Node (var prev :Node, var next :Node, val marble :Int) {
    def left (count :Int) :Node = if (count == 0) this else prev.left(count-1)
    def right (count :Int) :Node = if (count == 0) this else next.right(count-1)
    def append (marble :Int) :Node = {
      next.prev = new Node(this, next, marble) ; next = next.prev ; next }
    def remove () :Node = { next.prev = prev ; prev.next = next ; next }
  }
  def play (players :Int, maxMarble :Int) :Long = {
    val scores = new Array[Long](players)
    def place (current :Node, placer :Int, marble :Int) :Node = {
      if (marble % 23 == 0) {
        val left7 = current.left(7)
        scores(placer) += marble + left7.marble
        left7.remove()
      } else current.right(1).append(marble)
    }
    val start = new Node(null, null, 0) ; start.next = start ; start.prev = start
    (start /: (0 until maxMarble))((node, mm) => place(node, mm%players, mm+1))
    scores.max
  }
  def answer = (play(464, 70918), play(464, 7091800))
}
