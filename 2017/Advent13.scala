object Advent13 extends AdventApp {
  val input = readlines("data/input13.txt")
  val layers = input.map(_.split(": ").map(_.toInt)).map(a => (a(0), a(1))).toMap

  // we can tell if we're caught if we enter the layer on an even multiple of the period of the
  // scanner, the period being 2*(range-1); we enter a layer at `pos` at either time=pos or
  // time=pos+delay, so the probe function takes a delay and returns the layer range if caught,
  // zero otherwise
  def empty (delay :Int) = 0
  def probe (pos :Int)(range :Int)(delay :Int) = if ((pos+delay) % ((range-1)*2) == 0) range else 0
  val probes = 0 to layers.keys.max map(pos => layers get(pos) map(probe(pos)) getOrElse empty)

  def barge = probes.map(p => p(0)).zipWithIndex.map(si => si._1*si._2).sum
  def sneak (delay :Int) :Int = if (probes.exists(p => p(delay) > 0)) sneak(delay+1) else delay
  def answer = (barge, sneak(0))
}
