from pwn import *
import hashlib
from Crypto.Cipher import AES
from Crypto.Util.Padding import pad, unpad

HOST = "pwn.ctf-hosted.usccyborg.com"
PORT = 8797

server = remote(HOST, PORT)
print(server.recvline())
p_data = server.recvline().split()
a_data = server.recvline().split()
b_data = server.recvline().split()
p = int(p_data[2])
print("p =",p,"\na = ???\nb = ???")
print(server.recvline())
G_data = server.recvline().split()
P_data = server.recvline().split()
Gx = int(G_data[1][1:-1])
Gy = int(G_data[2][:-1])
Px = int(P_data[1][1:-1])
Py = int(P_data[2][:-1])
print("P1 =",Gx,",",Gy)
print("P2 =",Px,",",Py)
print(server.recvline())
iv_recv = server.recvline().split(b": ")[1][:-2].decode()
enc_flag = server.recvline().split(b": ")[1][:-2].decode()
print("IV =",iv_recv,"\nEncrypted flag =",enc_flag)
server.close()

F = GF(p)
gx = F(Gx)
gy = F(Gy)
px = F(Px)
py = F(Py)
a = ((gy^2 - py^2)-(gx^3 - px^3))/(gx - px)
b = gy^2 - (gx^3 + a*gx)
D = 4*(a^3) + 27*(b^2)
P.<x> = F[]
f = x^3 + a*x + b
f_factors = f.factor()
r = F(f_factors[1][0] - x)
f_ = f.subs(x=x-r)
ff = f_.factor()
t = F(ff[0][0]-x).square_root()
u = ((gy + t*(gx+r))/(gy - t*(gx+r)))
v = ((py + t*(px+r))/(py - t*(px+r)))
n = discrete_log(v, u)
ans = str(n)
print(ans)

sha1 = hashlib.sha1()
sha1.update(str(ans).encode('ascii'))
key = sha1.digest()[:16]
ciphertext = bytes.fromhex(enc_flag)
iv = bytes.fromhex(iv_recv)
cipher = AES.new(key, AES.MODE_CBC, iv)
print(unpad(cipher.decrypt(ciphertext),16))