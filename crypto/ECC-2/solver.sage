from pwn import *
import hashlib
from Crypto.Cipher import AES
from Crypto.Util.Padding import pad, unpad

HOST = "pwn.ctf-hosted.usccyborg.com"
PORT = 8078

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
assert(E.order() == p)
P = E(px,py)
Q = E(qx,qy)
Eqp = EllipticCurve(Qp(p, 2), [ ZZ(t) + randint(0,p)*p for t in E.a_invariants() ])
P_Qps = Eqp.lift_x(ZZ(P.xy()[0]), all=True)
for P_Qp in P_Qps:
	if GF(p)(P_Qp.xy()[1]) == P.xy()[1]:
		break
Q_Qps = Eqp.lift_x(ZZ(Q.xy()[0]), all=True)
for Q_Qp in Q_Qps:
	if GF(p)(Q_Qp.xy()[1]) == Q.xy()[1]:
		break
p_times_P = p*P_Qp
p_times_Q = p*Q_Qp
x_P,y_P = p_times_P.xy()
x_Q,y_Q = p_times_Q.xy()
phi_P = -(x_P/y_P)
phi_Q = -(x_Q/y_Q)
k = phi_Q/phi_P
ans = str(ZZ(k))
print(ans)

sha1 = hashlib.sha1()
sha1.update(str(ans).encode('ascii'))
key = sha1.digest()[:16]
ciphertext = bytes.fromhex(enc_flag)
iv = bytes.fromhex(iv_recv)
cipher = AES.new(key, AES.MODE_CBC, iv)
print(unpad(cipher.decrypt(ciphertext),16))