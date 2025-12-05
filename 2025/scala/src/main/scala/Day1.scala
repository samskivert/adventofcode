object Day1 extends Day(1):

  def readTurns (lines :Seq[String]) :Seq[Int] = lines.map {
    (turn) => (if turn.startsWith("L") then -1 else 1) * turn.substring(1).toInt
  }

  def rotate (value :Int, turn :Int) = (value + turn + 100) % 100

  override def answer1 (input :Seq[String]) = (readTurns(input).foldLeft((0, 50)) {
    case ((z, v), t) =>
      val nv = rotate(v, t)
      (if nv == 0 then z + 1 else z, nv)
  })._1

  override def answer2 (input :Seq[String]) = (readTurns(input).foldLeft((0, 50)) {
    case ((z, v), t) =>
      val xzs = Math.abs(t) / 100 // extra passes through zero
      val nv = rotate(v, t % 100)
      val zs = nv match {
        // if we land exactly on zero, count that as a pass through zero
        case 0 => 1
        // if we didn't start on zero and we passed through zero, count it
        case n => if (v != 0 && ((t < 0 && nv > v) || (t > 0 && nv < v))) then 1 else 0
      }
      (z + xzs + zs, nv)
  })._1
