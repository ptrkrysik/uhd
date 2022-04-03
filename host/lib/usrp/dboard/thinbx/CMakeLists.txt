#
# Copyright 2019 Ettus Research, a National Instruments Brand
# Copyright 2022 Piotr Krysik <ptrkrysik@gmail.com>
#
# SPDX-License-Identifier: GPL-3.0-or-later
#

IF(ENABLE_X400)
    LIST(APPEND X411_SOURCES
        ${CMAKE_CURRENT_SOURCE_DIR}/thinbx_dboard.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/thinbx_dboard_init.cpp
        ${CMAKE_CURRENT_SOURCE_DIR}/thinbx_expert.cpp
    )
    LIBUHD_APPEND_SOURCES(${X411_SOURCES})
ENDIF(ENABLE_X400)
