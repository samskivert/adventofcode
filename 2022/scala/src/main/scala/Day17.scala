object Day17 extends Day(17):

  def row (cells :Byte*) = cells.toArray
  val pieces = Array(
    Array(row(1, 1, 1, 1)),
    Array(row(0, 1, 0), row(1, 1, 1), row(0, 1, 0)),
    Array(row(1, 1, 1), row(0, 0, 1), row(0, 0, 1)),
    Array(row(1), row(1), row(1), row(1)),
    Array(row(1, 1), row(1, 1)))

  class Chamber:
    val (width, height) = (7, 300)
    var grid = new Array[Byte](width*height)
    var blank = new Array[Byte](width*100)
    var offset = 0L

    def maxHeight = findEmpty(0) + offset

    def add (piece :Array[Array[Byte]], wind :String, wpos :Int) =
      // shift the board down by 100 rows if we're past 200 rows
      if findEmpty(0) > 200 then
        System.arraycopy(grid, 100*width, grid, 0, 200*width)
        System.arraycopy(blank, 0, grid, 200*width, blank.length)
        offset += 100
      // place the piece three above the highest row
      var pstart = findEmpty(0)+3
      for ((prow, ii) <- piece.zipWithIndex)
        val offset = (pstart+ii)*width + 2
        System.arraycopy(prow, 0, grid, offset, prow.length)
      // blow and drop the piece one row at a time until it lands
      var nwpos = wpos
      def loop (pstart :Int) :Int =
        blow(pstart, piece.length, wind(nwpos))
        nwpos = (nwpos + 1) % wind.size
        if !drop(pstart, piece.length) then loop(pstart-1)
        else pstart
      pstart = loop(pstart)
      // stamp the landed piece into the board
      for (row <- pstart until pstart+piece.size ; cc <- 0 until width)
        if cell(row, cc) == 1 then setCell(row, cc, 2)
      nwpos

    private def findEmpty (fromRow :Int) :Int =
      if fromRow < height && row(fromRow).exists(_ != 0) then findEmpty(fromRow+1) else fromRow

    private def row (row :Int) = grid.slice(row*width, row*width+width)
    private def cell (row :Int, col :Int) = grid(row*width+col)
    private def setCell (row :Int, col :Int, v :Byte) = grid(row*width+col) = v

    private def blow (pstart :Int, pheight :Int, wind :Char) =
      val left = wind == '<'
      val (sc, ec, dc) = if left then (0, width-1, 1) else (width-1, 0, -1)
      def blocked (rr :Int, cc :Int) :Boolean =
        val prow = pstart + rr
        if rr == pheight then false
        else if cc == ec then blocked(rr+1, sc)
        else if cell(prow, cc+dc) != 1 then blocked(rr, cc+dc)
        else if cell(prow, cc) != 0 then true
        else blocked(rr+1, sc)
      def shift (rr :Int, cc :Int) :Unit =
        val prow = pstart + rr
        if rr == pheight then ()
        else if cc == ec then shift(rr+1, sc)
        else if cell(prow, cc+dc) != 1 then shift(rr, cc+dc)
        else
          setCell(prow, cc, 1)
          setCell(prow, cc+dc, 0)
          shift(rr, cc+dc)
      if !blocked(0, sc) then shift(0, sc)

    private def drop (pstart :Int, pheight :Int) :Boolean =
      if pstart == 0 then return true
      // if any cells on the bottom edge of the piece can't drop, we landed
      val check = for (cc <- 0 until width ; rr <- pstart until pstart+pheight
                       if cell(rr, cc) == 1 && cell(rr-1, cc) == 2) yield true
      if !check.isEmpty then return true
      for (prow <- pstart until pstart+pheight ; cc <- 0 until width if cell(prow, cc) == 1)
          setCell(prow-1, cc, 1)
          setCell(prow, cc, 0)
      return false

  override def answer1 (input :Seq[String]) =
    val wind = input(0)
    var wpos = 0 ; var ppos = 0
    var chamber = Chamber()
    for (_ <- 0 until 2022)
      wpos = chamber.add(pieces(ppos), wind, wpos)
      ppos = (ppos + 1) % pieces.size
    chamber.maxHeight

  override def answer2 (input :Seq[String]) =
    val wind = input(0)
    var wpos = 0 ; var ppos = 0
    var chamber = Chamber()
    var zeros = Seq[(Int, Long, Long)]()
    val max = 1000000000000L
    var ii = 0L ; while ii < max do
      wpos = chamber.add(pieces(ppos), wind, wpos)
      ii += 1
      if ppos == 0 && ii < max/2 then
        val height = chamber.maxHeight
        // if we see a repeat of the same wind position on piece 0 (twice in a row) then we've
        // detected a cycle
        val cc = zeros.indexWhere(_._1 == wpos)
        if cc >= 0 && zeros(cc-1)._1 == zeros.last._1 then
          val (_, cii, cheight) = zeros(cc)
          val cycle = ii-cii ; val cycles = (max-ii)/cycle
          chamber.offset += cycles * (height-cheight)
          ii += cycles * cycle
        else
          zeros = zeros :+ (wpos, ii, height)
      ppos = (ppos + 1) % pieces.size
    chamber.maxHeight
