import hill_breaker

if __name__ == "__main__":
    with open("key.txt", "r") as f:
        key = hill_breaker.np.loadtxt(f, dtype=int)
    n = key.shape[0]

    with open("plaintext.txt", "r") as f:
        plain = f.read()

    # preprocessing
    plain = plain.upper()
    plain = [hill_breaker.ch2int[ch] for ch in plain if ch.isalpha()]

    # pad with Xs
    padding = n - len(plain) % n
    plain += [hill_breaker.ch2int["X"] for _ in range(padding)]

    blocks = hill_breaker.np.array(plain).reshape(-1, n).T

    cipher = hill_breaker.decrypt(blocks, key).T.flatten()
    print("".join([hill_breaker.int2ch[i] for i in cipher]))
