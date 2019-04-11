
function execute_mnv {
  require("calc_isp").
  require("do_staging").
  SET mnv TO NEXTNODE.

  LOCAL op_mode IS 0.
  SET burn_time TO calc_maneuver_burn_time(mnv).
  LOCK burn_ETA TO (mnv:ETA - (burn_time / 2)).
  LOCK STEERING TO mnv:DELTAV.
  UNTIL vang(SHIP:FACING:VECTOR, mnv:DELTAV) < 0.25. {WAIT 0.}
  WARPTO(time:seconds + burn_ETA - 10).
  UNTIL burn_ETA <= 0 {WAIT 0.}
  set tset to 0.
  lock throttle to tset.
  set done to False.
  set dv0 to mnv:deltav.
  until done {
    do_staging().
    if ship:maxthrust = 0 {wait 0.} else {
      set max_acc to ship:maxthrust/ship:mass.
      set tset to min(mnv:deltav:mag/max_acc, 1).
    }
    if vdot(dv0, mnv:deltav) < 0 {
        lock throttle to 0.
        break.
    }
    if mnv:deltav:mag < 0.1 {
        wait until vdot(dv0, mnv:deltav) < 0.5.
        lock throttle to 0.
        set done to True.
    }
  }
  unlock steering.
  unlock throttle.
  wait 1.
  remove mnv.
  SET SHIP:CONTROL:PILOTMAINTHROTTLE TO 0.
}

function calc_maneuver_burn_time {
  parameter mnv.
  LOCAL isp IS calc_isp().
  LOCAL g0 IS 9.80665.
  LOCAL dV is mnv:deltaV:mag.
  LOCAL mf is SHIP:MASS / constant():e^(dV / (isp * g0)).
  LOCAL fuel_flow is (SHIP:MAXTHRUSTAT(0) / (isp * g0)).
  LOCAL t is (SHIP:MASS - mf) / fuel_flow.
  RETURN t.
}
