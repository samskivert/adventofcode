object Advent04 extends AdventApp {
  case class Day (id :Int, sleeps :Seq[(Int,Int)]) {
    def apply (sched :Array[Int]) = sleeps foreach {
      (start, end) => (start until end) foreach { min => sched(min) += 1 }
    }
  }

  def parseLog (entries :Seq[String], days :Seq[Day]) :Seq[Day] =
    if (entries.isEmpty) days
    else {
      val id = entries.head.split("Guard #")(1).split(" ")(0).toInt
      val dayents = entries.drop(1).takeWhile(ent => !ent.contains("Guard"))
      def minute (entry :String) = entry.substring(15, 17).toInt
      val day = Day(id, dayents.map(minute).grouped(2).map(s => s(0) -> s(1)).toArray)
      parseLog(entries.drop(1+dayents.size), days :+ day)
    }
  val days = parseLog(readlines("data/input04.txt").toArray.sorted, Seq())

  val guards = days.map(_.id).toSet.map(id => (id, new Array[Int](60))).toMap
  days foreach { day => day.apply(guards(day.id)) }

  def find (p :Array[Int] => Int) = {
    val (sid, ssched) = guards.maxBy((_, sched) => p(sched))
    val smin = (0 to 59) maxBy { min => ssched(min) }
    sid * smin
  }
  def answer = (find(_.sum), find(_.max))
}
