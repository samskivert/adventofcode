object Advent20 extends AdventApp {
  sealed trait Regex
  case class Step (dir :Char, next :Regex) extends Regex
  case class Branch (opts :List[Regex], next :Regex) extends Regex
  case object Term extends Regex

  final val Width = 1000
  final val Start = Width/2*Width + Width/2

  def parseRegex (source :String) :Regex = {
    def parse (pos :Int, next :Regex) :(Int, Regex) = source(pos) match {
      case '$' => parse(pos-1, next)
      case '^' => (0, next)
      case ')' =>
        def parseopts (opos :Int, opts :List[Regex]) :(Int, List[Regex]) = {
          val (npos, opt) = parse(opos-1, Term)
          if (source(npos) == '|') parseopts(npos, opt :: opts) else (npos, opt ::opts)
        }
        val (spos, opts) = parseopts(pos, Nil)
        parse(spos-1, new Branch(opts, next))
      case '|' => (pos, next)
      case '(' => (pos, next)
      case dir =>
        var reg = next ; var spos = pos
        while (Character.isLetter(source(spos))) { reg = Step(source(spos), reg) ; spos -= 1 }
        parse(spos, reg)
    }
    parse(source.length-1, Term)._2
  }

  def traverse (reg :Regex, pos :Int, plen :Int, tail :List[Regex],
                op :(Int,Int) => Boolean) :Unit = reg match {
    case Step(dir, next) =>
      val y = pos / Width ; val x = pos % Width
      val npos = dir match {
        case 'N' => (y-1) * Width + x
        case 'S' => (y+1) * Width + x
        case 'E' =>  y    * Width + x+1
        case 'W' =>  y    * Width + x-1
      }
      if (op(npos, plen+1)) traverse(next, npos, plen+1, tail, op)
    case Branch(opts, next) =>
      opts foreach { traverse(_, pos, plen, next :: tail, op) }
    case Term =>
      if (!tail.isEmpty) traverse(tail.head, pos, plen, tail.tail, op)
  }

  val input = readline("data/input20.txt")
  def answer = {
    val maxpath = new Array[Int](Width*Width)
    traverse(parseRegex(input), Start, 0, Nil, (p, plen) => {
      val oplen = maxpath(p)
      if (oplen > 0 && oplen <= plen) false else { maxpath(p) = plen ; true }
    })
    (maxpath.max, maxpath.filter(_ >= 1000).size)
  }
}
