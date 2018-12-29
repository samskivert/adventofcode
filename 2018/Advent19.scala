object Advent19 extends AdventApp {
  type Regs = Array[Int]
  type Op = (Regs,Int,Int,Int) => Unit

  val ops = Map[String,Op](
    ("addr", (regs, a, b, c) => regs(c) = regs(a) + regs(b)),
    ("addi", (regs, a, b, c) => regs(c) = regs(a) + b),
    ("mulr", (regs, a, b, c) => regs(c) = regs(a) * regs(b)),
    ("muli", (regs, a, b, c) => regs(c) = regs(a) * b),
    ("setr", (regs, a, b, c) => regs(c) = regs(a)),
    ("seti", (regs, a, b, c) => regs(c) = a),
    ("gtrr", (regs, a, b, c) => regs(c) = if (regs(a) > regs(b)) 1 else 0),
    ("eqrr", (regs, a, b, c) => regs(c) = if (regs(a) == regs(b)) 1 else 0),
  )

  val input = readlines("data/input19.txt").toSeq
  val ipreg = input(0).split(" ")(1).toInt
  val insts = input.drop(1).map(_.split(" ")).map {
    case Array(inst, a, b, c) => (regs :Regs) => ops(inst)(regs, a.toInt, b.toInt, c.toInt)
  }

  def exec (regs :Regs) :Regs = {
    var ip = 0
    while (ip >= 0 && ip < insts.size) {
      regs(ipreg) = ip
      insts(ip)(regs)
      ip = regs(ipreg) + 1
    }
    regs
  }

  def answer = (exec(new Array[Int](6))(0),
                // reverse engineer assembly; figure out what it's doing; do it efficiently...
                (for (n <- 1 to 10551377 ; if (10551377 % n == 0)) yield n).sum)
}
