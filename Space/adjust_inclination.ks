FUNCTION adjust_inclination {
  PARAMETER 
  tgt_apo IS TARGET:OBT:APOAPSIS, 
  tgt_peri IS TARGET:OBT:PERIAPSIS, 
  tgt_incl IS TARGET:OBT:INCLINATION, 
  tgt_LAN IS TARGET:OBT:LAN,
  tgt_peri_arg IS TARGET:OBT:ARGUMENTOFPERIAPSIS.

  // Check that vessel and target are orbiting the same body.
  // Kill current inclination (normalize to equator)
  // Set up normal maneuver at target:LAN (max 15 sec burn time)
}