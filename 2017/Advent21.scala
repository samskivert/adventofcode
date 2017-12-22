object Advent21 extends AdventApp {
  val lperms2 = Seq("0123", "1032", "2031", "0213").map(_.map(_ - '0'))
  val perms2 = lperms2 ++ lperms2.map(_.reverse)
  val lperms3 = Seq("012345678", "210543876", "630741852", "036147258").map(_.map(_ - '0'))
  val perms3 = lperms3 ++ lperms3.map(_.reverse)
  def permute (perm :Seq[Int], pat :String) = perm.map(pat.charAt).mkString
  def parse (line :String) = {
    val Array(inp, outp) = line.split(" => ")
    val in = inp.replaceAll("/", "") ; val out = outp.replaceAll("/", "")
    (if (in.length == 4) perms2 else perms3) map(perm => permute(perm, in) -> out)
  }
  val pats = readlines("data/input21.txt") flatMap(parse) toMap

  type Grid = Array[Array[Char]]
  def read (art :Grid, x :Int, y :Int, size :Int) :String =
    new String(Array.tabulate(size*size)(ii => art(y+ii/size)(x+ii%size)))
  def write (pat :String, art :Grid, x :Int, y :Int, size :Int) :Unit =
    for (ii <- 0 until pat.length) art(y+ii/size)(x+ii%size) = pat.charAt(ii)
  def evolve (grid :Grid) = {
    val size = grid.length ; val step = if (size % 2 == 0) 2 else 3
    val nsize = size/step * (step+1) ; val ngrid = Array.fill(nsize, nsize)('.')
    for (y <- 0 until size/step ; x <- 0 until size/step) {
      val ox = x*step ; val oy = y*step ; val nx = x*(step+1) ; val ny = y*(step+1)
      write(pats(read(grid, ox, oy, step)), ngrid, nx, ny, step+1)
    }
    ngrid
  }

  def start = Array(".#.", "..#", "###").map(_.toCharArray)
  def iter (iters :Int) = (start /: (0 until iters))((g, _) => evolve(g))
  def pop (grid :Grid) = grid map(_.count(_ == '#')) sum
  def answer = (pop(iter(5)), pop(iter(18)))
}
