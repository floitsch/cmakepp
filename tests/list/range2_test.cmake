function(test)



  function(range2_parse range)
    string_codes()
    string(REPLACE "[" "${bracket_open_code}" range "${range}")
    string(REPLACE "(" "${bracket_close_code}" range "${range}")
    string(REPLACE "]" "${bracket_close_code}" range "${range}")
    string(REPLACE ")" "${bracket_open_code}" range "${range}")

    set(regex_range ":|${bracket_open_code}|${bracket_close_code}|\\-|\\$|n|[0-9]+")
    string(REGEX REPLACE "${regex_range}" "" error "${range}")
    if(error)
      throw("failed to parse range, could not interpret: '${error}'")
    endif( )
    string(REGEX MATCHALL "${regex_range}" tokens "${range}")



    set(phase begin)
    map_new()
    ans(range)
    map_set_special("${range}" "$type" range)

    set(current_negativity false)
    set(current_number 0)
    set(current_inclusivity true)
    set(done false)
    list(APPEND tokens : :)

    while(true)
      if(done)
        break()
      endif()
      list(LENGTH tokens token_count)
      if(NOT token_count)
        break()
      endif()
      list(GET tokens 0 token)
      list(REMOVE_AT tokens 0)

      
      if("${token}" STREQUAL ":")
        if("${phase}" STREQUAL "begin")
          ## end of begin phase
          if(current_negativity)
            map_set("${range}" "begin" "(n-1-${current_number})")
          else()
            map_set("${range}" "begin" "${current_number}")
          endif()

          map_set("${range}" begin_inclusivity ${current_inclusivity})

          set(phase end)
          set(current_negativity false)
          set(current_number "(n-1)")
          set(current_inclusivity false) 
        elseif("${phase}" STREQUAL "end")
          if(current_negativity)
            map_set("${range}" "end" "(n-1-${current_number})")
          else()
            map_set("${range}" "end" "${current_number}")
          endif()
          map_set("${range}" end_inclusivity ${current_inclusivity})


          set(phase increment)
          set(current_negativity false)
          set(current_number "1")        
        else()
          set(done true)
          if(current_negativity)
            map_set("${range}" increment "(0-${current_number})")
            map_set("${range}" reverse true)
          else()
            map_set("${range}" increment "${current_number}")
            map_set("${range}" reverse false)
          endif()
        endif()
      elseif("${token}" MATCHES "[0-9]+")
        set(current_number ${token})
      elseif("${token}" STREQUAL "-")
        if(NOT "${current_number}_" STREQUAL "_")
          throw("invalid negativity: minus may only appear before the number")
        endif()
        set(current_negativity true)
      elseif("${token}" STREQUAL "${bracket_open_code}")
        if("${phase}" STREQUAL "begin")
          set("current_inclusivity" true)
        elseif("${phase}" STREQUAL "end")
          set("current_inclusivity" false)
        else()
          throw("invalid inclusivity: inclusivity may only be set for begin/end")
        endif()
      elseif("${token}" STREQUAL "${bracket_close_code}")
        if("${phase}" STREQUAL "begin")
          set("current_inclusivity" false)
        elseif("${phase}" STREQUAL "end")
          set("current_inclusivity" true)
        else()
          throw("invalid inclusivity: inclusivity may only be set for begin/end")
        endif()
      elseif("${token}" STREQUAL "$")
        set("${phase}" "(n-1)")
      elseif("${token}" STREQUAL "n")
        set("${phase}" "n")
      endif()
    endwhile()

    string(REGEX REPLACE "[:;]" "" error "${tokens}")
    if(error)
      throw("invalid tokens '${error}' " --function range2_parse)
    endif()

    return_ref(range)
  endfunction()

  define_test_function2(test_uut range2_parse --timer)

  set(use_timer true)




  function(range2 range)
    map_get_special("${range}" $type)
    ans(type)
    if("${type}" STREQUAL "range")
      return("${range}")
    else()
      range2_parse("${range}")
      return_ans()
    endif()
  endfunction()



  function(range2_indices n range)
    if("${n}" EQUAL 0)
      return()
    endif()
    if("${n}" LESS 0 )
      set(n 0 )
    endif()
    range2("${range}")
    ans(range)

    
    map_import_properties(${range} begin end increment begin_inclusivity end_inclusivity)

    print_vars(begin end)
    string(REPLACE "n" "${n}" begin "${begin}")
    math(EXPR begin "${begin}")
    
    string(REPLACE "n" "${n}" end "${end}")
    math(EXPR end "${end}")


    print_vars(begin end)

    return()


  endfunction()

  range2_indices(2 "$")


endfunction()