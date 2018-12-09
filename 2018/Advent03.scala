import java.util.regex.Pattern
object Advent03 extends AdventApp {
  case class Claim (id :Int, x :Int, y :Int, w :Int, h :Int)
  val claimRe = Pattern.compile("""#(\d+) @ (\d+),(\d+): (\d+)x(\d+)""")
  def parseClaim (claim :String) :Claim = {
    val m = claimRe.matcher(claim)
    def groupNum (idx :Int) = m.group(idx).toInt
    if (m.matches) Claim(groupNum(1), groupNum(2), groupNum(3), groupNum(4), groupNum(5))
    else Claim(-1, 0, 0, 0, 0)
  }
  val claims = Seq() ++ readlines("data/input03.txt").map(parseClaim)
  val Size = 1000
  def update (grid :Array[Int], idx :Int, f :Int => Int) :Array[Int] = {
    grid(idx) = f(grid(idx)) ; grid }
  def applyAt (grid :Array[Int], id :Int, x :Int, y :Int) =
    update(grid, y*Size+x, n => if (n == 0) id else -1)
  def applyClaim (grid :Array[Int], claim :Claim) :Array[Int] =
    (claim.y until claim.y+claim.h).foldLeft(grid)(
      (grid, y) => (claim.x until claim.x+claim.w).foldLeft(grid)(
        (grid, x) => applyAt(grid, claim.id, x, y)))
  val claimGrid = claims.foldLeft(Array.fill(Size*Size)(0))(applyClaim)
  val claimSizes = claimGrid.foldLeft(Map[Int,Int]().withDefaultValue(0))(
    (counts, id) => if (id > 0) counts.updated(id, counts(id)+1) else counts)
  def answer = (claimGrid.count(_ < 0), claims.filter(c => claimSizes(c.id) == c.w*c.h).head.id)
}
