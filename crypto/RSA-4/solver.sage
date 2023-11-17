from pwn import *

SERVER = "pwn.ctf-hosted.usccyborg.com"
PORT = 8143

p = remote(SERVER, PORT)
n_array = []
c_array = []
while True:
	N_data = p.recvline().split(b" = ")
	e_data = p.recvline().split(b" = ")
	c_data = p.recvline().split(b" = ")
	n = int(N_data[1][:-2])
	e = int(e_data[1][:-2])
	c = int(c_data[1][:-2])
	print("N =",n,"\ne =",e,"\nc =",c)
	n_array.append(n)
	c_array.append(c)
	p.recvline()
	p.recvline()
	if len(n_array) == e:
		p.sendline(b'n')
		break
	else:
		p.sendline(b'y')

N = 1
for x in n_array:
	N = N*x
N_array = []
u_array = []
for i in range(len(n_array)):
	N_array.append(N/n_array[i])
	u_array.append(pow(N_array[i],-1)%n_array[i])
M = 0
for i in range(len(n_array)):
	M += c_array[i]*u_array[i]*N_array[i]
m = int((M%N) ** (1/e)).to_bytes(53,"big")
print(m)