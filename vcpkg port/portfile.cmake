vcpkg_from_github(
    OUT_SOURCE_PATH SOURCE_PATH
    REPO Walkever/Dummydll
    HEAD_REF master
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA
    OPTIONS -DINSTALL_PKG_CONFIG_MODULE=1
)
vcpkg_install_cmake()

vcpkg_fixup_cmake_targets(CONFIG_PATH lib/cmake/dummy TARGET_PATH share/dummydll)
#SET(VCPKG_POLICY_DLLS_WITHOUT_LIBS enabled)
#SET(VCPKG_POLICY_DLLS_WITHOUT_EXPORTS enabled)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
#file(REMOVE_RECURSE "${CURRENT_PACKAGES_DIR}/debug/lib" "${CURRENT_PACKAGES_DIR}/lib")

vcpkg_copy_pdbs()
vcpkg_fixup_pkgconfig()

file(INSTALL ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/${PORT} RENAME copyright)


