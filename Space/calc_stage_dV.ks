function calc_stage_dV
{
  require("calc_isp").
  LOCAL dV IS 0.
  LOCAL isp IS calc_isp().
  LOCAL g0 IS 9.80665.
  LOCAL remaining_fuel IS 
    (STAGE:RESOURCESLEX["LIQUIDFUEL"]:AMOUNT * STAGE:RESOURCESLEX["LIQUIDFUEL"]:DENSITY) + 
    (STAGE:RESOURCESLEX["OXIDIZER"]:AMOUNT * STAGE:RESOURCESLEX["OXIDIZER"]:DENSITY).

  SET dV TO ABS(g0 * isp * LN( (SHIP:MASS - remaining_fuel) / SHIP:MASS )).
  RETURN dV.
}