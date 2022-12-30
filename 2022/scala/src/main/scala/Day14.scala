object Day14 extends Day(14):

  case class Pos (x :Int, y :Int):
    def plus (dx :Int, dy :Int) = Pos(x+dx, y+dy)
    def below (dx :Int) = plus(dx, 1)
    def apply (to :Pos)(op :Pos => Unit) =
      val dx = (to.x-x).signum ; val dy = (to.y-y).signum
      var pos = this
      while pos != to do
        op(pos)
        pos = pos.plus(dx, dy)
      op(pos)

  def parse (line :String) =
    line.split(" -> ").map(_.split(",")).map(pp => Pos(pp(0).toInt, pp(1).toInt))

  def flow (input :Seq[String], entry :Pos, useFloor :Boolean) =
    var cave = Map[Pos, Char]()
    for (verts <- input.map(parse) ; ii <- verts.indices.drop(1))
      verts(ii-1).apply(verts(ii)) { p => cave += (p -> '#') }

    val rocks = cave.size
    val maxY = cave.keys.map(_.y).max
    def drop (pos :Pos) :Option[Pos] =
      if !useFloor && pos.y >= maxY then None
      else if useFloor && pos.y >= maxY+1 then Some(pos)
      else if !cave.contains(pos.below(0)) then drop(pos.below(0))
      else if !cave.contains(pos.below(-1)) then drop(pos.below(-1))
      else if !cave.contains(pos.below(1)) then drop(pos.below(1))
      else Some(pos)

    while
      drop(entry) match
        case Some(pos) => cave += (pos -> 'O') ; pos != entry
        case None => false
    do ()
    cave.size-rocks

  override def answer1 (input :Seq[String]) = flow(input, Pos(500, 0), false)
  override def answer2 (input :Seq[String]) = flow(input, Pos(500, 0), true)
