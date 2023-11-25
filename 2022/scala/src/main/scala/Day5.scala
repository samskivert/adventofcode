object Day5 extends Day(5):

  def execute (input :Seq[String])(move :(Array[List[Char]], Int, Int, Int) => Unit) =
    val stacks = input.takeWhile(_.contains("[")).transpose.zipWithIndex.
      filter((_, ii) => ii%4 == 1).map(_._1.filter(_ != ' ').toList).toArray
    for (Array(_, cc, _, ss, _, dd) <- input.filter(_.startsWith("move ")).map(_.split(" ")))
      move(stacks, cc.toInt, ss.toInt-1, dd.toInt-1)
    stacks.map(_.head).mkString("")

  override def answer1 (input :Seq[String]) = execute(input) { (stacks, cc, ss, dd) =>
    for (_ <- 1 to cc)
      stacks(dd) = stacks(ss).head :: stacks(dd)
      stacks(ss) = stacks(ss).tail
  }

  override def answer2 (input :Seq[String]) = execute(input) { (stacks, cc, ss, dd) =>
    stacks(dd) = stacks(ss).take(cc) ++ stacks(dd)
    stacks(ss) = stacks(ss).drop(cc)
  }
