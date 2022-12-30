object Day10 extends Day(10):

  def execute (input :Seq[String], sampler :(Int, Int) => Unit) =
    var reg = 1 ; var cycle = 1
    sampler(cycle, reg)
    for (line <- input)
      cycle += 1
      if line startsWith "addx " then
        sampler(cycle, reg)
        reg += line.drop(5).toInt
        cycle += 1
      sampler(cycle, reg)

  override def answer1 (input :Seq[String]) =
    var signal = 0
    execute(input, { (cycle, reg) =>
      if (cycle-20) % 40 == 0 then signal += cycle*reg
    })
    signal

  override def answer2 (input :Seq[String]) =
    var line = "" ; var lines = List[String]()
    execute(input, { (cycle, reg) =>
      val col = (cycle-1) % 40
      line += (if reg >= col-1 && reg <= col+1 then "#" else " ")
      if col == 39 then
        lines = line :: lines
        line = ""
    })
    "\n" + lines.reverse.mkString("\n")
