
function circularize {
  require("calc_stage_dV").
  require("hill_climb").

  UNTIL ALT:RADAR > 70000. {WAIT 0.}

  LOCK THROTTLE TO 0.

  SET circ_mnv TO NODE(0, 0, 0, 0).
  ADD circ_mnv.

  SET circ_mnv:ETA to MIN(ETA:APOAPSIS,ETA:PERIAPSIS).
  SET circ_mnv TO hill_climb(0, 1, 1).

  SET stage_dV TO calc_stage_dV().
  IF stage_dV < circ_mnv:DELTAV:MAG {
    PRINT "Not enough fuel in current stage:".
    PRINT stage_dV.
    STAGE.
    WAIT 1.
  }
}
