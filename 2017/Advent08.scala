object Advent08 extends AdventApp {
  type Regs = Map[String, Int]
  def get (regs :Regs, reg :String) = regs.getOrElse(reg, 0)
  def set (regs :Regs, reg :String, value :Int) = regs + (reg -> value)
  case class Instr (reg :String, op :Int => Int, dep :String, pred :Int => Boolean) {
    def exec (regs :Regs) = if (pred(get(regs, dep))) set(regs, reg, op(get(regs, reg))) else regs
  }

  def upop (op :String, amt :Int) :Int => Int = op match {
    case "inc" => _ + amt
    case "dec" => _ - amt
    case _ => throw new AssertionError(s"Unknown up op: $op")
  }
  def pred (op :String, rhs :Int) :Int => Boolean = op match {
    case "<"  => _ < rhs
    case ">"  => _ > rhs
    case "<=" => _ <= rhs
    case ">=" => _ >= rhs
    case "==" => _ == rhs
    case "!=" => _ != rhs
    case _ => throw new AssertionError(s"Unknown pred op: $op")
  }
  val RE = """(\w+) (\w+) (-?\d+) if (\w+) (\S+) (-?\d+)""".r
  def parse (instr :String) = instr match {
    case RE(reg, mop, mval, dep, dop, dval) =>
      Instr(reg, upop(mop, mval.toInt), dep, pred(dop, dval.toInt))
  }
  val instrs = readlines("data/input08.txt").map(parse).toList

  def exec (instrs :List[Instr], regs :Regs, maxhist :List[Int]) :List[Int] = instrs match {
    case Nil           => regs.values.max :: maxhist
    case instr :: rest => exec(rest, instr.exec(regs), regs.values.max :: maxhist)
  }
  val maxes = exec(instrs, Map("a" -> 0), Nil)
  def answer = (maxes.head, maxes.max)
}
