from Crypto.Util.number import getPrime, bytes_to_long
import random, json

with open("flag.txt",'r') as f:
	flag = f.read()

def main():
	m_bytes = bytes(flag,'utf-8')
	m = bytes_to_long(m_bytes)
	while True:
		N = getPrime(512)*getPrime(512)
		e = 7
		print("N =",N)
		print("e =",e)
		print("c =",pow(m,e,N))
		print('\nWould you like another? (y/n)')
		answer = input("")
		if answer != 'y' and answer != 'Y':
			break

if __name__ == "__main__":
	main()