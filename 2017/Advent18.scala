object Advent18 extends AdventApp {
  val prog = readlines("data/input18.txt") map(_.split(" ")) map(p => (p(0), p(1), p.last)) toSeq

  def reg (arg :String) = arg.charAt(0)-'a'
  def eval (regs :Array[Long], arg :String) =
    if (arg.charAt(0).isLetter) regs(reg(arg)) else arg.toLong

  val regs = Array.fill(26)(0L)
  var sound = 0L
  def play (pc :Int) :Long = {
    val (op, a0, a1) = prog(pc)
    val (jmp, rcv) = op match {
      case "snd" => sound         =  eval(regs, a0) ; (1L, 0L)
      case "set" => regs(reg(a0)) =  eval(regs, a1) ; (1L, 0L)
      case "add" => regs(reg(a0)) += eval(regs, a1) ; (1L, 0L)
      case "mul" => regs(reg(a0)) *= eval(regs, a1) ; (1L, 0L)
      case "mod" => regs(reg(a0)) %= eval(regs, a1) ; (1L, 0L)
      case "rcv" => if (eval(regs, a0) > 0) (1L, sound)          else (1L, 0L)
      case "jgz" => if (eval(regs, a0) > 0) (eval(regs, a1), 0L) else (1L, 0L)
    }
    if (rcv != 0) rcv else play(pc+jmp.toInt)
  }

  def duet :Int = {
    import scala.collection.mutable.Queue
    val q0 = Queue[Long]() ; val q1 = Queue[Long]()
    class CPU (id :Long, inq :Queue[Long], outq :Queue[Long]) {
      var pc = 0
      var sent = 0
      val regs = Array.fill(26)(0L)
      regs(reg("p")) = id
      def run () :Unit = {
        val (op, a0, a1) = prog(pc)
        val jmp = op match {
          case "snd" => outq += eval(regs, a0) ; sent += 1 ; 1L
          case "set" => regs(reg(a0)) =  eval(regs, a1) ; 1L
          case "add" => regs(reg(a0)) += eval(regs, a1) ; 1L
          case "mul" => regs(reg(a0)) *= eval(regs, a1) ; 1L
          case "mod" => regs(reg(a0)) %= eval(regs, a1) ; 1L
          case "rcv" => if (inq.isEmpty) 0L else { regs(reg(a0)) = inq.dequeue ; 1L }
          case "jgz" => if (eval(regs, a0) > 0) eval(regs, a1) else 1L
        }
        if (jmp != 0) {
          pc += jmp.toInt
          run()
        } // otherwise "block"
      }
    }
    val cpu0 = new CPU(0, q0, q1) ; val cpu1 = new CPU(1, q1, q0)
    do { cpu0.run() ; cpu1.run() }
    while (!q0.isEmpty || !q1.isEmpty)
    cpu1.sent
  }

  def answer = (play(0), duet)
}
