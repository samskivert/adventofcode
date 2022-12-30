object Day20 extends Day(20):

  def mix (ns :Seq[Long], key :Int, mixes :Int) =
    var cc = ns.size
    var nvs = ns.zipWithIndex.map((n, ii) => (n*key, ii)).toArray
    var mm = mixes ; while mm > 0 do
      var nn = 0 ; while nn < cc do
        val ii = nvs.indexWhere(_._2 == nn)
        val (n, oo) = nvs(ii)
        if n != 0 then
          val nii = ((ii + cc-1 + (n % (cc-1))) % (cc-1)).toInt
          if nii < ii then System.arraycopy(nvs, nii, nvs, nii+1, ii-nii)
          else if nii > ii then System.arraycopy(nvs, ii+1, nvs, ii, nii-ii)
          nvs(nii) = (n, oo)
        nn += 1
      mm -= 1
    nvs.map(_._1)

  def decode (ns :Seq[Long]) =
    val ii0 = ns.indexOf(0)
    ns((ii0 + 1000) % ns.size) + ns((ii0 + 2000) % ns.size) + ns((ii0 + 3000) % ns.size)

  override def answer1 (input :Seq[String]) = decode(mix(input.map(_.toLong), 1, 1))
  override def answer2 (input :Seq[String]) = decode(mix(input.map(_.toLong), 811589153, 10))
