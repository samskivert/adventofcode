object Day8 extends Day(8) {

  def diffdist (a :Double, b :Double, c :Double) = Math.sqrt(a*a + b*b + c*c)

  case class Box (x :Int, y :Int, z :Int) {
    def dist (o :Box) = diffdist((x-o.x).toDouble, (y-o.y).toDouble, (z-o.z).toDouble)
    override def toString = s"$x,$y,$z"
  }

  var nextGroup = 1

  case class BoxList (id :Int, boxes :Seq[Box]) {
    val closest = Array.tabulate(boxes.size)(bb => (bb, boxes(id).dist(boxes(bb)))).sortBy(_._2)
    var next = 1
    var group = 0
    def box = boxes(id)
    def nextClosestDist = if (next < closest.length) closest(next)._2 else 999999
    def linkNextClosest (lists :Array[BoxList]) = {
      val nextList = lists(closest(next)._1)
      if (nextList.group == 0) {
        if (group == 0) {
          group = nextGroup
          nextGroup += 1
        }
        nextList.group = group
      } else if (group == 0) {
        group = nextList.group
      } else if (nextList.group != group) {
        val toMerge = nextList.group
        for (list <- lists ; if list.group == toMerge) list.group = group
      }
      nextList.next += 1
      next += 1
      box.x * nextList.box.x
    }
    override def toString = s"$id/$group [$box]"
  }

  def parse (input :Seq[String]) = {
    val boxes = input.map(line => {
      val coords = line.split(",").map(_.toInt)
      Box(coords(0), coords(1), coords(2))
    })
    Array.tabulate(boxes.size)(ii => BoxList(ii, boxes))
  }

  override def answer1 (input :Seq[String]) = {
    val lists = parse(input)
    val iters = if (input.size == 20) 10 else 1000
    for (ii <- 0 until iters) lists.minBy(_.nextClosestDist).linkNextClosest(lists)
    val groups = lists.filter(_.group > 0).groupBy(_.group)
    groups.values.map(_.size).toSeq.sorted.reverse.take(3).reduce(_ * _)
  }

  override def answer2 (input :Seq[String]) = {
    val lists = parse(input)
    var lastDist = 0
    while (lists.exists(_.group == 0) || lists.map(_.group).toSet.size > 1) {
      lastDist = lists.minBy(_.nextClosestDist).linkNextClosest(lists)
    }
    lastDist
  }
}
