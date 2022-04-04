#
# Copyright 2019 Ettus Research, a National Instruments Brand
#
# SPDX-License-Identifier: GPL-3.0-or-later
#

IF(ENABLE_X400)
        LIST(APPEND X410_SOURCES
        ${CMAKE_CURRENT_SOURCE_DIR}/thinbx_dboard.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/thinbx_dboard_init.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/thinbx_cpld_ctrl.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/thinbx_lo_ctrl.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/thinbx_expert.cpp
    )
    LIBUHD_APPEND_SOURCES(${X410_SOURCES})
ENDIF(ENABLE_X400)

