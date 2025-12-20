object Day11 extends Day(11) {

  override def example1 = "example11a.txt"
  override def example2 = "example11b.txt"

  def parseNode (line :String) = {
    val items = line.split(":")
    (items(0), items(1).trim.split(" ").toSeq)
  }

  override def answer1 (input :Seq[String]) = {
    val nodes = input.map(parseNode).toMap
    def count (node :String) :Int =
      if (node == "out") 1
      else nodes(node).map(count).sum
    count("you")
  }

  override def answer2 (input :Seq[String]) = {
    val nodes = input.map(parseNode).toMap
    def count (node :String, target :String, ignore :String) = {
      val cache = collection.mutable.Map("out" -> 0L, ignore -> 0L)
      def walk (node :String) :Long =
        if (node == target) 1L
        else cache.getOrElseUpdate(node, nodes(node).map(n => walk(n)).sum)
      walk(node)
    }
    // turns out there are no links from dac to fft, so we can ignore svr -> dac -> fft -> out
    count("svr", "fft", "dac") * count("fft", "dac", "") * count("dac", "out", "fft")
  }
}
