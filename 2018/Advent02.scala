object Advent02 extends AdventApp {
  val ids = readlines("data/input02.txt").toList
  def isN (len :Int)(id :String) = id.groupBy(c => c).values.exists(_.length == len)
  def cmp (cs :(Char, Char)) = cs._1 == cs._2
  def diff (ida :String, idb :String) = ida.zip(idb).map(cmp).map(b => if (b) 0 else 1).sum
  def common (ida :String, idb :String) = ida.zip(idb).filter(cmp).map(_._1).mkString
  def findDiff1 (ids :List[String], check :List[String]) :String =
    if (check.isEmpty) findDiff1(ids.tail, ids.tail.tail)
    else if (diff(ids.head, check.head) == 1) common(ids.head, check.head)
    else findDiff1(ids, check.tail)
  def answer = (ids.count(isN(2)) * ids.count(isN(3)), findDiff1(ids, ids.tail))
}
