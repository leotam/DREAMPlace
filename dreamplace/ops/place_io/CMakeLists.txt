cmake_minimum_required(VERSION 3.0.2)

project(place_io)

find_program(PYTHON "python")
find_package(CUDA 9.0)
find_package(Boost 1.55.0 COMPONENTS iostreams timer chrono system)
find_package(ZLIB REQUIRED)
get_filename_component(LIMBO_DIR ${CMAKE_CURRENT_BINARY_DIR}/../../../thirdparty/Limbo ABSOLUTE)
get_filename_component(OPS_DIR ${CMAKE_CURRENT_SOURCE_DIR}/.. ABSOLUTE)
get_filename_component(UTILITY_LIBRARY_DIRS ${CMAKE_CURRENT_BINARY_DIR}/../utility ABSOLUTE)

if (NOT CMAKE_CUDA_FLAGS)
    set(CMAKE_CUDA_FLAGS "-gencode=arch=compute_60,code=sm_60")
endif()

if (PYTHON)
    set(SETUP_PY_IN "${CMAKE_CURRENT_SOURCE_DIR}/setup.py.in")
    set(SETUP_PY    "${CMAKE_CURRENT_BINARY_DIR}/setup.py")
    file(GLOB SOURCES 
        "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cpp"
        "${CMAKE_CURRENT_SOURCE_DIR}/src/*.c"
        )
    set(OUTPUT      "${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.stamp")

    configure_file(${SETUP_PY_IN} ${SETUP_PY})

    add_custom_command(OUTPUT ${OUTPUT}
        COMMAND ${PYTHON} ${SETUP_PY} build --build-temp=${CMAKE_CURRENT_BINARY_DIR}/build --build-lib=${CMAKE_CURRENT_BINARY_DIR}/lib
        COMMAND ${CMAKE_COMMAND} -E touch ${OUTPUT}
        DEPENDS ${SOURCES}
        )

    add_custom_target(clean_${PROJECT_NAME}
        COMMAND rm -rf ${OUTPUT} ${CMAKE_CURRENT_BINARY_DIR}/build ${CMAKE_CURRENT_BINARY_DIR}/lib
        )

    add_custom_target(${PROJECT_NAME} ALL DEPENDS ${OUTPUT})

    install(
        DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/lib/ DESTINATION dreamplace/ops/${PROJECT_NAME}
        )
    file(GLOB INSTALL_SRCS "${CMAKE_CURRENT_SOURCE_DIR}/*.py")
    list(FILTER INSTALL_SRCS EXCLUDE REGEX ".*setup.py$")
    install(
        FILES ${INSTALL_SRCS} DESTINATION dreamplace/ops/${PROJECT_NAME}
        )
endif()
