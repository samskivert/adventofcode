object Day13 extends Day(13):

  enum Input:
    case One (value :Int)
    case List (values :Seq[Input])
  import Input._

  def parseInput (line :String) =
    var pos = 0
    def parse () :Input = line(pos) match
      case '[' =>
        var values = collection.mutable.ArrayBuffer[Input]()
        while
          pos += 1 // skip [ or ,
          if line(pos) != ']' then values += parse()
          line(pos) == ','
        do ()
        pos += 1 // skip ]
        List(values.toSeq)
      case _ =>
        val num = line.substring(pos).takeWhile(_.isDigit)
        pos += num.size
        One(num.toInt)
    parse()

  def compare (l1 :Seq[Input], l2 :Seq[Input]) :Int =
    var ii = 0 ; while ii < l1.size do
      if l2.size <= ii then return 1
      val cmp = compare(l1(ii), l2(ii))
      if cmp != 0 then return cmp
      ii += 1
    if l1.size == l2.size then 0 else -1

  def compare (i1 :Input, i2 :Input) :Int = (i1, i2) match
    case (One (v1), One (v2)) => v1 - v2
    case (One (v1), _       ) => compare(List(Seq(i1)), i2)
    case (List(l1), List(l2)) => compare(l1, l2)
    case _                    => compare(i1, List(Seq(i2)))

  override def answer1 (input :Seq[String]) =
    input.grouped(3).map(gg => (parseInput(gg(0)), parseInput(gg(1)))).zipWithIndex.
    map((pp, ii) => if compare(pp._1, pp._2) < 0 then ii+1 else 0).sum

  override def answer2 (input :Seq[String]) =
    val div1 = List(Seq(List(Seq(One(2))))) ; val div2 = List(Seq(List(Seq(One(6)))))
    val inputs = input.filter(_ != "").map(parseInput) ++ Seq(div1, div2)
    val sorted = inputs.sortWith({ compare(_, _) <= 0 })
    (1 + sorted.indexOf(div1)) * (1 + sorted.indexOf(div2))
