package json

Specification :: enum {
	JSON,
	JSON5, // https://json5.org/
	MJSON, // https://bitsquid.blogspot.com/2009/10/simplified-json-notation.html
}

DEFAULT_SPECIFICATION :: Specification.JSON5

Null    :: distinct rawptr
Integer :: i64
Float   :: f64
Boolean :: bool
String  :: string
Array   :: distinct [dynamic]Value
Object  :: distinct map[string]Value

Value :: union {
	Null,
	Integer,
	Float,
	Boolean,
	String,
	Array,
	Object,
}

Error :: enum {
	None,

	EOF, // Not necessarily an error

	// Tokenizing Errors
	Illegal_Character,
	Invalid_Number,
	String_Not_Terminated,
	Invalid_String,


	// Parsing Errors
	Unexpected_Token,
	Expected_String_For_Object_Key,
	Duplicate_Object_Key,
	Expected_Colon_After_Key,
	
	// Allocating Errors
	Invalid_Allocator,
	Out_Of_Memory,
}




destroy_value :: proc(value: Value) {
	#partial switch v in value {
	case Object:
		for key, elem in v {
			delete(key)
			destroy_value(elem)
		}
		delete(v)
	case Array:
		for elem in v {
			destroy_value(elem)
		}
		delete(v)
	case String:
		delete(v)
	}
}

