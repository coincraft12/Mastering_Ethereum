import os
import hashlib
import streamlit as st

@st.cache_data
def load_wordlist():
    with open("bip39_english.txt", "r", encoding="utf-8") as f:
        return [word.strip() for word in f.readlines()]

def generate_entropy(entropy_bits):
    entropy = os.urandom(entropy_bits // 8)
    entropy_hex = entropy.hex()
    entropy_bin = bin(int.from_bytes(entropy, 'big'))[2:].zfill(entropy_bits)
    return entropy, entropy_hex, entropy_bin

def sha256_checksum(entropy):
    digest = hashlib.sha256(entropy).digest()
    digest_hex = digest.hex()
    digest_bin = bin(int.from_bytes(digest, 'big'))[2:].zfill(256)
    return digest, digest_hex, digest_bin

def build_full_bitstring(entropy_bin, checksum_bin, checksum_len):
    return entropy_bin + checksum_bin[:checksum_len]

def split_into_chunks(bits, chunk_size=11):
    return [bits[i:i+chunk_size] for i in range(0, len(bits), chunk_size)]

def main():
    st.title("🔐 BIP-39 니모닉 생성기 (중간 과정 보기)")
    st.markdown("이 앱은 BIP-39 표준에 따라 니모닉 코드와 생성 과정을 단계별로 보여줍니다.")

    word_count = st.selectbox("원하는 니모닉 단어 수", [12, 15, 18, 21, 24])
    entropy_bits = {12: 128, 15: 160, 18: 192, 21: 224, 24: 256}[word_count]
    checksum_len = entropy_bits // 32

    if st.button("🎲 니모닉 생성하기"):
        wordlist = load_wordlist()

        # Step 1: 엔트로피 생성
        entropy, entropy_hex, entropy_bin = generate_entropy(entropy_bits)
        st.subheader("1. 엔트로피")
        st.text(f"[Hex]  {entropy_hex}")
        st.text(f"[Bin]  {entropy_bin}")

        # Step 2: SHA-256 해시 → 체크섬
        digest, digest_hex, digest_bin = sha256_checksum(entropy)
        checksum = digest_bin[:checksum_len]
        st.subheader("2. SHA-256 해시 → 체크섬")
        st.text(f"[SHA-256 Hex] {digest_hex}")
        st.text(f"[체크섬 비트 수] {checksum_len} bits")
        st.text(f"[체크섬 (Bin)]  {checksum}")

        # Step 3: 최종 비트열 만들기
        final_bits = build_full_bitstring(entropy_bin, checksum, checksum_len)
        st.subheader("3. 엔트로피 + 체크섬 → 최종 비트열")
        st.text(final_bits)

        # Step 4: 11비트 청크로 나누기
        chunks = split_into_chunks(final_bits)
        st.subheader("4. 11비트 블록 → 단어 인덱스 & 단어")
        for i, chunk in enumerate(chunks):
            idx = int(chunk, 2)
            word = wordlist[idx]
            st.text(f"{i+1:02d}. [{chunk}] → {idx} → {word}")

        # Step 5: 최종 니모닉
        st.subheader("최종 니모닉 코드")
        mnemonic = [wordlist[int(chunk, 2)] for chunk in chunks]
        st.code(" ".join(mnemonic), language="text")

if __name__ == "__main__":
    main()