object Day18 extends Day(18):

  case class Point (x: Int, y: Int, z: Int):
    def neighbors = Array(Point(x-1, y, z), Point(x+1, y, z),
                          Point(x, y-1, z), Point(x, y+1, z),
                          Point(x, y, z-1), Point(x, y, z+1))

  class Boulder (val cubes :Seq[Point]):
    val (minx, maxx) = (cubes.map(_.x).min, cubes.map(_.x).max)
    val (miny, maxy) = (cubes.map(_.y).min, cubes.map(_.y).max)
    val (minz, maxz) = (cubes.map(_.z).min, cubes.map(_.z).max)
    val (xspan, yspan, zspan) = (maxx-minx+1, maxy-miny+1, maxz-minz+1)
    var cells = new Array[Byte](xspan*yspan*zspan)

    private def idx (x :Int, y :Int, z :Int) = (z-minz)*xspan*yspan + (y-miny)*xspan + (x-minx)
    private def idx (p :Point) :Int = idx(p.x, p.y, p.z)
    private def oob (x :Int, y :Int, z :Int) =
      x < minx || y < miny || z < minz || x > maxx || y > maxy || z > maxz
    private def oob (p :Point) :Boolean = oob(p.x, p.y, p.z)
    private def fill (p :Point, v :Byte) :Unit =
      if !oob(p) then
        val ii = idx(p)
        if cells(ii) == 0 then
          cells(ii) = v
          for (np <- p.neighbors) fill(np, v)

    for (c <- cubes) cells(idx(c)) = 1
    for (x <- minx to maxx ; y <- miny to maxy ; z <- Seq(minz, maxz)) fill(Point(x, y, z), 2)
    for (x <- minx to maxx ; y <- Seq(miny, maxy) ; z <- minz to maxz) fill(Point(x, y, z), 2)
    for (x <- Seq(minx, maxx) ; y <- miny to maxy ; z <- minz to maxz) fill(Point(x, y, z), 2)

    def surface (p :Point) = p.neighbors.count(c => oob(c) || cells(idx(c)) != 1)
    def exposed (p :Point) = p.neighbors.count(c => oob(c) || cells(idx(c)) == 2)

  def parseCubes (input :Seq[String]) =
    input.map(_.split(",")).map(ps => Point(ps(0).toInt, ps(1).toInt, ps(2).toInt))

  override def answer1 (input :Seq[String]) =
    var boulder = Boulder(parseCubes(input))
    boulder.cubes.map(boulder.surface).sum

  override def answer2 (input :Seq[String]) =
    var boulder = Boulder(parseCubes(input))
    boulder.cubes.map(boulder.exposed).sum
