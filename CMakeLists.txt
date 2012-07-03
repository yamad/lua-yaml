cmake_minimum_required(VERSION 2.8.4)
project(lua-yaml)

set(LUAYAML_VERSION_MAJOR 0)
set(LUAYAML_VERSION_MINOR 3)
set(LUAYAML_VERSION_PATCH 1)
set(LUAYAML_VERSION_STRING "${LUAYAML_VERSION_MAJOR}.${LUAYAML_VERSION_MINOR}.${LUAYAML_VERSION_PATCH}")

function(add_libyaml)
  set(BUILD_SHARED_LIBS ON CACHE INTERNAL "Force libyaml shared" FORCE)
  set(BUILD_STATIC_LIBS OFF CACHE INTERNAL "Force no static libyaml" FORCE)
  set(BUILD_DOCS OFF CACHE INTERNAL "Force no docs" FORCE)
  set(BUILD_EXAMPLES OFF CACHE INTERNAL "Force no examples" FORCE)
  set(MAKE_PKGCONFIG OFF CACHE INTERNAL "Force no pkgconfig" FORCE)
  set(MAKE_LIBTOOL OFF CACHE INTERNAL "Force no libtool" FORCE)
  add_subdirectory(libyaml)
endfunction()

get_property(LUAYAML_INCLUDE_DIRS
  DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
  PROPERTY INCLUDE_DIRECTORIES)
message(STATUS "Includes: ${LUAYAML_INCLUDE_DIRS}")

add_libyaml()
include_directories("${lua_SOURCE_DIR}/src")
include_directories("${lua_BINARY_DIR}")
include_directories("${lua_BINARY_DIR}/src")
include_directories("${libyaml_SOURCE_DIR}/include")

add_library(lua_yaml SHARED lyaml.c b64.c)
set_target_properties(lua_yaml PROPERTIES
  PREFIX ""
  OUTPUT_NAME yaml)
target_link_libraries(lua_yaml yaml_shared)
if(CYGWIN OR MINGW)
  target_link_libraries(lua_yaml liblua)
endif(CYGWIN OR MINGW)

# add_custom_target(test-luayaml
#   COMMAND lua ${PROJECT_SOURCE_DIR}/test.lua
#   DEPENDS lua_yaml)
add_test(test-luayaml "lua" "${PROJECT_SOURCE_DIR}/test.lua")
if(TARGET check)
  add_dependencies(check test-luayaml)
else(TARGET check)
  add_custom_target(check DEPENDS test-luayaml)
endif(TARGET check)

set(CMAKE_INSTALL_RPATH_USE_LINK_PATH TRUE)
set(CMAKE_INSTALL_RPATH "\$ORIGIN/../lib:\$ORIGIN/lib:$ORIGIN/")
set_target_properties(lua_yaml PROPERTIES
  INSTALL_RPATH "\$ORIGIN/../lib:\$ORIGIN/lib:$ORIGIN/")
install(TARGETS lua_yaml DESTINATION lib)
