function deorbit{
  require("do_staging").

  LOCK STEERING TO RETROGRADE.
  WAIT 20.
  GEAR ON.
  LOCK THROTTLE TO 0.1.
  UNTIL ALTITUDE < 35000 OR STAGE:NUMBER = 0 {
    do_staging().
  }
  LOCK THROTTLE TO 1.
  UNTIL STAGE:NUMBER = 0 {
    do_staging().
  }
}
