from Crypto.Util.number import bytes_to_long
import random, json

with open("flag.txt",'r') as f:
	flag = f.read()

def main():
	with open('close_primes.json','r') as f:
		RSA = json.loads(f.read())
	m_bytes = bytes(flag,'utf-8')
	m = bytes_to_long(m_bytes)
	index = random.randint(0,len(RSA)-1)
	N = RSA[index]['N']
	e = RSA[index]['e']
	print("N =",N)
	print("e =",e)
	print("c =",pow(m,e,N))

if __name__ == "__main__":
	main()