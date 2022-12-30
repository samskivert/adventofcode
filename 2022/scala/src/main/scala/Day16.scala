object Day16 extends Day(16):

  class Valve (val id :String, val rate :Int, val outs :Seq[String]):
    var dists = Map[String, Int]()
    def computeDists (valves :Map[String, Valve]) =
      def scan (valve :String, dist :Int) :Unit =
        dists += (valve -> dist)
        for (ovalve <- valves(valve).outs)
          val odist = dists.getOrElse(ovalve, valves.size)
          if odist > dist+1 then scan(ovalve, dist+1)
      scan(id, 0)

  def parseValves (input :Seq[String]) =
    val pattern = """Valve (\S+) has flow rate=(\d+); tunnels? leads? to valves? (.*)""".r
    var valves = input.map({ input => pattern.findFirstMatchIn(input) match
      case Some(m) => Valve(m.group(1), m.group(2).toInt, m.group(3).split(", "))
      case None => Valve("", 0, Seq())
    })
    val valveMap = valves.map(v => (v.id -> v)).toMap
    valves.foreach(_.computeDists(valveMap))
    valveMap

  def solve (valves :Map[String, Valve], viaIds :Seq[String], remain :Int) =
    var ids = viaIds.toArray
    def scan (id :String, remain :Int, score :Int) :Int =
      val valve = valves(id)
      val nremain = remain-1
      val nscore = score + valve.rate * nremain
      var best = nscore
      var ii = 0 ; var ll = ids.size ; while (ii < ll) do
        val nid = ids(ii)
        if nid != "" then
          val dist = valve.dists(nid)
          if nremain > dist then
            ids(ii) = ""
            best = Math.max(best, scan(nid, nremain-dist, nscore))
            ids(ii) = nid
        ii += 1
      best
    val start = valves("AA")
    var best = 0
    for (ii <- ids.indices)
      val id = ids(ii)
      ids(ii) = ""
      val dist = start.dists(id)
      best = Math.max(scan(id, remain-dist, 0), best)
      ids(ii) = id
    best

  override def answer1 (input :Seq[String]) =
    val valves = parseValves(input)
    solve(valves, valves.values.filter(_.rate > 0).map(_.id).toArray, 30)

  def foldPerms[A] (ids :Array[String], zero :A)(op :(A, Seq[String], Seq[String]) => A) =
    def loop (acc :A, remain :Int, pos :Int, first :Seq[String], second :Seq[String]) :A =
      if remain == 0 then
        val nsecond = if pos < ids.size then second ++ ids.drop(pos) else second
        op(acc, first, nsecond)
      else (pos to ids.size-remain).foldLeft(acc) { (acc, tt) =>
        val nfirst = first :+ ids(tt)
        val nsecond = if tt > pos then second ++ ids.slice(pos, tt) else second
        loop(acc, remain-1, tt+1, nfirst, nsecond)
      }
    (1 to ids.size/2).foldLeft(zero) { (acc, pp) => loop(acc, pp, 0, Seq(), Seq()) }

  override def answer2 (input :Seq[String]) =
    val valves = parseValves(input)
    foldPerms(valves.values.filter(_.rate > 0).map(_.id).toArray, 0) { (acc, fst, snd) =>
      Math.max(acc, solve(valves, fst, 26) + solve(valves, snd, 26))
    }
