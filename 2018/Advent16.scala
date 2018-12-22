object Advent16 extends AdventApp {
  type Regs = Array[Int]
  type Op = (Regs,Int,Int,Int) => Unit

  val ops :Seq[Op] = Seq(
    (regs, a, b, c) => regs(c) = regs(a) + regs(b), // addr
    (regs, a, b, c) => regs(c) = regs(a) + b,       // addi
    (regs, a, b, c) => regs(c) = regs(a) * regs(b), // mulr
    (regs, a, b, c) => regs(c) = regs(a) * b,       // muli
    (regs, a, b, c) => regs(c) = regs(a) & regs(b), // banr
    (regs, a, b, c) => regs(c) = regs(a) & b,       // bani
    (regs, a, b, c) => regs(c) = regs(a) | regs(b), // borr
    (regs, a, b, c) => regs(c) = regs(a) | b,       // bori
    (regs, a, b, c) => regs(c) = regs(a),           // setr
    (regs, a, b, c) => regs(c) = a,                 // seti
    (regs, a, b, c) => regs(c) = if (a > regs(b)) 1 else 0,        // gtir
    (regs, a, b, c) => regs(c) = if (regs(a) > b) 1 else 0,        // gtri
    (regs, a, b, c) => regs(c) = if (regs(a) > regs(b)) 1 else 0,  // gtrr
    (regs, a, b, c) => regs(c) = if (a == regs(b)) 1 else 0,       // eqir
    (regs, a, b, c) => regs(c) = if (regs(a) == b) 1 else 0,       // eqri
    (regs, a, b, c) => regs(c) = if (regs(a) == regs(b)) 1 else 0, // eqrr
  )
  def parseRegs (sample :String) = sample.split("\\[|]")(1).split(", ").map(_.toInt)
  def parseInst (inst :String) = inst.split(" ").map(_.toInt)

  val input = readlines("data/input16.txt").toSeq
  val samples = Seq() ++ input.grouped(4).filter(_(0) startsWith "Before").map {
    case Seq(bef, ins, aft, _) => (parseRegs(bef), parseInst(ins), parseRegs(aft))
  }
  val testInsts = input.drop(samples.size*4+2).map(parseInst)

  def exec (op :Op, regs :Regs, ins :Array[Int]) = { op(regs, ins(1), ins(2), ins(3)) ; regs }
  def testOp (bef :Regs, ins :Array[Int], aft :Regs)(op :Op) :Boolean = {
    val regs = bef.clone
    exec(op, regs, ins)
    java.util.Arrays.equals(regs, aft)
  }

  val opsByCode = {
    var codes = ops.map(op => (op, ((0 to 15).toSet /: samples)(
      (cs, s) => if (testOp(s._1, s._2, s._3)(op)) cs else cs - s._2(0)))).toMap
    var known = Map[Int,Op]()
    while (known.size < ops.size) {
      codes = codes.mapValues(cs => cs -- known.keys)
      val (op, cs) = codes.minBy(_._2.size)
      if (cs.size != 1) throw new Error(cs.toString)
      known = known + (cs.head -> op)
      codes -= op
    }
    known
  }

  def answer = (samples count { case (b, i, a) => ops.filter(testOp(b, i, a)).size >= 3 },
                (new Array[Int](4) /: testInsts)((r, ins) => exec(opsByCode(ins(0)), r, ins))(0))
}
