object Advent06 extends AdventApp {
  val coords = readlines("data/input06.txt").map(_.split(", ").map(_.toInt)).
    map(ab => (ab(0), ab(1))).toArray
  val (minx, miny) = (coords.map(_._1).min, coords.map(_._2).min)
  val (maxx, maxy) = (coords.map(_._1).max, coords.map(_._2).max)
  def mdist (x :Int, y :Int, coord :(Int, Int)) = math.abs(coord._1-x) + math.abs(coord._2-y)
  def sumdist (x :Int, y :Int) = coords.foldLeft(0)((d, c) => d + mdist(x, y, c))
  def answer = ({
    val areas = new Array[Int](coords.length)
    for (x <- minx to maxx ; y <- miny to maxy) {
      def closest (cc :Int, mincc :Int, mind :Int) :Int = if (cc == coords.length) mincc else {
        val dist = mdist(x, y, coords(cc))
        if (dist < mind) closest(cc+1, cc, dist)
        else if (dist == mind) closest(cc+1, -1, dist)
        else closest(cc+1, mincc, mind)
      }
      val coord = closest(0, 0, Short.MaxValue)
      if (coord >= 0) {
        if (x == minx || x == maxx || y == miny || y == maxy) areas(coord) = Short.MinValue
        areas(coord) += 1
      }
    }
    areas.max
  }, (for (x <- minx to maxx ; y <- miny to maxy ; if sumdist(x, y) < 10000) yield 1).sum)
}
