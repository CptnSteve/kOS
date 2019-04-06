
function hoh_transfer {
  require("execute_mnv").
  require("hill_climb").
  require("plan_next_mnv").

  IF HASTARGET {
    IF BODY = TARGET:BODY {
      SET trans_mnv TO NODE(TIME:SECONDS + 20,0,0,0).
      ADD trans_mnv.
      SET trans_mnv TO hill_climb(2, (TARGET:APOAPSIS - TARGET:SOIRADIUS * 0.6), 1).
      LOCAL t2 IS trans_mnv:OBT:PERIOD / 2.
      LOCAL target_theta IS 360 * (t2 / TARGET:OBT:PERIOD).
      LOCAL t1 IS ( OBT:PERIOD * (180 + target_theta - LONGITUDE + TARGET:LONGITUDE) ) / ( 360 * (1 - ORBIT:PERIOD / TARGET:ORBIT:PERIOD)).
      SET trans_mnv:ETA to t1.
      plan_next_mnv(TIME:SECONDS + trans_mnv:OBT:PERIOD/6).
    }
  execute_mnv(0).
  } ELSE PRINT "No target for transfer.".
}
