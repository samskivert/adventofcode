object Day12 extends Day(12) {

  override def answer1 (input :Seq[String]) = {
    def pat (a :String, b :String, c :String) =
      a.count(_ == '#') + b.count(_ == '#') + c.count(_ == '#')
    def loop (lines :Seq[String], pats :Seq[Int]) :Int = {
      if (lines(0).last == ':') loop(lines.drop(5), pats :+ pat(lines(1), lines(2), lines(3)))
      else lines.count(line => {
        val parts = line.split(":") ; val dims = parts(0).split("x")
        val size = dims(0).toInt * dims(1).toInt
        val needs = parts(1).trim.split(" ").map(_.toInt)
        needs.zipWithIndex.map((cc, ii) => pats(ii) * cc).sum <= size
      })
    }
    loop(input, Seq())
  }

  override def answer2 (input :Seq[String]) = "🎅🏼"
}
