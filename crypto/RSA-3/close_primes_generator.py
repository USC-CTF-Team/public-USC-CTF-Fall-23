from Crypto.Util.number import getPrime, bytes_to_long
from sympy import nextprime
import json

RSA = []
for i in range(50):
	print("Round",i)
	p = getPrime(512)
	q = nextprime(p)
	e = 65537
	N = p*q
	phi = (p-1)*(q-1)
	d = pow(e,-1,phi)
	RSA.append({'p': p, 'q': q, 'N': N, 'd': d, 'e': e})

with open('close_primes.json','w') as f:
	json.dump(RSA,f,indent=4)