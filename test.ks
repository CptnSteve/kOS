copypath("0:/general_lib.ks","").
copypath("0:/space_lib.ks","").

RUN ONCE general_lib.
RUN ONCE space_lib.

CLEARSCREEN.

do_staging().
