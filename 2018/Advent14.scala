object Advent14 extends AdventApp {
  def answer = {
    val target = 825401
    val board = new Array[Byte](32*1024*1024)
    var length = 0
    var p1 = 0L ; var p2 = 0
    def add (recipe :Int) = {
      board(length) = recipe.toByte
      length += 1
      def tail (w :Int) = (0L /: (0 until w))((s, i) => s*10+board(length-w+i))
      if (length == target+10) p1 = tail(10)
      if (length > 6 && tail(6) == target) p2 = length-6
    }
    add(3) ; add(7)
    var e1 = 0 ; var e2 = 1
    while (p1 == 0 || p2 == 0) {
      val ev1 = board(e1) ; val ev2 = board(e2) ; val sum = ev1+ev2
      if (sum > 9) add(sum/10)
      add(sum%10)
      e1 = (e1+ev1+1) % length
      e2 = (e2+ev2+1) % length
    }
    (p1, p2)
  }
}
