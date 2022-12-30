object Day15 extends Day(15):

  case class Bounds (l :Int, u :Int):
    def merge (o :Bounds) = Bounds(Math.min(l, o.l), Math.max(u, o.u))
    def span = u - l + 1
    def contains (v :Int) = l <= v && u >= v
    def overlaps (b :Bounds) = contains(b.l) || b.contains(u)
    def shouldMerge (b :Bounds) = overlaps(b) || (u+1 == b.l)

  case class Sensor (sx :Int, sy :Int, bx :Int, by :Int):
    def range = Math.abs(bx-sx) + Math.abs(by-sy)

  class SparseRange (sensors :Seq[Sensor], y :Int):
    var bounds = Bounds(0, 0)
    var spill = Bounds(0, 0)
    var count = 0

    for (s <- sensors)
      val xrange = s.range - Math.abs(y-s.sy)
      if xrange >= 0 then add(Bounds(s.sx-xrange, s.sx+xrange))

    def covered :Int = bounds.span + (if count > 1 then spill.span else 0)
    def contains (x :Int) = bounds.contains(x) || (count > 1 && spill.contains(x))
    def firstGap :Int = if count < 2 then -1 else bounds.u+1

    def add (b :Bounds) =
      if count == 0 then
        bounds = b
        count = 1
      else if bounds.shouldMerge(b) then
        bounds = bounds.merge(b)
        if count == 2 && bounds.shouldMerge(spill) then
          bounds = bounds.merge(spill)
          count = 1
      else if count == 1 then
        if b.l < bounds.l then
          spill = bounds
          bounds = b
        else spill = b
        count = 2
      else if spill.shouldMerge(b) then
        spill = spill.merge(b)
        if count == 2 && bounds.shouldMerge(spill) then
          bounds = bounds.merge(spill)
          count = 1
      else print("OVERFLOW!")

  val pattern = """Sensor at x=(-?\d+), y=(-?\d+): closest beacon is at x=(-?\d+), y=(-?\d+)""".r
  def parseSensor (input :String) = pattern.findFirstMatchIn(input) match
    case Some(m) => Sensor(m.group(1).toInt, m.group(2).toInt, m.group(3).toInt, m.group(4).toInt)
    case None    => Sensor(0, 0, 0, 0)

  override def answer1 (input :Seq[String]) =
    val sensors = input.map(parseSensor).sortWith(_.sx < _.sx)
    val y = if input.size == 14 then 10 else 2000000
    val sparse = SparseRange(sensors, y)
    val skip = Set(sensors.filter({ s => s.sy == y && sparse.contains(s.sx) }).map(_.sx) ++
                   sensors.filter({ s => s.by == y && sparse.contains(s.bx) }).map(_.bx))
    sparse.covered - skip.size

  override def answer2 (input :Seq[String]) =
    val sensors = input.map(parseSensor).sortWith(_.sx < _.sx)
    val max = if input.size == 14 then 20 else 4000000
    def loop (y :Int) :Long =
      var sparse = SparseRange(sensors, y)
      val x = sparse.firstGap
      if x >= 0 && x <= max then x.toLong * 4000000 + y
      else if y == max then 0
      else loop(y+1)
    loop(0)
