function(cpk_add target package_to_find exact_version components link_libraries_to_target)
    find_package(${package_to_find} ${exact_version} EXACT REQUIRED COMPONENTS system filesystem)

    if (${package_to_find}_FOUND)
        message("${package_to_find} found")
    else (${package_to_find}_FOUND)
        message("${package_to_find} not found")
    endif()

    target_link_libraries(${target} ${Boost_LIBRARIES})
endfunction()