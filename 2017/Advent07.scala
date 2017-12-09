object Advent07 extends AdventApp {
  val RE = """([a-z]+) \((\d+)\)( -> )?(.*)""".r
  case class Prog (name :String, weight :Int, above :List[String])
  def parse (line :String) = line match {
    case RE(n, w, _, on) => Prog(n, w.toInt, if (on != "") on.split(", ").toList else Nil)
    case _               => Prog(s"<invalid: $line>", 0, Nil)
  }
  val progs = (readlines("data/input07.txt") map parse).toList
  val toProg = progs.map(p => (p.name, p)).toMap

  def findRoot (seen :Set[String], remain :List[Prog]) :Prog = remain match {
    case root :: Nil => root
    case _ =>
      val (ready, unready) = remain.partition(_.above.forall(seen))
      findRoot(seen ++ ready.map(_.name), unready)
  }
  val root = findRoot(Set(), progs)

  def weight (prog :String) :Int = weight(toProg(prog))
  def weight (prog :Prog) :Int = prog.weight + prog.above.map(weight).sum
  def same (weights :List[Int]) = weights.isEmpty || weights.tail.forall(_ == weights.head)
  def findWobble (prog :Prog) :Int = {
    val weights = prog.above.groupBy(weight)
    val wobble = (weights.collectFirst { case (_, prog :: Nil) => prog }).map(toProg).get
    if (!same(wobble.above.map(weight))) findWobble(wobble)
    else (weights.keySet - weight(wobble)).head - wobble.above.map(weight).sum
  }
  def answer = (root.name, findWobble(root))
}
