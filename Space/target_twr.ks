
function target_twr {
  parameter tgt.
    LOCAL w IS MASS*9.81.
    LOCAL t IS SHIP:MAXTHRUSTAT(SHIP:DYNAMICPRESSURE).
    IF (t/(w)) < tgt {
      SET THROTTLE TO 1.
    } ELSE {
      LOCK THROTTLE TO (tgt * (w))/MAX(t,0.01).
    }
}
