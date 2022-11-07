cmake_minimum_required(VERSION 3.14)

project(cpk-cmake)

set (cpk_libraries mbedtls openssl)
set(mbedtls_download_link "https://github.com/dirkarnez/mbedtls-prebuilt/releases/download/v3.2.1/mbedtls-v3.2.1-x86_64-posix-seh-rev0-8.1.0.zip")
set(openssl_download_link "https://github.com/dirkarnez/openssl-prebuilt/releases/download/v3.0.5/openssl-v3.0.5-x86_64-posix-seh-rev0-8.1.0.zip")
set(stl_reader_download_link "https://github.com/dirkarnez/stl_reader-prebuilt/releases/download/v1.0.0/stl_reader-v1.0.0-x86_64-posix-seh-rev0-8.1.0.zip")

list (LENGTH cpk_libraries length)
# message (">>> LENGTH: ${length}")

# message(${CPK_ACTION})
# message(${CPK_ACTION_TARGET})


file(READ "json_example.json" EXAMPLE_JSON)

string(JSON EXAMPLE_JSON_FIRST_ITEM GET ${EXAMPLE_JSON} 1)
message(${EXAMPLE_JSON_FIRST_ITEM})

string(JSON EXAMPLE_JSON_UPDATED SET ${EXAMPLE_JSON} 1 "\"c\"")
message(${EXAMPLE_JSON_UPDATED})
file(WRITE "json_example.json" ${EXAMPLE_JSON_UPDATED})

if(${CPK_ACTION} STREQUAL "install")
    if(NOT DEFINED ${CPK_ACTION_TARGET}_download_link)
        message(FATAL_ERROR "No such library ${CPK_ACTION_TARGET}")
    elseif()
        get_filename_component(filename ${${CPK_ACTION_TARGET}_download_link} NAME_WLE)
        set(${CPK_ACTION_TARGET}_full_path "${PROJECT_SOURCE_DIR}/downloads/${filename}.zip")
        file(DOWNLOAD ${${CPK_ACTION_TARGET}_download_link} ${${CPK_ACTION_TARGET}_full_path})
        file(ARCHIVE_EXTRACT INPUT ${${CPK_ACTION_TARGET}_full_path} DESTINATION "${PROJECT_SOURCE_DIR}/external/${filename}")
        file(REMOVE_RECURSE "${PROJECT_SOURCE_DIR}/downloads")
        message(STATUS "${CPK_ACTION_TARGET} is installed")
    endif()
#elseif(${CPK_ACTION})
else()
    message(STATUS "Nothing to do")
endif()
