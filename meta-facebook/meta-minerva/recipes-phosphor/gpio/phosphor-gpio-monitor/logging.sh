#!/bin/bash
# shellcheck source=meta-facebook/meta-minerva/recipes-minerva/plat-tool/files/minerva-common-functions
source /usr/libexec/minerva-common-functions

LOG_TYPE=$1
ASSERT=$2       
BLADE_NAME=$3

log_event() {
    local message=$1
    local level="xyz.openbmc_project.Logging.Entry.Level.Error"

    busctl call xyz.openbmc_project.Logging /xyz/openbmc_project/logging \
        xyz.openbmc_project.Logging.Create Create ssa{ss} "$message" \
        "$level" 1 "BLADE_NAME" "$BLADE_NAME"
}

if [ "$LOG_TYPE" = "blade_prsnt" ]; then
    if [ $ASSERT -eq 0 ]; then
        log_event "BLADE PRSNT ASSERT"
    else
        log_event "BLADE PRSNT DEASSERT"
    fi
elif [ "$LOG_TYPE" = "blade_pwrok" ]; then
    if [ $ASSERT -eq 0 ]; then
        log_event "BLADE PWROK ASSERT"
    else
        log_event "BLADE PEWOK DEASSERT"
    fi
elif [ "$LOG_TYPE" = "leak_detect" ]; then
    if [ $ASSERT -eq 0 ]; then
        log_event "LEAK DETECT ASSERT"
    else
        log_event "LEAK DETECT DEASSERT"
    fi
elif [ "$LOG_TYPE" = "rpu_ready" ]; then
    if [ $ASSERT -eq 1 ]; then
        log_event "RPU READY ASSERT"
    else
        log_event "RPU READY DEASSERT"
    fi
elif [ "$LOG_TYPE" = "cable_prsnt" ]; then
    if [ $ASSERT -eq 0 ]; then
        log_event "CABLE PRSNT ASSERT"
    else
        log_event "CABLE PRSNT DEASSERT"
    fi
elif [ "$LOG_TYPE" = "toggle_switch" ]; then
    if [ $ASSERT -eq 0 ]; then
        log_event "CR TOGGLE SWITCH ASSERT"
    else
        log_event "CR TOGGLE SWITCH DEASSERT"
    fi
elif [ "$LOG_TYPE" = "mgmt_sfp_prsnt" ]; then
    if [ $ASSERT -eq 0 ]; then
        set_gpio MGMT_SFP_TX_DIS 0
        log_event "MGMT-SFP PRSNT ASSERT"
    else
        set_gpio MGMT_SFP_TX_DIS 1
        log_event "MGMT-SFP PRSNT DEASSERT"
    fi
elif [ "$LOG_TYPE" = "mgmt_sfp_tx_fault" ]; then
    if [ $ASSERT -eq 1 ]; then
        log_event "MGMT-SFP TX FAULT ASSERT"
    else
        log_event "MGMT-SFP TX FAULT DEASSERT"
    fi
elif [ "$LOG_TYPE" = "mgmt_sfp_rx_los" ]; then
    if [ $ASSERT -eq 1 ]; then
        log_event "MGMT-SFP RX LOS ASSERT"
    else
        log_event "MGMT-SFP RX LOS DEASSERT"
    fi
fi



