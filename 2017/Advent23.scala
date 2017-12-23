object Advent23 extends AdventApp {
  val prog = readlines("data/input23.txt") map(_.split(" ")) map(p => (p(0), p(1), p.last)) toSeq

  def reg (arg :String) = arg.charAt(0)-'a'
  def eval (regs :Array[Long], arg :String) =
    if (arg.charAt(0).isLetter) regs(reg(arg)) else arg.toLong

  val regs = Array.fill(8)(0L)
  def play (pc :Int, muls :Int) :Long = if (pc >= prog.size) muls else {
    val (op, a0, a1) = prog(pc)
    val (jmp, mm) = op match {
      case "set" => regs(reg(a0)) =  eval(regs, a1) ; (1L, 0)
      case "sub" => regs(reg(a0)) -= eval(regs, a1) ; (1L, 0)
      case "mul" => regs(reg(a0)) *= eval(regs, a1) ; (1L, 1)
      case "jnz" => if (eval(regs, a0) != 0) (eval(regs, a1), 0) else (1L, 0)
    }
    play(pc+jmp.toInt, muls + mm)
  }

  def count (n :Int, high :Int, c :Int) :Int = if (n > high) c else count(n+17, high, c + {
    val lim = math.sqrt(n).toInt+1
    def loop (ii :Int) :Int = if (ii == lim) 0 else if (n % ii == 0) 1 else loop(ii+1)
    loop(2)
  })
  def answer = (play(0, 0), count(108400, 125400, 0))
}
