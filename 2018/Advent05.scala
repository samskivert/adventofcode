object Advent05 extends AdventApp {
  def reactFully (poly :String) = {
    val pb = new java.lang.StringBuilder(poly)
    def react (pos :Int, deleted :Boolean) :Boolean =
      if (pos >= pb.length-1) deleted
      else {
        val left = pb.charAt(pos) ; val right = pb.charAt(pos+1)
        if (left == right.toUpper && right == left.toLower ||
            right == left.toUpper && left == right.toLower) {
          pb.delete(pos, pos+2)
          react(pos, true)
        }
        else react(pos+1, deleted)
      }
    while (react(0, false)) {}
    pb.length
  }
  def filterReact (poly :String) = {
    def check (fu :Char, fU :Char) = reactFully(poly.filter(pu => pu != fu && pu != fU))
    ('a' to 'z').foldLeft(poly.length)((best, fu) => math.min(check(fu, fu.toUpper), best))
  }
  val polymer = readline("data/input05.txt")
  def answer = (reactFully(polymer), filterReact(polymer))
}
