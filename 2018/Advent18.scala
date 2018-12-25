object Advent18 extends AdventApp {
  val input = readlines("data/input18.txt").toSeq
  val (width, height) = (input(0).size, input.size)
  val (bwidth, bheight) = (width+2, height+2)

  final val Open :Byte = 1
  final val Tree :Byte = 2
  final val Yard :Byte = 4
  final val TreeYard :Byte = 2|4

  type State = Array[Byte]
  val state = Array.fill(bwidth*bheight)(Open)
  for (y <- 1 to height ; x <- 1 to width) state(y*bwidth+x) = input(y-1)(x-1) match {
    case '.' => Open
    case '|' => Tree
    case '#' => Yard
  }

  val noff = Seq(-bwidth-1, -bwidth, -bwidth+1, -1, 1, bwidth-1, bwidth, bwidth+1)

  def evolve (state :State) = {
    val nstate = Array.fill(bwidth*bheight)(Open)
    def foldn (c :Int, z :Int)(f :(Int, Byte) => Int) :Int =
      (z /: noff)((acc, off) => f(acc, state(c+off)))
    for (y <- 1 to height ; x <- 1 to width ; c = y*bwidth+x) nstate(c) = state(c) match {
      case Open => if (foldn(c, 0)((t, n) => if (n == Tree) t+1 else t) >= 3) Tree else Open
      case Tree => if (foldn(c, 0)((t, n) => if (n == Yard) t+1 else t) >= 3) Yard else Tree
      case Yard => if ((foldn(c, 0)((m, n) => m | n) & TreeYard) == TreeYard) Yard else Open
    }
    nstate
  }

  def evolveN (n :Int) = {
    def eq (a :State)(b :State) = java.util.Arrays.equals(a, b)
    def seek (iter :Int, hist :List[State]) :(State, List[State]) = {
      val nhist = evolve(hist.head) :: hist
      if (hist.exists(eq(nhist.head))) (nhist.head, hist.reverse)
      else seek(iter+1, nhist)
    }
    val (lstate, hist) = seek(0, state :: Nil)
    val lstart = hist.indexWhere(eq(lstate))
    val llen = hist.length-lstart
    hist(lstart + (n - lstart) % llen)
  }

  def score (state :State) = state.count(_ == Tree) * state.count(_ == Yard)
  def answer = (score((state /: (0 until 10))((s, i) => evolve(s))), score(evolveN(1000000000)))
}
