from bip_utils import (
    Bip39SeedGenerator, Bip44, Bip44Coins, Bip44Changes,  # ⬅️ Bip44Changes 추가!
    Bip32Slip10Secp256k1, EthAddrEncoder, Secp256k1PublicKey
)

# 예시 니모닉 (테스트용)
mnemonic = "abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon abandon about"

# 니모닉 → 시드
seed_bytes = Bip39SeedGenerator(mnemonic).Generate()

# ------------------------------
# 1. m/0/0 (비표준 구조 실습용)
# ------------------------------
bip32_ctx = Bip32Slip10Secp256k1.FromSeed(seed_bytes)
child_key_m_0_0 = bip32_ctx.DerivePath("m/0/0")

eth_pub_key = Secp256k1PublicKey.FromBytes(child_key_m_0_0.PublicKey().RawCompressed().ToBytes())

print("=== m/0/0 ===")
print("Private key:", child_key_m_0_0.PrivateKey().Raw().ToHex())
print("Public key :", child_key_m_0_0.PublicKey().RawCompressed().ToHex())
print("Address     :", EthAddrEncoder.EncodeKey(eth_pub_key))
print()

# ------------------------------
# 2. m/44'/60'/0'/0/0 (BIP-44 실전용)
# ------------------------------
bip44_eth = Bip44.FromSeed(seed_bytes, Bip44Coins.ETHEREUM)
bip44_acc = bip44_eth.Purpose().Coin().Account(0).Change(Bip44Changes.CHAIN_EXT).AddressIndex(0)

print("=== m/44'/60'/0'/0/0 ===")
print("Private key:", bip44_acc.PrivateKey().Raw().ToHex())
print("Public key :", bip44_acc.PublicKey().RawCompressed().ToHex())
print("Address     :", bip44_acc.PublicKey().ToAddress())
