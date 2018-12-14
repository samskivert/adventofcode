object Advent07 extends AdventApp {
  val input = readlines("data/input07.txt").map(line => (line.charAt(5), line.charAt(36))).toSeq
  val depends = input.groupBy(_._2).mapValues(_.map(_._1).toSet).withDefaultValue(Set())
  val steps = input.map(_._1).toSet ++ depends.keySet
  def startable (done :Set[Char]) = (steps -- done).filter(step => depends(step).subsetOf(done))
  def order (done :Seq[Char]) :String = if (done.size == steps.size) done.mkString
                                        else order(done :+ startable(done.toSet).min)
  def work (time :Int, done :Set[Char], jobs :Map[Int,(Char,Int)]) :Int = {
    val (working, finished) = jobs.partition((_, job) => job._2 > time)
    val ndone = done ++ finished.values.map(_._1)
    if (steps == ndone) time
    else {
      val idle = 0 until 5 filterNot working.contains
      val ready = startable(ndone) -- working.map(_._2._1)
      val start = idle.zip(ready.toSeq.sorted.map(t => (t, time+60+(t-'A')+1)))
      work(time+1, ndone, working ++ start)
    }
  }
  def answer = (order(Seq()), work(0, Set(), Map()))
}
