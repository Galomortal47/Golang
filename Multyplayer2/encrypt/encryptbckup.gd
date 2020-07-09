extends Node

var string = "surprise motherfucker"
var key = "wolfmother"

func _ready():
	var encrypt_input = string.to_ascii()
	var encrypt_key = key_generator(key)
	print("data: ",string," password: ",key)
	var result = encrypt(encrypt_input,key_generator(key))
	var result2 = decrypt(result ,key_generator(key))
#	print(encrypt_key)
	print(show(encrypt_input))
#	print(result)
#	print(show(result2))
#	print(result2.get_string_from_ascii())
	pass # Replace with function body.

func key_generator(key):
	var buffer = key.md5_buffer()
	var result = []
	for i in buffer:
		result.append(i)
	return result

func show(data):
	var output = []
	for i in data:
		output.append(i)
	return output

func encrypt(data, key):
	var output = []
	var x = 0
	for i in data:
		var interation = key[custom_fmod(x, key.size()-1)]
		output.append(custom_fmod(interation , i))
		x += 1
	return output

func decrypt(data, key):
	var output = PoolByteArray()
	var x = 0
	for i in data:
		var interation = key[custom_fmod(x, key.size())]
		output.append(reverse_fmod(interation , i))
		x += 1
	return output

func custom_fmod(input,key):
	var a = 0.0
	if input > key or input == 0:
		a = float(input) / float(key)
	else:
		a = float(key) / float(input)
	var b = float(a)
	b = floor(b)
	var c = float(a) - float(b)
	var d = 0.0
	if input > key or input == 0:
		d = float(c) * float(key)
	else:
		d = float(c) * float(input)
	var output = float(d)
#	print(input," ",key," ",a," ",b," ",c," ",d)
	return output

func reverse_fmod(input,key):
	var output = input+key
	print(output, " ", input, " ", key)
	return output
