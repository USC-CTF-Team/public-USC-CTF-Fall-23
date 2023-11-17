from pwn import *
import owiener

SERVER = "pwn.ctf-hosted.usccyborg.com"
PORT = 8155

p = remote(SERVER, PORT)
N_data = p.recvline().split(b" = ")
e_data = p.recvline().split(b" = ")
c_data = p.recvline().split(b" = ")
N = int(N_data[1][:-2])
e = int(e_data[1][:-2])
c = int(c_data[1][:-2])
print("N =",N,"\ne =",e,"\nc =",c)
d = owiener.attack(e, N)
m = int(pow(c,d,N)).to_bytes(36,"big")
print(m)