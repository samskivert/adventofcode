object Day22 extends Day(22):
  val deltas = Seq((1, 0), (0, 1), (-1, 0), (0, -1))

  enum Seg:
    case Move (n :Int)
    case Turn (n :Int) // 1 = right, -1 left

  case class Pos (x :Int, y :Int, orient :Int):
    def turn (n :Int) = Pos(x, y, (orient + n + 4) % 4)

  class Board (cells :Seq[Seq[Byte]], segs :Seq[Seg], side :Int, cube :Boolean):
    val width = cells.map(_.length).max
    val height = cells.length
    val geom = if side == 50 then Seq(
      ((1, 1), 2, (0, 2), 3),
      ((0, 3), 2, (1, 0), 3),
      ((1, 1), 0, (2, 0), 3),
      ((0, 3), 0, (1, 2), 3),
      ((1, 0), 2, (0, 2), 2),
      ((2, 0), 0, (1, 2), 2),
      ((2, 0), 3, (0, 3), 0),
    ) else Seq (
      ((2, 0), 0, (3, 2), 2),
      ((0, 1), 1, (2, 2), 2),
      ((2, 0), 3, (0, 1), 2),
      ((2, 0), 2, (1, 1), 3),
      ((1, 1), 1, (2, 2), 3),
      ((3, 2), 1, (0, 1), 3),
      ((3, 2), 3, (2, 1), 3),
    )

    def at (x :Int, y :Int) =
      val row = cells(y)
      if row.length <= x then 0 else row(x)

    def step (pos :Pos) =
      var Pos(x, y, orient) = pos
      val (dx, dy) = deltas(orient)
      val of = (x / side, y / side)
      x = (x + dx + width) % width
      y = (y + dy + height) % height
      if cube && of != (x / side, y / side) then
        val sfx = x % side ; val sfy = y % side
        def cross (df :(Int, Int), turn :Int) =
          val xo = df._1*side ; val yo = df._2*side
          turn match
          case 0 => x = xo + sfx        ; y = yo + sfy
          case 1 => x = xo + side-sfy-1 ; y = yo + sfx
          case 2 => x = xo + side-sfx-1 ; y = yo + side-sfy-1
          case 3 => x = xo + sfy        ; y = yo + side-sfx-1
          orient = (orient + turn) % 4
        def checkCross (gg :Int) :Unit =
          val (sf, sorient, df, turn) = geom(gg)
          if                   of == sf && orient == sorient then cross(df, turn)
          else if turn == 3 && of == df && orient == (sorient+1)%4 then cross(sf, 1)
          else if turn == 2 && of == df && orient == sorient then cross(sf, 2)
          else if turn == 0 && of == df && orient == 1 then cross(sf, 0)
          else if gg < geom.size-1 then checkCross(gg + 1)
        checkCross(0)
      Pos(x, y, orient)

    def advance (pos :Pos, count :Int) =
      var npos = pos
      var ii = 0 ; while (ii < count) do
        ii += 1
        var mpos = step(npos)
        while !cube && at(mpos.x, mpos.y) == 0 do mpos = step(mpos)
        if at(mpos.x, mpos.y) != 2 then npos = mpos
        else ii = count // break
      npos

    def follow () =
      var pos = Pos(cells(0).indexOf(1), 0, 0)
      for (seg <- segs) seg match
        case Seg.Move(n) => pos = advance(pos, n)
        case Seg.Turn(n) => pos = pos.turn(n)
      (pos.y+1) * 1000 + (pos.x+1) * 4 + pos.orient

  def parseNotes (input :Seq[String], cube :Boolean) =
    val codes = Map(' ' -> 0.toByte, '.' -> 1.toByte, '#' -> 2.toByte)
    val side = if input.size == 14 then 4 else 50
    val blankIdx = input.indexOf("")
    val cells = input.take(blankIdx).map({ _.map(codes) })
    val segs = input(blankIdx+1).foldLeft(Seq[Seg]()) { (acc, c) =>
      if c == 'R' then acc :+ Seg.Turn(1)
      else if c == 'L' then acc :+ Seg.Turn(-1)
      else acc.lastOption match
        case Some(Seg.Move(n)) => acc.take(acc.size-1) :+ Seg.Move(n*10+c.asDigit)
        case _                 => acc :+ Seg.Move(c.asDigit)}
    Board(cells, segs, side, cube)

  override def answer1 (input :Seq[String]) = parseNotes(input, false).follow()
  override def answer2 (input :Seq[String]) = parseNotes(input, true).follow()
