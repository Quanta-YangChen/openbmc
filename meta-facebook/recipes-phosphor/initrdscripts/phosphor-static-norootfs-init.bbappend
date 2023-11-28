FILESEXTRAPATHS:append := ":${THISDIR}/${PN}"
SOURCE_FILES:append = "${@bb.utils.contains('MACHINE_FEATURES', 'fb-secondary-emmc', '', ' 95-mount-persistent-fb', d)}"

do_install:append() {
	if [ "${@bb.utils.contains('MACHINE_FEATURES', 'fb-secondary-emmc', '1', '0', d)}" = "0" ] ; then
        install -d ${D}/mnt/data
	fi
}

FILES:${PN} += "/mnt/data"
