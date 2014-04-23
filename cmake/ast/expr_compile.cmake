function(expr_compile str)
  map_new()
  ans(expression_cache)
  ref_set(__expression_cache ${expression_cache})
  function(expr_compile str)
    set(ast)
    ref_get(__expression_cache )
    ans(expression_cache)
    map_tryget(${expression_cache}  "${str}")
    ans(symbol)
    if(NOT symbol)
      # get ast
      language("oocmake")
      ans(language)
      if(NOT language)
        language("${cutil_package_dir}/core/resources/expr.json")
        ans(language)
      endif()
      #message("compiling ast for \"${str}\"")
      ast("${str}" oocmake "")
      ans(ast)
      #message("ast created")
      # compile to cmake
      map_new()
      ans(context)
      map_new()
      ans(scope)
      map_set(${context} scope ${scope})    
      ast_eval(${ast} ${context} ${language})
      ans(symbol)
      map_tryget(${context}  code)
      ans(code)
      if(code)
       # message("${code}")
        eval("${code}")
      endif()
      map_set(${expression_cache} "${str}" ${symbol})
    endif()
    #eval("${symbol}")
    #return_ans()
    return_ref(symbol)
  endfunction()
  expr_compile("${str}")
  return_ans()
endfunction()