object Day21 extends Day(21):

  enum Op:
    case Add, Sub, Mul, Div

  enum Monkey:
    case Value (value :Long)
    case Binop (left :String, op :Op, right :String)

  class Monkeys (input :Seq[String]):
    private val monkeys = {
      val ops = Map("+" -> Op.Add, "-" -> Op.Sub, "*" -> Op.Mul, "/" -> Op.Div)
      input.map(_.split(": ")).map { parts =>
        parts(1).split(" ") match
        case Array(v)        => (parts(0), Monkey.Value(v.toInt))
        case Array(l, op, r) => (parts(0), Monkey.Binop(l, ops(op), r))
      }.toMap
    }

    def eval (id :String) :Long =
      monkeys(id) match
      case Monkey.Value(v) => v
      case Monkey.Binop(l, op, r) =>
        val (lv, rv) = (eval(l), eval(r))
        op match
        case Op.Add => lv+rv
        case Op.Sub => lv-rv
        case Op.Mul => lv*rv
        case Op.Div => lv/rv

    def uneval (id :String) :Long = monkeys(id) match
      case Monkey.Binop(l, _, r) =>
        if humn(l) then uneval(l, eval(r)) else uneval(r, eval(l))
      case _ => 0

    private def humn (id :String) :Boolean =
      id == "humn" || (monkeys(id) match
        case Monkey.Binop(l, _, r) => humn(l) || humn(r)
        case _ => false)

    private def uneval (id :String, expect :Long) :Long =
      monkeys(id) match
      case Monkey.Value(_) => expect // humn
      case Monkey.Binop(l, op, r) =>
        if humn(l) then
          val v = eval(r)
          op match
          case Op.Add => uneval(l, expect-v)
          case Op.Sub => uneval(l, expect+v)
          case Op.Mul => uneval(l, expect/v)
          case Op.Div => uneval(l, expect*v)
        else
          val v = eval(l)
          op match
          case Op.Add => uneval(r, expect-v)
          case Op.Sub => uneval(r, v-expect)
          case Op.Mul => uneval(r, expect/v)
          case Op.Div => uneval(r, v/expect)

  override def answer1 (input :Seq[String]) = Monkeys(input).eval("root")
  override def answer2 (input :Seq[String]) = Monkeys(input).uneval("root")
