object Day25 extends Day(25):

  def add (a :Seq[Int], b :Seq[Int]) =
    var sum = List[Int]() ; var carry = 0
    for ((ad, bd) <- a.reverse.zipAll(b.reverse, 0, 0))
      var sd = ad+bd+carry
      carry = 0
      if (sd < -2) { carry -= 1 ; sd += 5 }
      else if (sd > 2) { carry += 1 ; sd -= 5 }
      sum = sd :: sum
    if carry != 0 then carry :: sum else sum

  override def answer1 (input :Seq[String]) =
    val s2D = Map('2' -> 2, '1' -> 1, '0' -> 0, '-' -> -1, '=' -> -2)
    val d2S = s2D.map(_.swap)
    input.map(_.map(s2D(_))).foldLeft(Seq())(add).map(d2S(_)).mkString

  override def answer2 (input :Seq[String]) = "🎄"
