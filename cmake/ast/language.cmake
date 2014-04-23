

function(language name)
  map_isvalid(${name} )
  ans(ismp)
  if(ismp)
    map_tryget(${name}  initialized)
    ans(initialized)
    if(NOT initialized)
      language_initialize(${name})
    endif()
    return_ref(language)
  endif()

  ref_get(language_map )
  ans(language_map)
  if(NOT language_map)
    map_new()
    ans(language_map)
    ref_set(language_map "${language_map}")
  endif()

  map_tryget(${language_map}  "${name}")
  ans(language)
  #message("language ${language}")
  #map_print(${language_map})
  if(NOT language)
    language_load(${name})
    ans(language)

    if(NOT language)
      return()
    endif()
    map_set(${language_map} "${name}" ${language})
    map_get(${language}  name)
    ans(name)
    map_set(${language_map} "${name}" ${language})
    eval("function(eval_${name} str)
    language(\"${name}\")
    ans(lang)
    ast(\"\${str}\" \"${name}\" \"\")
    ans(ast)
    map_new()
    ans(context)
      #message(\"evaling '\${ast}' with lang '\${lang}' context is \${context} \")
    ast_eval(\${ast} \${context} \${lang})
    ans(res)
    return_ref(res)
    endfunction()")
  endif()
  return_ref(language)
endfunction()