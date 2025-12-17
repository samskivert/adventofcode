object Day9 extends Day(9) {

  case class Pos (x :Int, y :Int) {
    override def toString = s"$x,$y"
  }
  def area (a :Pos, o :Pos) = (Math.abs(a.x-o.x) + 1L) * (Math.abs(a.y-o.y) + 1L)
  def parse (input :Seq[String]) = input.map(_.split(",")).map(xy => Pos(xy(0).toInt, xy(1).toInt))

  override def answer1 (input :Seq[String]) = {
    val tiles = parse(input)
    (for (ii <- 0 until tiles.size ; jj <- ii+1 until tiles.size)
     yield area(tiles(ii), tiles(jj))).max
  }

  case class Edge (a :Pos, b :Pos) {
    def vert = a.x == b.x
    def crossesv (x :Int, y :Int) = y >= a.y && y <= b.y && x <= a.x
    def vcontains (x :Int, y :Int) = y >= a.y && y <= b.y && x == a.x
    def vstraddles (y :Int, x1 :Int, x2 :Int) = y >= a.y && y <= b.y && x1 < a.x && x2 > a.x
    def hstraddles (x :Int, y1 :Int, y2 :Int) = x >= a.x && x <= b.x && y1 < a.y && y2 > a.y
    override def toString = if (a.x == b.x) s"${a.x},${a.y}-${b.y}" else s"${a.x}-${b.x},${b.y}"
  }
  // edges are either horizontal or vertical, mkEdge ensures that either a.x < b.x or a.y < b.y
  def mkEdge (a :Pos, b :Pos) =
    if (a.x < b.x) Edge(a, b) else if (a.y < b.y) Edge(a, b) else Edge(b, a)

  def inside (vedges :Seq[Edge], x :Int, y :Int) =
    vedges.exists(_.vcontains(x, y)) || vedges.count(_.crossesv(x, y)) % 2 == 1

  def sidesInside (hedges :Seq[Edge], vedges :Seq[Edge], a :Pos, b :Pos) :Boolean = {
    def checkside (x :Int, y :Int, ex :Int, ey :Int, dx :Int, dy :Int) :Boolean = {
      if (x == ex && y == ey) true
      else if (!inside(vedges, x, y)) false
      else checkside(x+dx, y+dy, ex, ey, dx, dy)
    }
    val minx = Math.min(a.x, b.x) ; val maxx = Math.max(a.x, b.x)
    val miny = Math.min(a.y, b.y) ; val maxy = Math.max(a.y, b.y)
    // If one of our sides straddles an edge, we know the sides are not all inside...
    !vedges.exists(_.vstraddles(miny, minx, maxx)) &&
    !vedges.exists(_.vstraddles(maxy, minx, maxx)) &&
    !hedges.exists(_.hstraddles(minx, miny, maxy)) &&
    !hedges.exists(_.hstraddles(maxx, miny, maxy)) &&
    // ...but there are degenerate cases where the sides don't straddle an edge, but still may be
    // valid or invalid depending on the geometry of the polygon. For example:
    //
    //     ...*   *...         *...*
    //     ....   ....  vs     .....
    //     ...*...*...      ...*...*...
    //     ...........      ...........
    //
    // in both cases the rectangles created by the *s have the exact same set of edges (which do
    // not straddle any other edges), but one rectangle is "outside" and the other "inside" due to
    // the winding order. I didn't feel like figuring out how to account for the winding order when
    // doing the inside/outside tests, so I just fall back to brute force search of every tile if
    // all the previous checks pass.
    checkside(minx, miny, maxx, miny, 1, 0) && checkside(minx, maxy, maxx, maxy, 1, 0) &&
    checkside(minx, miny, minx, maxy, 0, 1) && checkside(maxx, miny, maxx, maxy, 0, 1)
  }

  def inside (hedges :Seq[Edge], vedges :Seq[Edge], a :Pos, b :Pos) :Boolean =
    // we know a and b are inside due to the way we construct possible rectangles
    inside(vedges, a.x, b.y) && inside(vedges, b.x, a.y) &&
    sidesInside(hedges, vedges, a, b)

  def isLeftTurn (a :Pos, b :Pos, c :Pos) =
    (a.y == b.y && a.x < b.x && c.y < b.y) ||
    (a.y == b.y && a.x > b.x && c.y > b.y) ||
    (a.x == b.x && a.y < b.y && c.x > b.x) ||
    (a.x == b.x && a.y > b.y && c.x < b.x)

  override def answer2 (input :Seq[String]) = {
    val tiles = parse(input)
    def tile (ii :Int) = tiles((ii + tiles.size) % tiles.size)

    val edges = (0 until tiles.size).map(nn => {
      val start = tile(nn) ; val end = tile(nn+1)
      val startLeft = isLeftTurn(tile(nn-1), start, end)
      val endLeft = isLeftTurn(start, end, tile(nn+2))
      // if the start or end are part of left turns, they are not included in the edge; this would
      // be a right turn if the polygon was specified in counter-clockwise order, but both the
      // example and my data were provided in clockwise order, so I just assume that
      val dx = Math.signum((end.x - start.x).toFloat).toInt
      val dy = Math.signum((end.y - start.y).toFloat).toInt
      mkEdge(if (startLeft) Pos(start.x + dx, start.y + dy) else start,
             if (endLeft) Pos(end.x - dx, end.y - dy) else end)
    })

    val (vedges, hedges) = edges.partition(_.vert)
    var best = 0L
    for (ii <- 0 until tiles.size ; jj <- ii+1 until tiles.size) {
      val a = area(tiles(ii), tiles(jj))
      if (a > best && inside(hedges, vedges, tiles(ii), tiles(jj))) {
        best = a
      }
    }
    best
  }
}
