object Advent06 extends AdventApp {
  def distrib (banks :Array[Int]) = {
    val bcount = banks.length
    val maxidx = (0 until bcount) maxBy banks
    val count = banks(maxidx)
    val newbanks = banks.map(_ + count/bcount)
    newbanks(maxidx) -= count
    (1 to count % bcount) foreach { ii => newbanks((ii + maxidx) % bcount) += 1 }
    newbanks
  }
  // such ceremony just because Array.equals is broken... alas
  case class Mem (banks :Array[Int]) {
    override def equals (other :Any) = other match {
      case Mem(obanks) => java.util.Arrays.equals(banks, obanks)
      case _ => false
    }
  }
  def redistrib (mem :Mem, seen :List[Mem]) :(Mem, List[Mem]) =
    if (seen.contains(mem)) (mem, seen)
    else redistrib(Mem(distrib(mem.banks)), mem :: seen)
  val banks = Mem(readline("data/input06.txt").split("\t").map(_.toInt))
  val (repeat, seen) = redistrib(banks, Nil)
  def answer = (seen.length, seen.indexOf(repeat)+1)
}
