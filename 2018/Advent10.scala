object Advent10 extends AdventApp {
  val input = readlines("data/input10.txt").map(_.split("[<>, ]+")).map(
    d => (d(1), d(2), d(4), d(5))).toArray
  val (xpos, ypos) = (input.map(_._1.toInt), input.map(_._2.toInt))
  val (xvel, yvel) = (input.map(_._3.toInt), input.map(_._4.toInt))
  def step (dir :Int) :Unit = for (ii <- 0 until xpos.length) {
    xpos(ii) += xvel(ii)*dir
    ypos(ii) += yvel(ii)*dir
  }
  def loop (lastWidth :Int, sec :Int) :Int = {
    step(1)
    val nwidth = xpos.max - xpos.min
    if (nwidth < lastWidth) loop(nwidth, sec+1)
    else {
      step(-1)
      val active = (xpos zip ypos).toSet
      val minx = xpos.min ; val maxx = xpos.max
      for (y <- ypos.min to ypos.max) {
        println((minx to maxx).map(x => if (active((x, y))) "#" else ".").mkString)
      }
      sec
    }
  }
  def answer = loop(xpos.max-xpos.min, 0)
}
