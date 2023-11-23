#!/bin/bash

PRESENT=$1

# SGPIO Output 51(103)
MGMT_SFP_TX_DIS_R=103
if [ $PRESENT -eq 0 ]; then
    /usr/bin/gpioset 2 $MGMT_SFP_TX_DIS_R=0
    logger "MGMT_SFP_TX_DIS_R = 0 SFP_PRSNT"
else
    /usr/bin/gpioset 2 $MGMT_SFP_TX_DIS_R=1
    logger "MGMT_SFP_TX_DIS_R = 1 SFP_NOT_PRSNT"
fi
