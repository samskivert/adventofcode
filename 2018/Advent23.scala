object Advent23 extends AdventApp {
  case class Bot (x :Int, y :Int, z :Int, rad :Int) {
    def distance (x0 :Int, y0 :Int, z0 :Int) :Int = Math.abs(x-x0) + Math.abs(y-y0) + Math.abs(z-z0)
    def distance (b :Bot) :Int = distance(b.x, b.y, b.z)
    def overlaps (o :Bot) :Boolean = distance(o) <= rad + o.rad
    def originDist :Int = distance(0, 0, 0) - rad
  }

  val BotReg = raw"pos=<(-?\d+),(-?\d+),(-?\d+)>, r=(\d+)".r
  val bots = Seq() ++ readlines("data/input23.txt") map {
    case BotReg(x, y, z, r) => Bot(x.toInt, y.toInt, z.toInt, r.toInt) }
  val maxbot = bots.maxBy(_.rad)
  val maxclique = {
    import scala.collection.{BitSet => Verts}
    val ns = Array.tabulate(bots.size)(bi => Verts() ++ (
      for (obi <- 0 until bots.size ; if (bi != obi && bots(bi).overlaps(bots(obi)))) yield obi))
    val cs = Seq.newBuilder[Verts]
    def bk (r :Verts, p :Verts, x :Verts) :Unit =
      if (p.isEmpty && x.isEmpty) cs += r
      else if (!p.isEmpty) {
        var pp = p ; var xx = x
        for (v <- p -- ns(p.head)) {
          bk(r + v, pp & ns(v), xx & ns(v))
          pp -= v
          xx += v
        }
      }
    bk(Verts(), Verts() ++ (0 until ns.size), Verts())
    cs.result.maxBy(_.size).toSeq.map(bots)
  }

  def answer = (bots.count(bot => maxbot.distance(bot) <= maxbot.rad),
                maxclique.map(_.originDist).max)
}
