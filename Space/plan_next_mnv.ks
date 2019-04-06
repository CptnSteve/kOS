
function plan_next_mnv {
  PARAMETER node_time, alarm_name IS SHIP:NAME, alarm_note IS "<NOTE>".
  
  SET adj_mnv TO NODE(node_time, 0, 0, 0).
  ADD adj_mnv.

  ADDALARM("Raw", node_time-900, alarm_name, alarm_note).
}
