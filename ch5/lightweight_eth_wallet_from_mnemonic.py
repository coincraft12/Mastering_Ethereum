import streamlit as st
from mnemonic import Mnemonic
from eth_keys import keys
from eth_utils import to_checksum_address
import os
import hashlib

def generate_mnemonic_and_keys():
    mnemo = Mnemonic("english")
    mnemonic = mnemo.generate(strength=128)  # 12단어
    seed = mnemo.to_seed(mnemonic, passphrase="")

    # 비표준이지만: 시드의 앞 32바이트를 개인키로 사용
    private_key_bytes = seed[:32]
    private_key = keys.PrivateKey(private_key_bytes)
    public_key = private_key.public_key
    address = public_key.to_checksum_address()

    return {
        "mnemonic": mnemonic,
        "seed_hex": seed.hex(),
        "private_key": private_key.to_hex(),
        "public_key": public_key.to_hex(),
        "address": address
    }

def main():
    st.title("경량 이더리움 주소 생성기 (니모닉 기반)")
    st.markdown("`mnemonic`, `eth_keys`, `eth_utils`만 사용한 경량 버전입니다.")

    if st.button("니모닉 → 키 생성"):
        result = generate_mnemonic_and_keys()

        st.subheader("1. 니모닉")
        st.code(result["mnemonic"])

        st.subheader("2. 시드 (Hex)")
        st.code(result["seed_hex"])

        st.subheader("3. 개인키")
        st.code(result["private_key"])

        st.subheader("4. 공개키")
        st.code(result["public_key"])

        st.subheader("5. 이더리움 주소 (EIP-55)")
        st.code(result["address"])

if __name__ == "__main__":
    main()