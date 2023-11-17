from Crypto.Util.number import getPrime, bytes_to_long
import random, json

with open("flag.txt",'r') as f:
	flag = f.read()

def main():
	m_bytes = bytes(flag,'utf-8')
	m = bytes_to_long(m_bytes)
	p = getPrime(512)
	q = getPrime(512)
	N = p*q
	e = 127
	d = pow(e,-1,(p-1)*(q-1))
	print("N =",N)
	print("e =",e)
	print("d0 =",int(bin(d)[-512:],2))
	print("c =",pow(m,e,N))
	print("d0bits = 512")
	print("nBits = 1024")
	
if __name__ == "__main__":
	main()