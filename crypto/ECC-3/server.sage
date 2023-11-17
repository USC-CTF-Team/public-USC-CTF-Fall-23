from random import randint
import json
import hashlib
from Crypto.Cipher import AES
from Crypto.Util.Padding import pad, unpad

with open("flag.txt",'r') as f:
	flag = f.read()

def encrypt_flag(secret):
    sha1 = hashlib.sha1()
    sha1.update(str(secret).encode('ascii'))
    key = sha1.digest()[:16]
    iv = os.urandom(16)
    cipher = AES.new(key, AES.MODE_CBC, iv)
    ciphertext = cipher.encrypt(pad(flag.encode('ascii'), 16))
    data = {}
    data['iv'] = iv.hex()
    data['encrypted_flag'] = ciphertext.hex()
    return data

def main():
	with open("curves.json",'r') as f:
		curves = json.loads(f.read())
	index = randint(0,len(curves)-1)
	p = curves[index]['p']
	secret = curves[index]['n']
	G = (curves[index]['gx'],curves[index]['gy'])
	P = (curves[index]['px'],curves[index]['py'])
	print("The curve parameters are:")
	print("p = "+str(p))
	print("a = ???")
	print("b = ???")
	print('\nP1: '+str(G))
	print('P2: '+str(P))
	data = encrypt_flag(secret)
	print('\nIV:', data['iv'])
	print('Encrypted flag:', data['encrypted_flag'])

if __name__ == "__main__":
	main()