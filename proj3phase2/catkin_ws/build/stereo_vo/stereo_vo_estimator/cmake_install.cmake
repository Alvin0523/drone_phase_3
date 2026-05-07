# Install script for directory: /home/wm_u26/hkust/elec5660_proj3/proj3phase2/catkin_ws/src/stereo_vo/stereo_vo_estimator

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/home/wm_u26/hkust/elec5660_proj3/proj3phase2/catkin_ws/install")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "RELEASE")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set path to fallback-tool for dependency-resolution.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/home/wm_u26/hkust/elec5660_proj3/proj3phase2/catkin_ws/.pixi/envs/default/bin/x86_64-conda-linux-gnu-objdump")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/stereo_vo/msg" TYPE FILE FILES "/home/wm_u26/hkust/elec5660_proj3/proj3phase2/catkin_ws/src/stereo_vo/stereo_vo_estimator/msg/relative_pose.msg")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/stereo_vo/cmake" TYPE FILE FILES "/home/wm_u26/hkust/elec5660_proj3/proj3phase2/catkin_ws/build/stereo_vo/stereo_vo_estimator/catkin_generated/installspace/stereo_vo-msg-paths.cmake")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/include" TYPE DIRECTORY FILES "/home/wm_u26/hkust/elec5660_proj3/proj3phase2/catkin_ws/devel/include/stereo_vo")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/roseus/ros" TYPE DIRECTORY FILES "/home/wm_u26/hkust/elec5660_proj3/proj3phase2/catkin_ws/devel/share/roseus/ros/stereo_vo")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/common-lisp/ros" TYPE DIRECTORY FILES "/home/wm_u26/hkust/elec5660_proj3/proj3phase2/catkin_ws/devel/share/common-lisp/ros/stereo_vo")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/gennodejs/ros" TYPE DIRECTORY FILES "/home/wm_u26/hkust/elec5660_proj3/proj3phase2/catkin_ws/devel/share/gennodejs/ros/stereo_vo")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  execute_process(COMMAND "/home/wm_u26/hkust/elec5660_proj3/proj3phase2/catkin_ws/.pixi/envs/default/bin/python3.12" -m compileall "/home/wm_u26/hkust/elec5660_proj3/proj3phase2/catkin_ws/devel/lib/python3.12/site-packages/stereo_vo")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/python3.12/site-packages" TYPE DIRECTORY FILES "/home/wm_u26/hkust/elec5660_proj3/proj3phase2/catkin_ws/devel/lib/python3.12/site-packages/stereo_vo")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/lib/pkgconfig" TYPE FILE FILES "/home/wm_u26/hkust/elec5660_proj3/proj3phase2/catkin_ws/build/stereo_vo/stereo_vo_estimator/catkin_generated/installspace/stereo_vo.pc")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/stereo_vo/cmake" TYPE FILE FILES "/home/wm_u26/hkust/elec5660_proj3/proj3phase2/catkin_ws/build/stereo_vo/stereo_vo_estimator/catkin_generated/installspace/stereo_vo-msg-extras.cmake")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/stereo_vo/cmake" TYPE FILE FILES
    "/home/wm_u26/hkust/elec5660_proj3/proj3phase2/catkin_ws/build/stereo_vo/stereo_vo_estimator/catkin_generated/installspace/stereo_voConfig.cmake"
    "/home/wm_u26/hkust/elec5660_proj3/proj3phase2/catkin_ws/build/stereo_vo/stereo_vo_estimator/catkin_generated/installspace/stereo_voConfig-version.cmake"
    )
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  file(INSTALL DESTINATION "${CMAKE_INSTALL_PREFIX}/share/stereo_vo" TYPE FILE FILES "/home/wm_u26/hkust/elec5660_proj3/proj3phase2/catkin_ws/src/stereo_vo/stereo_vo_estimator/package.xml")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
if(CMAKE_INSTALL_LOCAL_ONLY)
  file(WRITE "/home/wm_u26/hkust/elec5660_proj3/proj3phase2/catkin_ws/build/stereo_vo/stereo_vo_estimator/install_local_manifest.txt"
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
endif()
