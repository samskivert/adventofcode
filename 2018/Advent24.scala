object Advent24 extends AdventApp {
  enum AType { case B, S, F, C, R } ; import AType._
  case class Group (id :String, units :Int, hp :Int, attack :AType, damage :Int, initiative :Int,
                    weak :Set[AType], immune :Set[AType]) {
    def epower = units * damage
    def versus (target :Group) = units * (if (target.weak(attack)) damage*2
                                          else if (target.immune(attack)) 0
                                          else damage)
    def defend (attacker :Group) = copy(units = units - attacker.versus(this) / hp)
  }

  // meh, tired of writing ad-hoc parsers for English "data sets"
  val groups = Seq(Group("im0",  339,  6787, S, 192,  7, Set(B), Set(   )),
                   Group("im1", 3134,  1909, B,   5, 16, Set(R), Set(S,C)),
                   Group("im2", 3866, 10217, B,  25, 13, Set(B), Set(   )),
                   Group("im3", 6032,  3101, F,   4,  4, Set(C), Set(   )),
                   Group("im4", 2975,  3123, B,  10, 19, Set( ), Set(F,S)),
                   Group("im5", 1139,  7509, F,  49, 20, Set(S), Set(   )),
                   Group("im6", 6472,  8589, B,  12, 18, Set(R), Set(B  )),
                   Group("im7", 1242,  3025, C,  23, 17, Set(C), Set(   )),
                   Group("im8",  280,  3301, S,  90, 14, Set(R), Set(F  )),
                   Group("im9", 5463,  1741, C,   2,  2, Set( ), Set(   )),

                   Group("in0", 5068, 11409, B,   4,  1, Set(   ), Set(B    )),
                   Group("in1",  138, 24309, S, 351,  9, Set(B  ), Set(S    )),
                   Group("in2",  323, 36803, S, 227, 11, Set(S  ), Set(     )),
                   Group("in3", 5264, 34281, S,  12, 10, Set(F  ), Set(     )),
                   Group("in4", 5327, 21299, F,   6,  3, Set(R  ), Set(C    )),
                   Group("in5", 8661, 28468, F,   5,  8, Set(S  ), Set(     )),
                   Group("in6", 1283, 25737, B,  30,  5, Set(R,C), Set(     )),
                   Group("in7", 8070, 63467, F,  11,  6, Set(   ), Set(R,F  )),
                   Group("in8",  768, 15629, C,  38, 12, Set(   ), Set(C,F,S)),
                   Group("in9", 2080, 19161, B,  18, 15, Set(   ), Set(     )))

  case class Target(prio :Int, attId :String, defId :String)
  def targetSelect (atts :Seq[Group], defs :Set[Group]) :Seq[Target] =
    ((defs, Seq[Target]()) /: atts.sortBy(g => (-g.epower, -g.initiative)))((acc, att) => {
      val (rdefs, ts) = acc
      if (rdefs.isEmpty) acc
      else {
        val target = rdefs.maxBy(d => (att.versus(d), d.epower, d.initiative))
        if (att.versus(target) == 0) acc
        else (rdefs - target, ts :+ Target(-att.initiative, att.id, target.id))
      }
    })._2

  def battle (groups :Seq[Group]) :(Boolean,Int) = {
    val (imm, inf) = groups.partition(_.id.startsWith("im"))
    if (imm.isEmpty) (false, inf.map(_.units).sum)
    else if (inf.isEmpty) (true, imm.map(_.units).sum)
    else {
      val targets = (targetSelect(imm, inf.toSet) ++ targetSelect(inf, imm.toSet)).sortBy(_.prio)
      val ngroups = (groups /: targets)((gs, t) => gs.find(_.id == t.attId) match {
        case Some(att) =>
          val defIdx = gs.indexWhere(_.id == t.defId)
          val ndef = gs(defIdx).defend(att)
          if (ndef.units <= 0) gs.patch(defIdx, Seq(), 1)
          else gs.updated(defIdx, ndef)
        case None => gs // attacker died
      })
      if (ngroups == groups) (false, 0) else battle(ngroups) // "handle" stalemates
    }
  }

  def boostedBattle (groups :Seq[Group])(amount :Int) = battle(
    groups.map(g => if (g.id.startsWith("im")) g.copy(damage = g.damage + amount) else g))

  def answer = (battle(groups)._2,
                Stream.from(0).map(boostedBattle(groups)).dropWhile(!_._1).head._2)
}
