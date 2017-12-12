object Advent12 extends AdventApp {
  def parse (desc :String) = {
    val Array(id, conns) = desc.split(" <-> ")
    (id.toInt -> conns.split(", ").map(_.toInt).toList)
  }
  val graph = readlines("data/input12.txt").map(parse).toMap
  def expand (seek :List[Int], seen :Set[Int]) :Set[Int] = seek match {
    case Nil        => seen
    case nn :: rest => if (seen(nn)) expand(rest, seen)
                       else expand(rest ++ graph(nn), seen + nn)
  }
  def groups (seen :Set[Int], count :Int) :Int = (graph.keySet -- seen).toSeq match {
    case Seq()  => count
    case unseen => groups(seen ++ expand(List(unseen.head), Set()), count+1)
  }
  def answer = (expand(List(0), Set()).size, groups(Set(), 0))
}
