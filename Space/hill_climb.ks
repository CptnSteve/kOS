
function hill_climb {
  PARAMETER prcs_ind, sp, ctrl_ind.

  SET hill_mnv TO NEXTNODE.
  IF prcs_ind = 0 {LOCK prcs_var TO hill_mnv:ORBIT:PERIAPSIS / hill_mnv:ORBIT:APOAPSIS.}
  ELSE IF prcs_ind = 1 {LOCK prcs_var TO hill_mnv:ORBIT:PERIAPSIS.}
  ELSE IF prcs_ind = 2 {LOCK prcs_var TO hill_mnv:ORBIT:APOAPSIS.}
  ELSE IF prcs_ind = 3 {LOCK prcs_var TO hill_mnv:ORBIT:PERIOD.}

  LOCAL step IS 10.

  IF ctrl_ind = 1 { // PROGRADE INDICATOR
    UNTIL step = 0.01 {
      SET err0 TO ABS(prcs_var - sp).
      SET hill_mnv:PROGRADE TO hill_mnv:PROGRADE - step.
      SET err_minus TO ABS(prcs_var - sp).
      SET hill_mnv:PROGRADE TO hill_mnv:PROGRADE + step * 2.
      SET err_plus TO ABS(prcs_var - sp).
      IF MIN(err0, MIN(err_minus,err_plus)) = err_plus {} 
      ELSE IF MIN(err0, err_minus) = err_minus {SET hill_mnv:PROGRADE TO hill_mnv:PROGRADE - 2 * step.} 
      ELSE {SET hill_mnv:PROGRADE TO hill_mnv:PROGRADE - step. SET step TO step / 10.}
    }
  }

  RETURN hill_mnv.
}