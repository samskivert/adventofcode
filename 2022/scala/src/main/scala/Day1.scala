object Day1 extends Day(1):

  def readElves (lines :Seq[String]) :Seq[Int] = lines.foldLeft(Seq(0)) {
    (es, elem) => if elem == "" then es :+ 0 else es.dropRight(1) :+ es.last + elem.toInt }

  override def answer1 (input :Seq[String]) = readElves(input).max
  override def answer2 (input :Seq[String]) = readElves(input).sortWith(_ > _).take(3).sum
