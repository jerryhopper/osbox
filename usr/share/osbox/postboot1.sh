#!/bin/bash

source /usr/share/osbox/variables


# check if there is any form of installation.
if [ ! -f "$OSBOX_STATE_FILE" ]; then
    osbox bootcheck
fi



OSBOX_ID=${$OSBOX_ID_FILE}
OSBOX_STATE=${$OSBOX_STATE_FILE}



$INSTALLSTATE

