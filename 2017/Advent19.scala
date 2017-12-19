object Advent19 extends AdventApp {
  val diagram = readlines("data/input19.txt").toArray
  def peek (row :Int, col :Int) = diagram(row).charAt(col)
  def turn (row :Int, col :Int) = if (peek(row, col) == ' ') 1 else -1
  def follow (row :Int, col :Int, dr :Int, dc :Int, steps :Int, seen :List[Char]) :(String, Int) = {
    val nrow = row+dr ; val ncol = col+dc ; val nsteps = steps+1
    peek(nrow, ncol) match {
      case ' ' => (seen.reverse.mkString, steps)
      case '|' => follow(nrow, ncol, dr, dc, nsteps, seen)
      case '-' => follow(nrow, ncol, dr, dc, nsteps, seen)
      case '+' => if (dr != 0) follow(nrow, ncol, 0, turn(nrow, ncol-1), nsteps, seen)
                  else         follow(nrow, ncol, turn(nrow-1, ncol), 0, nsteps, seen)
      case ltr => follow(nrow, ncol, dr, dc, nsteps, ltr :: seen)
    }
  }
  def answer = follow(0, diagram.head.indexOf('|'), 1, 0, 1, Nil)
}
