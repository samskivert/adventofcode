object Day23 extends Day(23):
  val ndeltas = Seq((-1, -1), (-1, 0), (-1, 1), (0, -1), (0, 1), (1, -1), (1, 0), (1, 1))
  val moveDirs = Seq((0, -1, 1, 0), (0, 1, 1, 0), (-1, 0, 0, 1), (1, 0, 0, 1))

  case class Pos (x :Int, y :Int):
    def plus (dx :Int, dy :Int) = Pos(x+dx, y+dy)
    def anyNs (op :Pos => Boolean) = ndeltas.exists(dd => op(Pos(x+dd._1, y+dd._2)))

  def diffuse (elves :Set[Pos], round :Int) =
    var proposals = Map[Pos, Int]()
    var moves = Map[Pos, Pos]()
    def move (pos :Pos, mm :Int) :Unit =
      val (mx, my, dx, dy) = moveDirs((mm+round) % moveDirs.size)
      val mpos = pos.plus(mx, my)
      if !elves.contains(mpos) && !elves.contains(mpos.plus(dx, dy)) &&
         !elves.contains(mpos.plus(-dx, -dy)) then
        proposals += (mpos -> (1 + proposals.getOrElse(mpos, 0)))
        moves += (pos -> mpos)
      else if (mm < moveDirs.size-1) move(pos, mm+1)
    for (pos <- elves if pos.anyNs(elves.contains(_))) move(pos, 0)

    var nelves = elves
    for ((pos, mpos) <- moves if proposals(mpos) == 1)
      nelves -= pos
      nelves += mpos
    (nelves, moves.size)

  def bounds (elves :Set[Pos]) =
    var elf = elves.iterator.next
    var (minx, miny) = (elf.x, elf.y) ; var (maxx, maxy) = (minx, miny)
    for (pos <- elves)
      minx = Math.min(minx, pos.x)
      miny = Math.min(miny, pos.y)
      maxx = Math.max(maxx, pos.x)
      maxy = Math.max(maxy, pos.y)
    (Pos(minx, miny), Pos(maxx, maxy))

  def area (elves :Set[Pos]) =
    val (min, max) = bounds(elves)
    (max.x - min.x + 1) * (max.y - min.y + 1)

  def parseElves (input :Seq[String]) = input.indices.foldLeft(Set[Pos]()) { (elves, y) =>
    input(y).zipWithIndex.foldLeft(elves) { (elves, cx) =>
      if cx._1 == '#' then elves + Pos(cx._2, y) else elves
    }
  }

  override def answer1 (input :Seq[String]) =
    var elves = parseElves(input)
    for (rr <- 0 until 10) elves = diffuse(elves, rr)._1
    area(elves) - elves.size

  override def answer2 (input :Seq[String]) =
    var elves = parseElves(input)
    var rr = 0 ; while
      val (nelves, ms) = diffuse(elves, rr)
      elves = nelves
      ms > 0
    do rr += 1
    rr+1
