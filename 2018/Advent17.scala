object Advent17 extends AdventApp {
  val input = readlines("data/input17.txt").toSeq
  val VeinRE = java.util.regex.Pattern.compile("""(.)=(\d+), .=(\d+)\.\.(\d+)""")
  def parseVein (vein :String) = {
    val m = VeinRE.matcher(vein)
    def coord (g :Int) = m.group(g).toInt
    if (!m.matches) ((0, 0), (0, 0))
    else if (m.group(1) == "x") ((coord(2), coord(2)), (coord(3), coord(4)))
    else ((coord(3), coord(4)), (coord(2), coord(2)))
  }
  val veins = input map parseVein

  final val Sand    = 0
  final val Clay    = 1
  final val WetSand = 2
  final val Water   = 3
  def canFlow (ci :Int) :Boolean = (grid(ci) & 1) == 0 // Sand or WetSand

  val (grid, width, height, miny, springx) = {
    val (minx, maxx) = (veins.map(_._1._1).min, veins.map(_._1._2).max)
    val (width, height) = (maxx-minx+3, veins.map(_._2._2).max+1)
    val grid = new Array[Int](width*height)
    val xshift = 1-minx
    veins foreach { v => for (y <- v._2._1 to v._2._2 ;
                              rx <- v._1._1 to v._1._2 ; x = rx+xshift) grid(y*width+x) = Clay }
    (grid, width, height, veins.map(_._2._1).min, 500+xshift)
  }

  def flowV (grid :Array[Int], x :Int, y:Int) :Boolean = {
    val row = y*width
    if (y+1 == height) {
      grid(row+x) = WetSand
      false
    } else {
      val bi = (y+1)*width+x
      if (canFlow(bi)) {
        grid(row+x) = WetSand
        grid(bi) = Water
        flowV(grid, x, y+1)
      }
      if (canFlow(bi)) false
      else {
        val lb = flowH(grid, x, y, -1) ; val rb = flowH(grid, x, y,  1)
        if (lb >= 0 && rb >= 0) for (cx <- lb to rb) grid(row+cx) = Water
        else if (lb < 0 && rb >= 0) for (cx <- x to rb) grid(row+cx) = WetSand
        else if (lb >= 0 && rb < 0) for (cx <- lb to x) grid(row+cx) = WetSand
        lb >= 0 && rb >= 0
      }
    }
  }

  def flowH (grid :Array[Int], x :Int, y:Int, dir :Int) :Int = {
    val nx = x+dir ; var li = y*width+nx
    if (!canFlow(li)) x
    else {
      grid(li-dir) = WetSand
      grid(li) = Water
      val bi = (y+1)*width+nx
      if (!canFlow(bi) || flowV(grid, nx, y)) flowH(grid, nx, y, dir)
      else -1
    }
  }

  def answer = {
    flowV(grid, springx, 0)
    val counted = grid.drop(miny*width)
    (counted.count(c => c == Water || c == WetSand), counted.count(c => c == Water))
  }
}
