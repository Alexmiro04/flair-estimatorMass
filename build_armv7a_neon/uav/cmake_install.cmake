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
  if(EXISTS "$ENV{DESTDIR}/home/alexmiro/flair/flair-install/bin/demos/armv7a-neon/estimatorMass/estimatorMass_rt" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/home/alexmiro/flair/flair-install/bin/demos/armv7a-neon/estimatorMass/estimatorMass_rt")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}/home/alexmiro/flair/flair-install/bin/demos/armv7a-neon/estimatorMass/estimatorMass_rt"
         RPATH "")
  endif()
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/alexmiro/flair/flair-install/bin/demos/armv7a-neon/estimatorMass/estimatorMass_rt")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/alexmiro/flair/flair-install/bin/demos/armv7a-neon/estimatorMass" TYPE EXECUTABLE FILES "/home/alexmiro/flair/custom_demos/flair-estimatorMass/build_armv7a_neon/uav/estimatorMass_rt")
endif()

if("${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  if(EXISTS "$ENV{DESTDIR}/home/alexmiro/flair/flair-install/bin/demos/armv7a-neon/estimatorMass/estimatorMass_nrt" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/home/alexmiro/flair/flair-install/bin/demos/armv7a-neon/estimatorMass/estimatorMass_nrt")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}/home/alexmiro/flair/flair-install/bin/demos/armv7a-neon/estimatorMass/estimatorMass_nrt"
         RPATH "")
  endif()
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/alexmiro/flair/flair-install/bin/demos/armv7a-neon/estimatorMass/estimatorMass_nrt")
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
file(INSTALL DESTINATION "/home/alexmiro/flair/flair-install/bin/demos/armv7a-neon/estimatorMass" TYPE EXECUTABLE FILES "/home/alexmiro/flair/custom_demos/flair-estimatorMass/build_armv7a_neon/uav/estimatorMass_nrt")
endif()

if("${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  
                if (NOT EXISTS "/home/alexmiro/flair/flair-install/bin/demos/armv7a-neon/estimatorMass/CircleFollower_ardrone2.sh")
                    file(INSTALL "/home/alexmiro/flair/custom_demos/flair-estimatorMass/uav/resources/armv7a-neon/CircleFollower_ardrone2.sh" DESTINATION "/home/alexmiro/flair/flair-install/bin/demos/armv7a-neon/estimatorMass" USE_SOURCE_PERMISSIONS)
                else()
                    message("-- Not installing " /home/alexmiro/flair "/flair-install/bin/demos/" armv7a-neon "/" estimatorMass "/" CircleFollower_ardrone2.sh " (file already exists)")
                endif()
            
endif()

if("${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  
                if (NOT EXISTS "/home/alexmiro/flair/flair-install/bin/demos/armv7a-neon/estimatorMass/CircleFollower_ardrone2.xml")
                    file(INSTALL "/home/alexmiro/flair/custom_demos/flair-estimatorMass/uav/resources/armv7a-neon/CircleFollower_ardrone2.xml" DESTINATION "/home/alexmiro/flair/flair-install/bin/demos/armv7a-neon/estimatorMass" USE_SOURCE_PERMISSIONS)
                else()
                    message("-- Not installing " /home/alexmiro/flair "/flair-install/bin/demos/" armv7a-neon "/" estimatorMass "/" CircleFollower_ardrone2.xml " (file already exists)")
                endif()
            
endif()

if("${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  
                if (NOT EXISTS "/home/alexmiro/flair/flair-install/bin/demos/armv7a-neon/estimatorMass/CircleFollower_bebop.sh")
                    file(INSTALL "/home/alexmiro/flair/custom_demos/flair-estimatorMass/uav/resources/armv7a-neon/CircleFollower_bebop.sh" DESTINATION "/home/alexmiro/flair/flair-install/bin/demos/armv7a-neon/estimatorMass" USE_SOURCE_PERMISSIONS)
                else()
                    message("-- Not installing " /home/alexmiro/flair "/flair-install/bin/demos/" armv7a-neon "/" estimatorMass "/" CircleFollower_bebop.sh " (file already exists)")
                endif()
            
endif()

if("${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  
                if (NOT EXISTS "/home/alexmiro/flair/flair-install/bin/demos/armv7a-neon/estimatorMass/CircleFollower_bebop.xml")
                    file(INSTALL "/home/alexmiro/flair/custom_demos/flair-estimatorMass/uav/resources/armv7a-neon/CircleFollower_bebop.xml" DESTINATION "/home/alexmiro/flair/flair-install/bin/demos/armv7a-neon/estimatorMass" USE_SOURCE_PERMISSIONS)
                else()
                    message("-- Not installing " /home/alexmiro/flair "/flair-install/bin/demos/" armv7a-neon "/" estimatorMass "/" CircleFollower_bebop.xml " (file already exists)")
                endif()
            
endif()

if("${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  
                if (NOT EXISTS "/home/alexmiro/flair/flair-install/bin/demos/armv7a-neon/estimatorMass/CircleFollower_hdsx8.sh")
                    file(INSTALL "/home/alexmiro/flair/custom_demos/flair-estimatorMass/uav/resources/armv7a-neon/CircleFollower_hdsx8.sh" DESTINATION "/home/alexmiro/flair/flair-install/bin/demos/armv7a-neon/estimatorMass" USE_SOURCE_PERMISSIONS)
                else()
                    message("-- Not installing " /home/alexmiro/flair "/flair-install/bin/demos/" armv7a-neon "/" estimatorMass "/" CircleFollower_hdsx8.sh " (file already exists)")
                endif()
            
endif()

if("${CMAKE_INSTALL_COMPONENT}" STREQUAL "Unspecified" OR NOT CMAKE_INSTALL_COMPONENT)
  
                if (NOT EXISTS "/home/alexmiro/flair/flair-install/bin/demos/armv7a-neon/estimatorMass/CircleFollower_hdsx8.xml")
                    file(INSTALL "/home/alexmiro/flair/custom_demos/flair-estimatorMass/uav/resources/armv7a-neon/CircleFollower_hdsx8.xml" DESTINATION "/home/alexmiro/flair/flair-install/bin/demos/armv7a-neon/estimatorMass" USE_SOURCE_PERMISSIONS)
                else()
                    message("-- Not installing " /home/alexmiro/flair "/flair-install/bin/demos/" armv7a-neon "/" estimatorMass "/" CircleFollower_hdsx8.xml " (file already exists)")
                endif()
            
endif()

