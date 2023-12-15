FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
OBMC_CONSOLE_TTYS = "ttyS0"

OBMC_CONSOLE_INST_CNT = "16"
OBMC_CONSOLE_INST = "${@' '.join(['{}'.format(i) for i in range(int(OBMC_CONSOLE_INST_CNT))])}"

RDEPENDS:${PN} += "bash"

SRC_URI:append = " file://server.ttyS0.conf \
                   file://client.2200.conf \
                   file://select-uart-mux \
                   file://obmc-console-ttyS0-ssh-mtia-blade-template@.service \
                   file://obmc-console-ttyS0-ssh-mtia-blade-tmplate.socket"

CLIENT_SERVICE_FMT = "${PN}-ttyS0-ssh-mtia-blade{0}@.service \
                      ${PN}-ttyS0-ssh-mtia-blade{0}.socket"

SYSTEMD_SERVICE:${PN}:append = " ${@compose_list(d, 'CLIENT_SERVICE_FMT', 'OBMC_CONSOLE_INST')} "

SRC_URI:remove = "file://${BPN}.conf"

SYSTEMD_SERVICE:${PN}:remove = "obmc-console-ssh.socket"
SYSTEMD_SERVICE:${PN}:remove = "obmc-console-ssh@.service"

PACKAGECONFIG:append = " concurrent-servers"

do_install:append() {
        # Install the server configuration, service and socket
        install -m 0755 -d ${D}${sysconfdir}/${BPN}
        install -m 0644 ${WORKDIR}/*.conf ${D}${sysconfdir}/${BPN}/
        install -m 0744 ${WORKDIR}/select-uart-mux ${D}${bindir}
        for i in ${OBMC_CONSOLE_INST};
        do
                sed -e "s/{blade_num}/${i}/g" ${WORKDIR}/obmc-console-ttyS0-ssh-mtia-blade-template@.service \
                > ${D}${systemd_system_unitdir}/obmc-console-ttyS0-ssh-mtia-blade${i}@.service
                sed -e "s/{blade_num}/${i}/g" -e "s/{port_num}/$(expr $i + 2200)/g" \
                ${WORKDIR}/obmc-console-ttyS0-ssh-mtia-blade-tmplate.socket \
                > ${D}${systemd_system_unitdir}/obmc-console-ttyS0-ssh-mtia-blade${i}.socket
        done

        # Remove upstream-provided server configuration
        rm -f ${D}${sysconfdir}/${BPN}/server.ttyVUART0.conf
        rm -rf ${D}${systemd_system_unitdir}/obmc-console-ssh@.service.d/
        rm -f ${D}${systemd_system_unitdir}/${BPN}-ssh@.service
        rm -f ${D}${systemd_system_unitdir}/${BPN}-ssh.socket
}
