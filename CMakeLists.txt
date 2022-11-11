cmake_minimum_required(VERSION 3.14)

project(cpk-cmake)

set(cpk_libraries mbedtls openssl)
set(mbedtls_download_link "https://github.com/dirkarnez/mbedtls-prebuilt/releases/download/v3.2.1/mbedtls-v3.2.1-x86_64-posix-seh-rev0-8.1.0.zip")
set(openssl_download_link "https://github.com/dirkarnez/openssl-prebuilt/releases/download/v3.0.5/openssl-v3.0.5-x86_64-posix-seh-rev0-8.1.0.zip")
set(stl_reader_download_link "https://github.com/dirkarnez/stl_reader-prebuilt/releases/download/v1.0.0/stl_reader-v1.0.0-x86_64-posix-seh-rev0-8.1.0.zip")
set(boost_download_link "https://github.com/dirkarnez/boost-prebuilt/releases/download/v1.80.0/boost-v1.80.0-x86_64-posix-seh-rev0-8.1.0.zip")

list (LENGTH cpk_libraries length)
# message (">>> LENGTH: ${length}")

# message(${CPK_ACTION})
# message(${CPK_ACTION_TARGET})

# file(READ "json_example.json" EXAMPLE_JSON)

# string(JSON EXAMPLE_JSON_FIRST_ITEM GET ${EXAMPLE_JSON} 1)
# message(${EXAMPLE_JSON_FIRST_ITEM})

# string(JSON EXAMPLE_JSON_UPDATED SET ${EXAMPLE_JSON} 1 "\"c\"")
# message(${EXAMPLE_JSON_UPDATED})
# file(WRITE "json_example.json" ${EXAMPLE_JSON_UPDATED})

if(${CPK_ACTION} STREQUAL "install")
	message(STATUS "found ${CPK_ACTION_TARGET}")
	get_filename_component(filename ${${CPK_ACTION_TARGET}_download_link} NAME_WLE)
	set(${CPK_ACTION_TARGET}_full_path "${PROJECT_SOURCE_DIR}/downloads/${filename}.zip")
	file(DOWNLOAD ${${CPK_ACTION_TARGET}_download_link} ${${CPK_ACTION_TARGET}_full_path})
	file(ARCHIVE_EXTRACT INPUT ${${CPK_ACTION_TARGET}_full_path} DESTINATION "${PROJECT_SOURCE_DIR}/external/${filename}")
	file(REMOVE_RECURSE "${PROJECT_SOURCE_DIR}/downloads")
	message(STATUS "${CPK_ACTION_TARGET} is installed")
elseif(${CPK_ACTION} STREQUAL "build")
	set(CPK_ACTION_TARGET "")
	message(STATUS "Building ${CPK_PROJECT}")
	# generate cmake build
	set(BOOST_ROOT "${PROJECT_SOURCE_DIR}/external/boost-v1.80.0-x86_64-posix-seh-rev0-8.1.0/lib/cmake/Boost-1.80.0")
	
	execute_process(COMMAND cmake 
		"-GMinGW Makefiles" 
		"-Bcmake-build" 
		"-DCMAKE_BUILD_TYPE=Debug" 
		"-DBOOST_ROOT=${BOOST_ROOT}"
		WORKING_DIRECTORY ${CPK_PROJECT})

	execute_process(COMMAND cmake 
		"--build" 
		"." 
		WORKING_DIRECTORY ${CPK_PROJECT}/cmake-build)
elseif(${CPK_ACTION} STREQUAL "init")
	# app + lib

	execute_process(COMMAND "C:/Windows/System32/where" "gcc" OUTPUT_VARIABLE GCC_LOCATION)
	string(REGEX REPLACE "\n$" "" GCC_LOCATION "${GCC_LOCATION}")
	file(TO_CMAKE_PATH ${GCC_LOCATION} GCC_LOCATION_NATIVE)
	message(STATUS "gcc found at ${GCC_LOCATION_NATIVE}")
	

	file(WRITE ${CPK_PROJECT}/.vscodeyoyoy/c_cpp_properties.json
"{
    \"configurations\": [
        {
            \"name\": \"Win32\",
            \"includePath\": [
                \"${workspaceFolder}/**\"
            ],
            \"defines\": [
                \"_DEBUG\",
                \"UNICODE\",
                \"_UNICODE\"
            ],
            \"windowsSdkVersion\": \"10.0.18362.0\",
            \"compilerPath\": \"${GCC_LOCATION_NATIVE}\",
            \"cStandard\": \"c11\",
            \"cppStandard\": \"c++17\",
            \"intelliSenseMode\": \"${default}\"
        }
    ],
    \"version\": 4
}
"
)
	file(WRITE ${CPK_PROJECT}/.gitignore
"/build
/cmake-build
.vscode/settings.json
"
	)

	file(WRITE ${CPK_PROJECT}/yoyoy/main.cpp 
"#include <iostream>

int main() {
	std::cout << \"Hello World!\";
	return 0;
}")
else()
    message(STATUS "Nothing to do")
endif()