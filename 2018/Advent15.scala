import scala.reflect.ClassTag
object Advent15 extends AdventApp {
  final val Open = 0
  final val Wall = 1
  final val Elf = 0x100
  final val Gob = 0x200

  def hp (c :Int) = c & 0xFF
  def damage (c :Int, amt :Int) = {
    val nhp = hp(c) - amt
    if (nhp <= 0) Open else (c & 0xF00) | nhp
  }
  def isMob (c :Int) = (c > Wall)
  def isElf (c :Int) = (c & 0xF00) == Elf
  def isGob (c :Int) = (c & 0xF00) == Gob
  def isFoe (mob :Int, c :Int) = isMob(c) & (isElf(mob) != isElf(c))

  final val Pend = Short.MaxValue-2
  final val Full = Short.MaxValue-1

  val input = readlines("data/input15.txt").toSeq.map(_.toArray)
  val (width, height) = (input(0).size, input.size)
  def coord (x :Int, y :Int) = y*height+x
  val coords = for (y <- 1 to height-1 ; x <- 1 to width-1) yield coord(x, y)
  def neighbors (c :Int) = {
    val x = c%height ; val y = c/height
    Seq(coord(x, y-1), coord(x-1, y), coord(x+1, y), coord(x, y+1))
  }

  def battle (elfPower :Int) = {
    val field = input.flatten.map(_ match {
      case '#' => Wall
      case 'E' => Elf | 200
      case 'G' => Gob | 200
      case  _  => Open
    }).toArray

    def countMoves (from :Int, to :Int) = {
      val moves = field.map(cell => if (cell == Open) Pend else Full)
      moves(from) = 0
      neighbors(from) foreach { n => if (moves(n) == Pend) moves(n) = 1 }
      def grow (dist :Int) :Boolean = {
        var changed = false ; var reached = false
        for (coord <- coords ; if moves(coord) == dist ; n <- neighbors(coord)) {
          if (n == to) { reached = true }
          if (moves(n) == Pend) { moves(n) = dist+1 ; changed = true }
        }
        changed && !reached
      }
      var d = 1 ; while (grow(d)) d += 1
      moves
    }

    def attack (mob :Int, coord :Int) = {
      val foes = neighbors(coord).filter(n => isFoe(mob, field(n)))
      if (!foes.isEmpty) {
        val target = foes.minBy(n => (hp(field(n)), n))
        field(target) = damage(field(target), if (isElf(mob)) elfPower else 3)
      }
    }

    def move (mob :Int, coord :Int) :Boolean = {
      val targets = coords.filter(c => isFoe(mob, field(c)))
      if (targets.isEmpty) true
      else {
        if (neighbors(coord).exists(targets.contains)) attack(mob, coord)
        else {
          val openNeighbors = targets.flatMap(neighbors).filter(field(_) == Open)
          val paths = openNeighbors.map(nc => {
            val moveCounts = countMoves(nc, coord)
            val bestStep = neighbors(coord).minBy(moveCounts)
            (moveCounts(bestStep), bestStep)
          }).filter(_._1 < Pend)
          if (!paths.isEmpty) {
            val (_, newCoord) = paths.min
            field(newCoord) = field(coord)
            field(coord) = Open
            attack(mob, newCoord)
          }
        }
        false
      }
    }

    def step (round :Int) :(Int,Int) = {
      val done = (false /: coords.filter(c => isMob(field(c))))((done, coord) => {
        val c = field(coord)
        if (isMob(c)) move(c, coord) || done else done
      })
      if (!done) step(round+1)
      else (round * field.filter(isMob).map(hp).sum, field.count(isElf))
    }
    step(0)
  }

  def findWinPower :Int = {
    val needElves = input.map(_.count(_ == 'E')).sum
    var minp = 4 ; var maxp = 100 ; var minout = 0 ; var maxout = 0
    while (maxp - minp > 1) {
      val p = minp+(maxp-minp)/2
      val (out, elves) = battle(p)
      if (needElves == elves) { maxp = p ; maxout = out }
      else { minp = p ; minout = out }
    }
    maxout
  }

  def answer = (battle(3)._1, findWinPower)
}
