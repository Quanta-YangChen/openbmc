FILESEXTRAPATHS:prepend:minerva-cmc := "${THISDIR}/${PN}:"

SRC_URI:append:minerva-cmc = " \
    file://0001-increase-http-body-limit-value.patch \
"

