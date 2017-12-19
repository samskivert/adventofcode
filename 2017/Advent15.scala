object Advent15 extends AdventApp {
  val (factorA, factorB) = (16807L, 48271L)
  def next (v :Int, f :Long) = (v * f % 2147483647L).toInt
  def score (a :Int, b :Int) = if ((a & 0xFFFF) == (b & 0xFFFF)) 1 else 0
  def judge1 (valueA :Int, valueB :Int, rem :Int, matches :Int) :Int = if (rem == 0) matches else {
    val nextA = next(valueA, factorA) ; val nextB = next(valueB, factorB)
    judge1(nextA, nextB, rem - 1, matches + score(nextA, nextB))
  }
  def judge2 (startA :Int, startB :Int, count :Int) = {
    var valueA = startA ; var valueB = startB ; var matches = 0 ; var rem = count
    while (rem > 0) {
      do valueA = next(valueA, factorA) while (valueA % 4 != 0)
      do valueB = next(valueB, factorB) while (valueB % 8 != 0)
      matches += score(valueA, valueB)
      rem -= 1
    }
    matches
  }
  def answer = (judge1(679, 771, 40000000, 0), judge2(679, 771, 5000000))
}
