object Day5 extends Day(5):

  def execute (input :Seq[String])(move :(Array[List[Char]], Int, Int, Int) => Unit) =
    val stacks = Array.tabulate(1+input(0).length/4) { _ => List[Char]() }
    for (line <- input.takeWhile(_.contains("[")) ;
         (ii, cc) <- stacks.indices.map(ii => (ii, line(4*ii+1))) if cc != ' ')
      stacks(ii) :+= cc
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
