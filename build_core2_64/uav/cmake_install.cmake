# Install script for directory: /home/alexmiro/flair/custom_demos/flair-estimatorMass/uav

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "")
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

if("${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}/home/alexmiro/flair/flair-install/bin/demos/core2-64/estimatorMass/estimatorMass_rt" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/home/alexmiro/flair/flair-install/bin/demos/core2-64/estimatorMass/estimatorMass_rt")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}/home/alexmiro/flair/flair-install/bin/demos/core2-64/estimatorMass/estimatorMass_rt"
         RPATH "")
  endif()
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/alexmiro/flair/flair-install/bin/demos/core2-64/estimatorMass/estimatorMass_rt")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/alexmiro/flair/flair-install/bin/demos/core2-64/estimatorMass" TYPE EXECUTABLE FILES "/home/alexmiro/flair/custom_demos/flair-estimatorMass/build_core2_64/uav/estimatorMass_rt")
endif()

if("${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}/home/alexmiro/flair/flair-install/bin/demos/core2-64/estimatorMass/estimatorMass_nrt" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/home/alexmiro/flair/flair-install/bin/demos/core2-64/estimatorMass/estimatorMass_nrt")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}/home/alexmiro/flair/flair-install/bin/demos/core2-64/estimatorMass/estimatorMass_nrt"
         RPATH "")
  endif()
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/alexmiro/flair/flair-install/bin/demos/core2-64/estimatorMass/estimatorMass_nrt")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/alexmiro/flair/flair-install/bin/demos/core2-64/estimatorMass" TYPE EXECUTABLE FILES "/home/alexmiro/flair/custom_demos/flair-estimatorMass/build_core2_64/uav/estimatorMass_nrt")
endif()

if("${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  
                if (NOT EXISTS "/home/alexmiro/flair/flair-install/bin/demos/core2-64/estimatorMass/setup_x4.xml")
                    file(INSTALL "/home/alexmiro/flair/custom_demos/flair-estimatorMass/uav/resources/core2-64/setup_x4.xml" DESTINATION "/home/alexmiro/flair/flair-install/bin/demos/core2-64/estimatorMass" USE_SOURCE_PERMISSIONS)
                else()
                    message("-- Not installing " /home/alexmiro/flair "/flair-install/bin/demos/" core2-64 "/" estimatorMass "/" setup_x4.xml " (file already exists)")
                endif()
            
endif()

if("${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  
                if (NOT EXISTS "/home/alexmiro/flair/flair-install/bin/demos/core2-64/estimatorMass/setup_x4_intelaero.xml")
                    file(INSTALL "/home/alexmiro/flair/custom_demos/flair-estimatorMass/uav/resources/core2-64/setup_x4_intelaero.xml" DESTINATION "/home/alexmiro/flair/flair-install/bin/demos/core2-64/estimatorMass" USE_SOURCE_PERMISSIONS)
                else()
                    message("-- Not installing " /home/alexmiro/flair "/flair-install/bin/demos/" core2-64 "/" estimatorMass "/" setup_x4_intelaero.xml " (file already exists)")
                endif()
            
endif()

if("${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  
                if (NOT EXISTS "/home/alexmiro/flair/flair-install/bin/demos/core2-64/estimatorMass/setup_x8.xml")
                    file(INSTALL "/home/alexmiro/flair/custom_demos/flair-estimatorMass/uav/resources/core2-64/setup_x8.xml" DESTINATION "/home/alexmiro/flair/flair-install/bin/demos/core2-64/estimatorMass" USE_SOURCE_PERMISSIONS)
                else()
                    message("-- Not installing " /home/alexmiro/flair "/flair-install/bin/demos/" core2-64 "/" estimatorMass "/" setup_x8.xml " (file already exists)")
                endif()
            
endif()

if("${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  
                if (NOT EXISTS "/home/alexmiro/flair/flair-install/bin/demos/core2-64/estimatorMass/x4.sh")
                    file(INSTALL "/home/alexmiro/flair/custom_demos/flair-estimatorMass/uav/resources/core2-64/x4.sh" DESTINATION "/home/alexmiro/flair/flair-install/bin/demos/core2-64/estimatorMass" USE_SOURCE_PERMISSIONS)
                else()
                    message("-- Not installing " /home/alexmiro/flair "/flair-install/bin/demos/" core2-64 "/" estimatorMass "/" x4.sh " (file already exists)")
                endif()
            
endif()

if("${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  
                if (NOT EXISTS "/home/alexmiro/flair/flair-install/bin/demos/core2-64/estimatorMass/x4_intelaero.sh")
                    file(INSTALL "/home/alexmiro/flair/custom_demos/flair-estimatorMass/uav/resources/core2-64/x4_intelaero.sh" DESTINATION "/home/alexmiro/flair/flair-install/bin/demos/core2-64/estimatorMass" USE_SOURCE_PERMISSIONS)
                else()
                    message("-- Not installing " /home/alexmiro/flair "/flair-install/bin/demos/" core2-64 "/" estimatorMass "/" x4_intelaero.sh " (file already exists)")
                endif()
            
endif()

if("${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  
                if (NOT EXISTS "/home/alexmiro/flair/flair-install/bin/demos/core2-64/estimatorMass/x8.sh")
                    file(INSTALL "/home/alexmiro/flair/custom_demos/flair-estimatorMass/uav/resources/core2-64/x8.sh" DESTINATION "/home/alexmiro/flair/flair-install/bin/demos/core2-64/estimatorMass" USE_SOURCE_PERMISSIONS)
                else()
                    message("-- Not installing " /home/alexmiro/flair "/flair-install/bin/demos/" core2-64 "/" estimatorMass "/" x8.sh " (file already exists)")
                endif()
            
endif()

