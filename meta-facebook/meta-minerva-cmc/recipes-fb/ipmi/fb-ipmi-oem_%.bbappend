FILESEXTRAPATHS:prepend := "${THISDIR}/fb-ipmi-oem:"

SRCREV = "4de58763759a84f257b342ad3fd780790da83fad"
SRC_URI += " \
    file://0001-Fix-issue-that-FRU-print-missing-last-one.patch \
"
