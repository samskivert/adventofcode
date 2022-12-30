object Day9 extends Day(9):

  def parse (input :Seq[String]) = input.map { line => (line(0), line.drop(2).toInt) }

  case class Knot (x :Int, y :Int):
    def move (dir :Char) = Knot(x + (if dir == 'R' then 1 else if dir == 'L' then -1 else 0),
                                y + (if dir == 'D' then 1 else if dir == 'U' then -1 else 0))
    def follow (head :Knot) =
      val dx = head.x - x ; val adx = Math.abs(dx)
      val dy = head.y - y ; val ady = Math.abs(dy)
      if adx < 2 && ady < 2 then this
      else Knot(if adx > 0 then x + dx/adx else x, if ady > 0 then y + dy/ady else y)

  def simulate (input :Seq[String], length :Int) =
    val rope = Array.tabulate(length) { _ => Knot(0, 0) }
    var seen = Set[Knot]()
    for ((dir, count) <- parse(input) ; _ <- 0 until count)
      for (ii <- rope.indices)
        if ii == 0 then rope(ii) = rope(ii).move(dir)
        else rope(ii) = rope(ii).follow(rope(ii-1))
      seen += rope.last
    seen.size

  override def example2 = "example9b.txt"
  override def answer1 (input :Seq[String]) = simulate(input, 2)
  override def answer2 (input :Seq[String]) = simulate(input, 10)
