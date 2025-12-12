object Day6 extends Day(6) {

  def eval (op :Char) :(Long, Long) => Long = op match {
    case '*' => _ * _
    case '+' => _ + _
  }

  override def answer1 (input :Seq[String]) = {
    val problems = input.map(_.trim.split(" +")).transpose
    problems.map(p => p.dropRight(1).map(_.toLong).reduce(eval(p.last(0)))).sum
  }

  override def answer2 (input :Seq[String]) = {
    val digits = input.dropRight(1) ; val ops = input.last
    def loop (pp :Int, sum :Long) :Long = if (pp >= ops.length) sum else {
      val end = ops.indexWhere(c => c != ' ', pp+1) match {
        case -1 => ops.length
        case np => np-1
      }
      val numbers = (pp until end).map(pos => digits.map(_(pos)).mkString.trim.toLong)
      loop(end+1, sum + numbers.reduce(eval(ops(pp))))
    }
    loop(0, 0)
  }
}
