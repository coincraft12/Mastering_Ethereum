import os
import hashlib

# -------------------------------
# BIP-39 영어 단어 목록 불러오기
# -------------------------------
def load_wordlist():
    with open("bip39_english.txt", "r", encoding="utf-8") as f:
        return [word.strip() for word in f.readlines()]

# -------------------------------
# 엔트로피 + 체크섬 비트열 생성
# -------------------------------
def generate_entropy(entropy_bits=128):
    if entropy_bits not in [128, 160, 192, 224, 256]:
        raise ValueError("엔트로피 비트는 128, 160, 192, 224, 256 중 하나여야 합니다.")
    
    # 엔트로피 생성
    byte_length = entropy_bits // 8
    entropy = os.urandom(byte_length)
    entropy_bits_bin = bin(int.from_bytes(entropy, byteorder='big'))[2:].zfill(entropy_bits)

    # 체크섬 생성
    hash_digest = hashlib.sha256(entropy).hexdigest()
    hash_bits = bin(int(hash_digest, 16))[2:].zfill(256)
    checksum_length = entropy_bits // 32
    checksum = hash_bits[:checksum_length]

    # 최종 비트열 = 엔트로피 + 체크섬
    full_bits = entropy_bits_bin + checksum
    return full_bits

# -------------------------------
# 11비트씩 나눠서 단어로 매핑
# -------------------------------
def bits_to_mnemonic(bits, wordlist):
    words = []
    for i in range(0, len(bits), 11):
        chunk = bits[i:i+11]
        index = int(chunk, 2)
        words.append(wordlist[index])
    return words

# -------------------------------
# 전체 니모닉 생성기
# -------------------------------
def generate_mnemonic(entropy_bits=128):
    wordlist = load_wordlist()
    full_bits = generate_entropy(entropy_bits)
    mnemonic_words = bits_to_mnemonic(full_bits, wordlist)
    return ' '.join(mnemonic_words)

# -------------------------------
# 메인 실행
# -------------------------------
if __name__ == "__main__":
    mnemonic = generate_mnemonic(128)
    print("니모닉 코드:")
    print(mnemonic)
