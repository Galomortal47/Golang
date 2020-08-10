extends Node

var string = "you are my bitch, surprise motherfucker test/subject/cube 0.4589715 ýÄ"
var key = "123wolfmother@212"

func _ready():
	var encrypt_input = string.to_utf8()
	var encrypt_key = key_generator(key)
	print("data: ",string," password: ",key)
	var result = encrypt(encrypt_input,key_generator(key))
	var result2 = decrypt(result ,key_generator(key))
	print("encrypt_key: " + str(encrypt_key))
	print("encrypt_input: " + str(show(encrypt_input)))
	print("encrypt: " + str(show(result)))
	print("decrypt: " + str(show(result2)))
	print(result2.get_string_from_utf8())
	pass # Replace with function body.

func key_generator(key):
	var buffer = key.sha256_buffer()
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
	var output = PoolByteArray()
	var x = data.size()
	for i in data:
		var interation = key[fmod(x, key.size()-1)]
		x += interation
		output.append(interation + i)
	return output

func decrypt(data, key):
	var output = PoolByteArray()
	var x = data.size()
	for i in data:
		var interation = key[fmod(x, key.size()-1)]
		x += interation
		output.append(i-interation)
	return output
