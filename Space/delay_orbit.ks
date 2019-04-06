function delay_orbit {
  require("execute_mnv").
  require("hill_climb").
  require("plan_next_mnv").

  CLEARSCREEN.

  IF HASTARGET {
    LOCAL t1 IS MOD(((SHIP:LONGITUDE + 360) - (TARGET:LONGITUDE)),360) * TARGET:OBT:PERIOD / 360.
    LOCAL delay_list IS LIST(t1, t1/2, t1/3, t1/4, t1/5).
    LOCAL deltaV_list IS LIST().

    plan_next_mnv(TIME:SECONDS+30).

    FOR delay_time IN delay_list {
      SET delay_mnv TO hill_climb(3,TARGET:ORBIT:PERIOD+delay_time,1).
      deltaV_list:ADD(delay_mnv:PROGRADE).
      IF delay_mnv:PROGRADE < 0 {
        PRINT "Delay function failure; Try again shortly.".
        PRINT "Ship Longitude:   " + SHIP:LONGITUDE + 360.
        PRINT "Target Longitude: " + TARGET:LONGITUDE + 360.
        PRINT "Calculated Theta: " + ((SHIP:LONGITUDE + 360) - (TARGET:LONGITUDE + 360)).
        deltaV_list:CLEAR().
        BREAK.
      }
      SET delay_mnv:PROGRADE TO 0.
    }

    PRINT deltaV_list.
    PRINT "SELECT # OF LAPS:".
    LOCAL laps IS TERMINAL:INPUT:GETCHAR().

    SET delay_mnv:PROGRADE TO deltaV_list[laps:TOSCALAR].

    execute_mnv().

    plan_next_mnv(TIME:SECONDS + delay_list[laps:TOSCALAR]).

  } ELSE PRINT "### No target selected. ###".
}
