object Advent04 extends AdventApp {
  val phrases = readlines("data/input04.txt").toSeq
  def valid (phrase :Array[String]) = phrase.size == phrase.toSet.size
  def validA (phrase :String) = valid(phrase.split(" +"))
  def validB (phrase :String) = valid(phrase.split(" +").map(_.sorted))
  def answer = (phrases.filter(validA).size, phrases.filter(validB).size)
}
