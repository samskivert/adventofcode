object Advent20 extends AdventApp {
  class Particle (data :Array[Array[Int]]) {
    var ( x,  y,  z) = (data(0)(0), data(0)(1), data(0)(2))
    var (vx, vy, vz) = (data(1)(0), data(1)(1), data(1)(2))
    var (ax, ay, az) = (data(2)(0), data(2)(1), data(2)(2))
    def coord = (x, y, z)
    def tick () :Unit = { vx += ax ; x += vx ; vy += ay ; y += vy ; vz += az ; z += vz }
    def dist = Math.abs(x) + Math.abs(y) + Math.abs(z)
    override def toString = s"p=<$x, $y, $z> v=<$vx, $vy, $vz> a=<$ax, $ay, $az>"
  }

  def input = readlines("data/input20.txt")
  def parseCoord (cstr :String) = cstr.drop(3).replace(">", "").split(",").map(_.toInt)
  def parse (line :String) = new Particle(line.split(", ").map(parseCoord))

  // iterating for 500 ticks and calling it good is a terrible hack, but I've not though of any way
  // to easily determine that we've iterated long enough...
  def part1 = {
    val parts = input.map(parse).toArray
    0 until 500 foreach { ii => parts.foreach(_.tick()) }
    val closest = parts.minBy(_.dist)
    parts.indexOf(closest)
  }
  def part2 = {
    def collide (parts :Array[Particle]) = {
      val collided = parts.groupBy(_.coord).filter((k, v) => v.size > 1).values.flatten.toSet
      if (collided.isEmpty) parts else parts.filterNot(collided)
    }
    var parts = input.map(parse).toArray
    0 until 500 foreach { ii => parts.foreach(_.tick()) ; parts = collide(parts) }
    parts.length
  }
  def answer = (part1, part2)
}
