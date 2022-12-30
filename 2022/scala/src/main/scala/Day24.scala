object Day24 extends Day(24):

  enum Move (val mask :Byte, val dx :Int, val dy :Int):
    case Wait  extends Move(0,    0,  0)
    case Up    extends Move(0x1,  0, -1)
    case Right extends Move(0x2,  1,  0)
    case Down  extends Move(0x4,  0,  1)
    case Left  extends Move(0x8, -1,  0)
  import Move._

  case class Pos (x :Int, y :Int):
    def move (dir :Move) = Pos(x+dir.dx, y+dir.dy)
    def in (width :Int, height :Int) = x >= 0 && x < width && y >= 0 && y < height
    def idx (width :Int) = y*width + x
    def h (end :Pos) = Math.abs(x-end.x) + Math.abs(y-end.y)
    def phaseCoord (phase :Int) = phase*10000 + x*100 + y

  class Valley (input :Seq[String]):
    val width = input(0).size-2
    val height = input.size-2
    val entry = input(0).indexOf('.')-1
    val exit = input.last.indexOf('.')-1
    val cells = {
      val cellMap = Map('.' -> Wait, '>' -> Right, '^' -> Up, 'v' -> Down, '<' -> Left)
      var cells = new Array[Byte](width*height)
      for (ii <- input.indices ; yy = ii-1 if yy >= 0 && yy < height)
        val line = input(ii)
        val row = line.substring(1, line.size-1).map(c => cellMap(c).mask).toArray
        System.arraycopy(row, 0, cells, yy*width, width)
      cells
    }

    def blow (cells :Array[Byte]) =
      val ncells = new Array[Byte](cells.length)
      for (idx <- ncells.indices)
        val yy = idx / width ; val xx = idx % width ; val cell = cells(idx)
        for (dir <- Move.values if (cell & dir.mask) != 0)
          val nx = (xx + dir.dx + width) % width
          val ny = (yy + dir.dy + height) % height
          val nidx = ny*width+nx
          ncells(nidx) = (ncells(nidx) | dir.mask).toByte
      ncells

    def startToExit (phases :Int) =
      route(phases, Seq(Pos(entry, -1), Pos(exit, height)))
    def startToExitToStartToExit (phases :Int) =
      route(phases, Seq(Pos(entry, -1), Pos(exit, height), Pos(entry, -1), Pos(exit, height)))

    def route (phases :Int, route :Seq[Pos]) =
      var steps = 0 ; var ncells = cells
      for (ii <- route.indices.dropRight(1))
        val start = route(ii) ; val end = route(ii+1)
        val (nncells, psteps) = path(phases, ncells, start, end)
        steps += psteps
        ncells = nncells
      steps

    def path (phases :Int, cells :Array[Byte], start :Pos, end :Pos) :(Array[Byte], Int) =
      var bests = Map[Int, Int]()
      val first = (cells, start, 0, start.h(end))
      var nexts = collection.mutable.PriorityQueue(first)(Ordering.by(-_._4))
      while nexts.size > 0 do
        val (cells, pos, steps, _) = nexts.dequeue()
        if pos == end then return (cells, steps)
        val ncells = blow(cells) ; val nsteps = steps+1 ; val phase = nsteps % phases
        for (dir <- Move.values)
          val npos = pos.move(dir)
          if (npos == start && dir == Wait) || (npos == end) || // allow start/end even though OOB
             (npos.in(width, height) && ncells(npos.idx(width)) == 0) then
            val ncost = nsteps + npos.h(end) ; val npc = npos.phaseCoord(phase)
            if bests.getOrElse(npc, ncost+1) > ncost then
              bests += (npc -> ncost)
              nexts += ((ncells, npos, nsteps, ncost))
      (cells, 0)

  override def answer1 (input :Seq[String]) = Valley(input).startToExit(20)
  override def answer2 (input :Seq[String]) = Valley(input).startToExitToStartToExit(20)
