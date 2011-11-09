FUNCTION fire_string, input, FORMAT=format

	RETURN, strtrim(string(input, format=format),2)

END
