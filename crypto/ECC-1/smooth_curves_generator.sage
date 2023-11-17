import json

curves = []

for i in range(20):
	print("Curve",i)
	p = random_prime(2**100, lbound=2**64)
	F = GF(p)
	while True:
		a, b = randint(1, p), randint(1, p)
		E_t = EllipticCurve(F, [a, b])
		order = E_t.order()
		factors = factor(order)
		if factors[-1][0] < 2**40:
			break
	curves.append({'p': str(p), 'a': str(a), 'b': str(b)})
	
with open('curves.json','w') as f:
	json.dump(curves,f,indent=4)