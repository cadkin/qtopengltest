cmake_minimum_required(VERSION 3.24)

# Define project.
project(view CXX C)

set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_SHARED_LIBRARY_PREFIX "")
set(CMAKE_STATIC_LIBRARY_PREFIX "")

set(CMAKE_FIND_PACKAGE_TARGETS_GLOBAL ON)
set(CGAL_DO_NOT_WARN_ABOUT_CMAKE_BUILD_TYPE true)

# Find Qt5 Packages.
find_package(Qt5 REQUIRED COMPONENTS
    Core Gui Widgets OpenGL
)
list(APPEND ${PROJECT_NAME}_libs Qt5::Core Qt5::Widgets Qt5::Gui Qt5::OpenGL)

# Find all project files.
file(GLOB_RECURSE ${PROJECT_NAME}_SOURCES "src/**.cpp")
file(GLOB_RECURSE ${PROJECT_NAME}_HEADERS "include/**.h")

# Find the include directories.
include_directories("include")

# Outputs dirs for out targets.
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/lib)
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/bin)

# Make view application.
add_executable(
    ${PROJECT_NAME}
    ${${PROJECT_NAME}_HEADERS}
    ${${PROJECT_NAME}_SOURCES}
)
target_link_libraries(${PROJECT_NAME} ${${PROJECT_NAME}_libs})

# Automatically generate mocs.
set_property(TARGET ${PROJECT_NAME} PROPERTY AUTOMOC ON)
set_property(TARGET ${PROJECT_NAME} PROPERTY AUTORCC ON)

install(TARGETS ${PROJECT_NAME} DESTINATION "bin")
