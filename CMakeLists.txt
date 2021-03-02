CMAKE_MINIMUM_REQUIRED (VERSION 3.0)
project(Dummydll)

include(GNUInstallDirs)
include(CheckIncludeFiles)
include(CMakePackageConfigHelpers)

option(BUILD_SHARED_LIBS "Build shared library" OFF)
if(APPLE)
    option(BUILD_FRAMEWORK "Build Framework bundle for OSX" OFF)
endif()

option(INSTALL_PKG_CONFIG_MODULE "Install dummy.pc file" ON)

set(PROJECT_VERSION_MAJOR "1")
set(PROJECT_VERSION_MINOR "0")
set(PROJECT_VERSION_PATCH "0")
set(PROJECT_VERSION ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH})

set(DUMMY_HEADERS
    include/dummydll.h
    include/pch.h
    include/targetver.h
)

set(DUMMY_SOURCES
    src/dllmain.cpp
    src/dummydll.cpp
    src/pch.cpp
)

if(BUILD_SHARED_LIBS)
    set(BUILD_SHARED_LIBS TRUE)
    add_definitions( -DBUILD_SHARED_LIBS=1 )
endif()

function(configure_pkg_config_file pkg_config_file_in)
    set(prefix ${CMAKE_INSTALL_PREFIX})
    set(exec_prefix ${CMAKE_INSTALL_FULL_BINDIR})
    set(libdir ${CMAKE_INSTALL_FULL_LIBDIR})
    set(includedir ${CMAKE_INSTALL_FULL_INCLUDEDIR})
    set(VERSION ${PROJECT_VERSION})
    string(REPLACE ".in" "" pkg_config_file ${pkg_config_file_in})
    configure_file(${pkg_config_file_in} ${pkg_config_file} @ONLY)
endfunction()

Add_library(Dummydll ${DUMMY_HEADERS} ${DUMMY_SOURCES})

#set(CMAKE_C_COMPILER gcc)
#set(CMAKE_C_FLAGS -m32)
#set(CMAKE_CXX_COMPILER g++)
#set(CMAKE_CXX_FLAGS -m32)

target_include_directories(Dummydll PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/include>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/include>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

set(LIB_CURRENT ${CMAKE_MATCH_1})
set(LIB_AGE ${CMAKE_MATCH_1})
set(LIB_REVISION ${CMAKE_MATCH_1})
set(LIB_SOVERSION ${CMAKE_MATCH_1})
#math(EXPR LIB_SOVERSION "${LIB_CURRENT} + ${LIB_AGE}")

set(LIB_VERSION "${LIB_SOVERSION}.${LIB_AGE}.${LIB_REVISION}")

#set_target_properties(
#    dummy PROPERTIES
#    SOVERSION ${LIB_SOVERSION}
#    VERSION ${LIB_VERSION}
#    PUBLIC_HEADER "${DUMMY_HEADERS}"
#)

if(BUILD_FRAMEWORK)
    set_target_properties(dummy PROPERTIES
        FRAMEWORK TRUE
        FRAMEWORK_VERSION ${PROJECT_VERSION}
        MACOSX_FRAMEWORK_IDENTIFIER dummydll.org
        MACOSX_FRAMEWORK_SHORT_VERSION_STRING ${PROJECT_VERSION}
        MACOSX_FRAMEWORK_BUNDLE_VERSION ${PROJECT_VERSION}
        XCODE_ATTRIBUTE_INSTALL_PATH "@rpath"
        OUTPUT_NAME dummy
    )
endif()

configure_pkg_config_file(dummy.pc.in)

install(TARGETS Dummydll
    EXPORT dummyTargets
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    FRAMEWORK DESTINATION ${CMAKE_INSTALL_PREFIX}
    PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/dummy
)

export(EXPORT dummyTargets FILE dummyTargets.cmake)

if(INSTALL_CMAKE_PACKAGE_MODULE)
    set(CMAKE_INSTALL_CONFIGDIR ${CMAKE_INSTALL_LIBDIR}/cmake/dummy)
    install(EXPORT dummyTargets
        DESTINATION ${CMAKE_INSTALL_CONFIGDIR}
    )
   include(CMakePackageConfigHelpers)

    configure_package_config_file(${PROJECT_SOURCE_DIR}/cmake/DummyConfig.cmake.in ${PROJECT_BINARY_DIR}/DummyConfig.cmake
        INSTALL_DESTINATION ${CMAKE_INSTALL_CONFIGDIR}
        PATH_VARS CMAKE_INSTALL_FULL_INCLUDEDIR
    )

    write_basic_package_version_file(${PROJECT_BINARY_DIR}/DummyConfigVersion.cmake
        VERSION ${PROJECT_VERSION}
        COMPATIBILITY SameMajorVersion
    )

    install(FILES ${PROJECT_BINARY_DIR}/DummyConfig.cmake ${PROJECT_BINARY_DIR}/DummyConfigVersion.cmake
        DESTINATION ${CMAKE_INSTALL_CONFIGDIR}
    )
endif()

if(INSTALL_PKG_CONFIG_MODULE)
    install(FILES ${CMAKE_CURRENT_BINARY_DIR}/dummy.pc
        DESTINATION ${CMAKE_INSTALL_LIBDIR}/pkgconfig
    )
endif()