import os
from eth_keys import keys
from eth_utils import keccak, to_checksum_address

# 1. 무작위 32바이트 개인키 생성
private_key_bytes = os.urandom(32)
private_key = keys.PrivateKey(private_key_bytes)

# 2. 공개키 생성
public_key = private_key.public_key

# 3. 이더리움 주소 계산 (keccak256 해시 후 마지막 20바이트)
public_key_bytes = public_key.to_bytes()
address_bytes = keccak(public_key_bytes)[-20:]
eth_address = to_checksum_address(address_bytes)

# 출력
print("🔐 Private Key:", private_key)
print("🔓 Public Key :", public_key)
print("📬 Ethereum Address:", eth_address)
