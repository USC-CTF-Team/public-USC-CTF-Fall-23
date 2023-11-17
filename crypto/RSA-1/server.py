from Crypto.Util.number import getPrime, bytes_to_long

with open("flag.txt",'r') as f:
	flag = f.read()

def main():
	N = getPrime(512)*getPrime(512)
	c = pow(bytes_to_long(bytes(flag,'utf-8')),3,N)
	print('N =',N)
	print('e = 3')
	print('c =',c)

if __name__ == "__main__":
	main()