object Day7 extends Day(7) {

  override def answer1 (input :Seq[String]) =
    input.drop(1).foldLeft((Set(input(0).indexOf("S")), 0))((state, man) => {
      val (beams, splits) = state
      (beams.flatMap(b => if (man(b) == '^') Set(b-1, b+1) else Set(b)),
       splits + beams.count(b => man(b) == '^'))
    })._2

  override def answer2 (input :Seq[String]) = {
    def split (man :String, b :Int) = b >= 0 && b < man.length && man(b) == '^'
    val beams = input(0).map(c => if (c == 'S') 1L else 0L).toArray
    input.drop(1).foldLeft(beams)((beams, man) => Array.tabulate(beams.length)(b =>
      (if (split(man, b-1)) beams(b-1) else 0) +
      (if (!split(man, b))  beams(b)   else 0) +
      (if (split(man, b+1)) beams(b+1) else 0)
    )).sum
  }
}
