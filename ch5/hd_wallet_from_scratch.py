
import hmac
import hashlib
from ecdsa import SigningKey, SECP256k1

# Base58Check 인코딩 함수
BASE58_ALPHABET = '123456789ABCDEFGHJKLMNPQRSTUVWXYZabcdefghijkmnopqrstuvwxyz'

def base58_encode(b: bytes) -> str:
    num = int.from_bytes(b, 'big')
    encode = ''
    while num > 0:
        num, rem = divmod(num, 58)
        encode = BASE58_ALPHABET[rem] + encode
    pad = 0
    for byte in b:
        if byte == 0:
            pad += 1
        else:
            break
    return '1' * pad + encode

def base58check_encode(data: bytes) -> str:
    checksum = hashlib.sha256(hashlib.sha256(data).digest()).digest()[:4]
    return base58_encode(data + checksum)

# 고정된 테스트용 니모닉
mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
passphrase = ""
seed = hashlib.pbkdf2_hmac("sha512", mnemonic.encode("utf-8"), b"mnemonic" + passphrase.encode("utf-8"), 2048)

# BIP32 마스터 키 생성
I = hmac.new(b"Bitcoin seed", seed, hashlib.sha512).digest()
IL, IR = I[:32], I[32:]  # IL = master private key, IR = chain code

# 공개키 계산
sk = SigningKey.from_string(IL, curve=SECP256k1)
vk = sk.get_verifying_key()
pubkey_bytes_compressed = (
    b'\x02' + vk.to_string()[:32] if vk.to_string()[-1] % 2 == 0 else b'\x03' + vk.to_string()[:32]
)

# 확장키 포맷 조립
def encode_xprv(depth, fingerprint, child_number, chain_code, privkey):
    version = bytes.fromhex("0488ADE4")  # xprv
    key_data = b'\x00' + privkey
    raw = version + bytes([depth]) + fingerprint + child_number + chain_code + key_data
    return base58check_encode(raw)

def encode_xpub(depth, fingerprint, child_number, chain_code, pubkey):
    version = bytes.fromhex("0488B21E")  # xpub
    raw = version + bytes([depth]) + fingerprint + child_number + chain_code + pubkey
    return base58check_encode(raw)

# 루트 기준 정보
depth = 0
fingerprint = b'\x00\x00\x00\x00'
child_number = b'\x00\x00\x00\x00'

# 확장키 생성
xprv = encode_xprv(depth, fingerprint, child_number, IR, IL)
xpub = encode_xpub(depth, fingerprint, child_number, IR, pubkey_bytes_compressed)

# 출력
print("Mnemonic:", mnemonic)
print("Master Private Key (hex):", IL.hex())
print("Master Public Key (compressed):", pubkey_bytes_compressed.hex())
print("xprv:", xprv)
print("xpub:", xpub)
