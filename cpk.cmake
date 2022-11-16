function(cpk_add target package_to_find exact_version link_libraries_to_target)
    find_package(${package_to_find} ${exact_version} EXACT REQUIRED)

    if (${package_to_find}_FOUND)
        message("${package_to_find} found")
    else (${package_to_find}_FOUND)
        message("${package_to_find} not found")
    endif()

    target_link_libraries(${target} ${link_libraries_to_target})
endfunction()