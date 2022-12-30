object Day8 extends Day(8):

  def parseGrid (input :Seq[String]) = input.map(_.map(_ - '0'))

  def mapGrid[A] (grid :Seq[Seq[Int]])(f :(Array[Array[Int]], Int) => A) =
    def rays (row :Int, col :Int) =
      def slice (dr :Int, dc :Int) =
        val trees = collection.mutable.ArrayBuffer[Int]()
        var r = row+dr ; var c = col+dc
        while (r >= 0 && c >= 0 && r < grid.size && c < grid(0).size)
          trees.append(grid(r)(c))
          r += dr ; c += dc
        trees.toArray
      Array(slice(-1, 0), slice(1, 0), slice(0, -1), slice(0, 1))
    for (rr <- grid.indices ; cc <- grid(rr).indices) yield f(rays(rr, cc), grid(rr)(cc))

  override def answer1 (input :Seq[String]) =
    def isViz (rays :Array[Array[Int]], h :Int) = rays.exists(_.forall(_ < h))
    mapGrid(parseGrid(input))(isViz).filter(viz => viz).size

  override def answer2 (input :Seq[String]) =
    def viewDist (ray :Array[Int], h :Int) = ray.indexWhere(_ >= h) match
      case -1 => ray.size
      case  d => d+1
    mapGrid(parseGrid(input)) { (rays, h) => rays.map(r => viewDist(r, h)).product }.max
