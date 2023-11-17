from pwn import *

HOST = "pwn.ctf-hosted.usccyborg.com"
PORT = 8202

server = remote(HOST, PORT)
N_data = server.recvline().split(b" = ")
e_data = server.recvline().split(b" = ")
d0_data = server.recvline().split(b" = ")
c_data = server.recvline().split(b" = ")
d0Bits_data = server.recvline().split(b" = ")
nBits_data = server.recvline().split(b" = ")
N = int(N_data[1][:-2])
e = int(e_data[1][:-2])
c = int(c_data[1][:-2])
nBits = int(nBits_data[1][:-2])
d0bits = int(d0Bits_data[1][:-2])
d0 = int(d0_data[1][:-2])
print("N =",N,"\ne =",e,"\nc =",c,"\nd0 =",d0,"\nd0Bits =",d0bits,"\nnBits =",nBits)
server.close()

X = var('X')
found = False
for k in range(1,e+1):
	if found:
		break
	print("Attempt",k)
	results = solve_mod([e*d0 - k*(N-X+1) == 1], 2^d0bits)
	for x in results:
		s = ZZ(x[0])
		P = var('P')
		p0_results = solve_mod([P^2 - s*P + N == 0], 2^d0bits)
		for y in p0_results:
			p0 = int(y[0])
			PR.<z> = PolynomialRing(Zmod(N))
			f = 2^d0bits*z + p0
			f = f.monic()
			roots = f.small_roots(X=2^(nBits//2 - d0bits + 1), beta=0.1)
			if roots:
				x0 = roots[0]
				p = gcd(2^d0bits*x0 + p0, N)
				q = N//ZZ(p)
				d = int(pow(e,-1,(p-1)*(q-1)))
				m = int(pow(c,d,N)).to_bytes(54,"big")
				found = True
print(m)