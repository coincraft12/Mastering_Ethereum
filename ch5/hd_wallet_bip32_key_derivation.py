from bip_utils import Bip39SeedGenerator, Bip32Slip10Secp256k1
from bip_utils.utils import CryptoUtils

# 1. 니모닉 또는 시드 준비
mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"
passphrase = ""  # 보통은 비워둬
seed_bytes = Bip39SeedGenerator(mnemonic).Generate(passphrase)

# 2. BIP32 루트 키 생성 (secp256k1 곡선 사용)
bip32_root = Bip32Slip10Secp256k1.FromSeed(seed_bytes)

# 3. 루트 확장 키(xprv, xpub) 출력
print("🔐 Root xprv:", bip32_root.PrivateKey().ToExtended())
print("🔓 Root xpub:", bip32_root.PublicKey().ToExtended())

# 4. 자식 키 파생 (예: m/0/1)
child = bip32_root.DerivePath("m/0/1")

print("\n--- 자식 키 파생 결과 ---")
print("📍 경로: m/0/1")
print("🔐 Child xprv:", child.PrivateKey().Raw().ToHex())
print("🔓 Child xpub:", child.PublicKey().RawCompressed().ToHex())
print("📬 Address-like (Keccak hash last 20 bytes):", CryptoUtils.Kekkak256(child.PublicKey().RawUncompressed().ToBytes())[12:].hex())
