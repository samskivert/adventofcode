object Day4 extends Day(4):

  def parse (line :String) =
    val ranges = line.split(",").map(_.split("-")).map(pp => (pp(0).toInt, pp(1).toInt))
    (ranges(0), ranges(1))

  def subsumes (r1 :(Int, Int), r2: (Int, Int)) =
    (r1._1 <= r2._1 && r1._2 >= r2._2) || (r2._1 <= r1._1 && r2._2 >= r1._2)
  def contains (r :(Int, Int), n :Int) = r._1 <= n && r._2 >= n
  def overlaps (r1 :(Int, Int), r2: (Int, Int)) =
    contains(r1, r2._1) || contains(r1, r2._2) || contains(r2, r1._1) || contains(r2, r1._2)

  override def answer1 (input :Seq[String]) = input.map(parse).filter(subsumes).size
  override def answer2 (input :Seq[String]) = input.map(parse).filter(overlaps).size
