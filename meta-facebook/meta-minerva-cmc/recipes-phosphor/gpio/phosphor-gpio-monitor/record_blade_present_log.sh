#!/bin/bash

PRESENT=$1       
BLADE_NAME=$2

if [ $PRESENT -eq 0 ]; then
    busctl call xyz.openbmc_project.Logging /xyz/openbmc_project/logging \
        xyz.openbmc_project.Logging.Create Create ssa{ss} "BLADE PRESENT" \
        "xyz.openbmc_project.Logging.Entry.Level.Error" 1 "BLADE NAME" $BLADE_NAME
else
    busctl call xyz.openbmc_project.Logging /xyz/openbmc_project/logging \
        xyz.openbmc_project.Logging.Create Create ssa{ss} "BLADE NOT PRESENT" \
        "xyz.openbmc_project.Logging.Entry.Level.Error" 1 "BLADE NAME" $BLADE_NAME
fi
