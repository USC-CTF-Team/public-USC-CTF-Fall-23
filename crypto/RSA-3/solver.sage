from pwn import *

SERVER = "pwn.ctf-hosted.usccyborg.com"
PORT = 8360

p = remote(SERVER, PORT)
N_data = p.recvline().split(b" = ")
e_data = p.recvline().split(b" = ")
c_data = p.recvline().split(b" = ")
N = int(N_data[1][:-2])
e = int(e_data[1][:-2])
c = int(c_data[1][:-2])
print("N =",N,"\ne =",e,"\nc =",c)
a = floor(sqrt(N))
while True:
	b = (a**2) - N
	if b >= 0:
		sr = int(sqrt(b))
		if sr*sr == b:
			break
	a += 1
p = a-sr
q = N/p
phi = (p-1)*(q-1)
d = int(pow(e,-1,phi))
m = int(pow(c,d,N)).to_bytes(40,"big")
print(m)