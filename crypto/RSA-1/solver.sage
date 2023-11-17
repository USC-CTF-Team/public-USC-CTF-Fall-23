from pwn import *

SERVER = "pwn.ctf-hosted.usccyborg.com"
PORT = 8849

p = remote(SERVER, PORT)
p.recvline()
p.recvline()
c = int(p.recvline().split()[-1])
print(int(c ** (1/3)).to_bytes(20,"big"))