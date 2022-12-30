object Day11 extends Day(11):

  val pattern = """Monkey (\d+):
                  |  Starting items: (.*)
                  |  Operation: new = old (.) (\S+)
                  |  Test: divisible by (\d+)
                  |    If true: throw to monkey (\d+)
                  |    If false: throw to monkey (\d+)""".stripMargin.r

  class Monkey (m :util.matching.Regex.Match):
    val op = m.group(3)
    val rhs = m.group(4)
    val divis = m.group(5).toLong
    val (onTrue, onFalse) = (m.group(6).toInt, m.group(7).toInt)
    val items = collection.mutable.ArrayBuffer(m.group(2).split(",").map(_.trim.toLong) :_*)
    var inspected = 0L

    def turn (monkeys :Seq[Monkey], reduce :Long, mod :Long) =
      for (item <- items)
        val n = if rhs == "old" then item else rhs.toLong
        val nn = if op == "*" then item * n else item + n
        var nitem = (nn / reduce) % mod
        monkeys(if nitem % divis == 0 then onTrue else onFalse).items += nitem
        inspected += 1
      items.clear()

  def process (input :Seq[String], rounds :Int, reduce :Int) =
    val monkeys = pattern.findAllMatchIn(input.mkString("\n")).map(m => Monkey(m)).toSeq
    val mod = monkeys.map(_.divis).product
    for (_ <- 0 until rounds ; monkey <- monkeys) monkey.turn(monkeys, reduce, mod)
    monkeys.map(_.inspected).sortWith(_ > _).take(2).product

  override def answer1 (input :Seq[String]) = process(input, 20, 3)
  override def answer2 (input :Seq[String]) = process(input, 10000, 1)
