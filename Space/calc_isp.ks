function calc_isp
{
  LOCAL isp IS 0.
  LIST ENGINES IN my_engines.
  FOR eng IN my_engines {
    IF eng:ignition AND NOT eng:flameout {
      SET isp TO isp + (eng:isp * (eng:MAXTHRUST / SHIP:MAXTHRUST)).
    }
  }
  RETURN isp.
}