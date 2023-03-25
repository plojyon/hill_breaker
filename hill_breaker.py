import numpy as np
import itertools
from tqdm import tqdm

def factorize(n):
    """Return a list of prime factors of n."""
    factors = []
    d = 2
    while n > 1:
        while n % d == 0:
            factors.append(d)
            n //= d
        d = d + 1
        if d*d > n:
            if n > 1: factors.append(n)
            break
    return factors

def subset(arr, bits):
    """Return a subset of arr with the i-th bit set."""
    return [x for i,x in enumerate(arr) if (bits >> i) & 1]

def unique(arr):
    """Return unique elements of a list."""
    # list(set(arr)) won't work
    uniq = []
    for x in arr:
        if x not in uniq:
            uniq.append(x)
    return uniq

frequencies = {
    "A": 8.17,
    "B": 1.49,
    "C": 2.78,
    "D": 4.25,
    "E": 12.70,
    "F": 2.23,
    "G": 2.02,
    "H": 6.09,
    "I": 7.00,
    "J": 0.15,
    "K": 0.77,
    "L": 4.03,
    "M": 2.41,
    "N": 6.75,
    "O": 7.51,
    "P": 1.93,
    "Q": 0.10,
    "R": 5.99,
    "S": 6.33,
    "T": 9.06,
    "U": 2.76,
    "V": 0.98,
    "W": 2.36,
    "X": 0.15,
    "Y": 1.97,
    "Z": 0.07,
}
ch2int = {c: i for i, c in enumerate(frequencies)}
int2ch = list(frequencies.keys())
chars = len(int2ch)
freqs = np.array([frequencies[c] for c in int2ch])

def decrypt(blocks, key):
    """Decrypt all blocks with a key."""
    return np.dot(key, blocks) % chars

def brute_force(blocks, N):
    """Brute force the keys for a given N."""
    top_keys = [None for _ in range(N)]
    top_scores = np.array([100000000 for _ in range(N)])

    for key_idx in tqdm(range(chars**N)):
        key = np.array([(key_idx // chars**i) % (chars-1) for i in range(N)])
        text = decrypt(blocks, key)
        score = chi2(text)

        if (score < top_scores).any():
            idx = np.argmax(top_scores)
            top_scores[idx] = score
            top_keys[idx] = key

    for key in top_keys:
        if key is None:
            return None, None

    list1, list2 = zip(*sorted(zip(top_scores, top_keys)))
    top_scores, top_keys = list(list1), list(list2)
    return top_keys, top_scores

def chi2(text):
    """Count occurrences for each character in text."""
    observed = np.histogram(text, bins=range(chars+1))[0]
    expected = freqs * len(text) / 100
    return np.sum((observed - expected)**2 / expected)

if __name__ == "__main__":
    with open("cipher.txt", "r") as f:
        raw = f.read()

    cipher = "".join(raw.split("\n")).upper()
    factors = factorize(len(cipher))
    n_candidates = unique([subset(factors, i) for i in range(1, 2**len(factors))])

    for candidate in n_candidates:
        n = np.prod(candidate)
        print("Trying N =", n)
        blocks = np.array([ch2int[ch] for ch in cipher]).reshape(-1, n).T
        keys, scores = brute_force(blocks, n)
        print("Keys: {}, scores: {}".format(keys, scores))
        if keys is None:
            continue
        for permutation in itertools.permutations(keys):
            print("Permutation", permutation)
            text = "".join([
                int2ch[i]
                for i in decrypt(blocks, np.array(permutation)).T.flatten()
            ])
            print(text)
            try:
                input("Press enter to continue ...\n")
            except KeyboardInterrupt:
                print("HillBreaker done.")
                exit(0)
        print()
