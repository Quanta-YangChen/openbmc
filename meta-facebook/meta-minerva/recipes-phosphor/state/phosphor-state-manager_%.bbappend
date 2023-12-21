FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
 
#======================
# Workaround for minerva
#======================
CHASSIS_DEFAULT_TARGETS:remove:minerva = " \
    obmc-chassis-powerreset@{}.target.requires/phosphor-reset-chassis-on@{}.service \
    obmc-chassis-powerreset@{}.target.requires/phosphor-reset-chassis-running@{}.service \
    obmc-chassis-poweroff@{}.target.requires/obmc-power-stop@{}.service \
    obmc-chassis-poweron@{}.target.requires/obmc-power-start@{}.service \
"