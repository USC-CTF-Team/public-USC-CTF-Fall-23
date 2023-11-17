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
	a = curves[index]['a']
	b = curves[index]['b']
	E = EllipticCurve(GF(p), [a, b])
	print("The curve parameters are:")
	print("p = "+str(p))
	print("a = "+str(a))
	print("b = "+str(b))
	P1 = E.gens()[0]
	print('\nP1: '+str(P1))
	secret = randint(1, 10**9)
	P2 = secret * P1
	print('P2: '+str(P2))
	data = encrypt_flag(secret)
	print('\nIV:', data['iv'])
	print('Encrypted flag:', data['encrypted_flag'])

if __name__ == "__main__":
	main()