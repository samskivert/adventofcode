object Day12 extends Day(12):

  type Grid = Seq[Array[Char]]
  case class Pos (row :Int, col :Int):
    def get (grid :Grid) = grid(row)(col)
    def onNeighbors (op :Pos => Unit) =
      for ((dr, dc) <- ndeltas) op(Pos(row+dr, col+dc))

  val ndeltas = Array((-1, 0), (0, -1), (1, 0), (0, 1))

  def indices (input :Grid) =
    for (row <- input.indices ; col <- input(row).indices) yield Pos(row, col)
  def pos (input :Grid, c :Char) = indices(input).find(_.get(input) == c).get

  def heightOf (c :Char) :Int = if c == 'S' then 0 else if c == 'E' then heightOf('z') else c - 97
  def height (elev :Grid, pos :Pos) = heightOf(pos.get(elev))

  def search (elev :Grid, start :Pos, end :Pos) :Option[Int] =
    var scan = collection.mutable.PriorityQueue((start, 0))(Ordering.by(-_._2))
    var minDist = Map(start -> 0)
    val gwidth = elev(0).size ; val gheight = elev.size
    while scan.size > 0 do
      val (pos, dist) = scan.dequeue()
      if pos == end then return Some(dist)
      val h = height(elev, pos) ; val ndist = dist+1
      pos.onNeighbors { npos =>
        if npos.row < 0 || npos.col < 0 || npos.row >= gheight || npos.col >= gwidth then {}
        else if height(elev, npos) - h > 1 then {}
        else if minDist.getOrElse(npos, ndist+1) <= ndist then {}
        else
          minDist += (npos -> ndist)
          scan += (npos -> ndist)
      }
    return None

  override def answer1 (input :Seq[String]) =
    val elevs = input.map(_.toArray)
    search(elevs, pos(elevs, 'S'), pos(elevs, 'E')).get

  override def answer2 (input :Seq[String]) =
    val elevs = input.map(_.toArray) ; val end = pos(elevs, 'E')
    val starts = indices(elevs).filter({ height(elevs, _) == 0 })
    starts.flatMap({ search(elevs, _, end) }).min
