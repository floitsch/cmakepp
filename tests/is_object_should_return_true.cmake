
	function(is_object_should_return_true)
		obj_create(obj)
		is_object(res ${obj} )
		assert(res)
	endfunction()