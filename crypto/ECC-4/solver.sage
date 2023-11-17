from pwn import *
import hashlib
from Crypto.Cipher import AES
from Crypto.Util.Padding import pad, unpad

HOST = "pwn.ctf-hosted.usccyborg.com"
PORT = 8527

server = remote(HOST, PORT)
print(server.recvline())
p_data = server.recvline().split()
a_data = server.recvline().split()
b_data = server.recvline().split()
p = int(p_data[2])
a = int(a_data[2])
b = int(b_data[2])
print("p =",p,"\na =",a,"\nb =",b)
print(server.recvline())
P_data = server.recvline().split(b": ")
Q_data = server.recvline().split(b": ")
px = int(P_data[1][1:])
py = int(P_data[2])
qx = int(Q_data[1][1:])
qy = int(Q_data[2])
print("P1 =",px,",",py)
print("P2 =",qx,",",qy)
print(server.recvline())
iv_recv = server.recvline().split(b": ")[1][:-2].decode()
enc_flag = server.recvline().split(b": ")[1][:-2].decode()
print("IV =",iv_recv,"\nEncrypted flag =",enc_flag)
server.close()

E = EllipticCurve(GF(p), [a, b])
order = E.order()
P = E(px,py)
Q = E(qx,qy)
n = P.order()
k = 1
while (p**k - 1) % order:
	k += 1
K.<a> = GF(p**k)
EK = E.base_extend(K)
PK = EK(Q)
GK = EK(P)
while True:
	R = EK.random_point()
	m = R.order()
	d = gcd(m,n)
	S = (m//d)*R
	if n / S.order() not in ZZ:
		continue
	if n == S.order():
		break
alpha = GK.weil_pairing(S,n)
beta = PK.weil_pairing(S,n)
dd = beta.log(alpha)
ans = str(dd)
print(ans)

sha1 = hashlib.sha1()
sha1.update(str(ans).encode('ascii'))
key = sha1.digest()[:16]
ciphertext = bytes.fromhex(enc_flag)
iv = bytes.fromhex(iv_recv)
cipher = AES.new(key, AES.MODE_CBC, iv)
print(unpad(cipher.decrypt(ciphertext),16))