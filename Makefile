include .env
export $(shell sed 's/=.*//' .env)

DEPLOYER_PRIVATE_KEY := $(DEPLOYER_PRIVATE_KEY)


# Binaries
BIN_FORGE=$(HOME)/.foundry/bin/forge


# Testnets
transfer-ownership-amoy:
	$(BIN_FORGE) script script/testnets/TransferOwnershipAmoy.s.sol --rpc-url $(POLYGON_AMOY_RPC_URL) --broadcast --private-key $(DEPLOYER_PRIVATE_KEY)

transfer-ownership-curtis:
	$(BIN_FORGE) script script/testnets/TransferOwnershipCurtis.s.sol --rpc-url $(CURTIS_RPC_URL) --broadcast --private-key $(DEPLOYER_PRIVATE_KEY)

transfer-ownership-fuji:
	$(BIN_FORGE) script script/testnets/TransferOwnershipFuji.s.sol --rpc-url $(AVALANCHE_FUJI_RPC_URL) --broadcast --private-key $(DEPLOYER_PRIVATE_KEY)

transfer-ownership-arbitrum-sepolia:
	$(BIN_FORGE) script script/testnets/TransferOwnershipArbitrumSepolia.s.sol --rpc-url $(ARBITRUM_SEPOLIA_RPC_URL) --broadcast --private-key $(DEPLOYER_PRIVATE_KEY)

transfer-ownership-base-sepolia:
	$(BIN_FORGE) script script/testnets/TransferOwnershipBaseSepolia.s.sol --rpc-url $(BASE_SEPOLIA_RPC_URL) --broadcast --private-key $(DEPLOYER_PRIVATE_KEY)

# Forking
# Testnets
fork-transfer-ownership-amoy:
	$(BIN_FORGE) script script/testnets/TransferOwnershipAmoy.s.sol --broadcast --fork-url $(POLYGON_AMOY_RPC_URL) -vvvv

fork-transfer-ownership-curtis:
	$(BIN_FORGE) script script/testnets/TransferOwnershipCurtis.s.sol --broadcast --fork-url $(CURTIS_RPC_URL) -vvvv

fork-transfer-ownership-fuji:
	$(BIN_FORGE) script script/testnets/TransferOwnershipFuji.s.sol --broadcast --fork-url $(AVALANCHE_FUJI_RPC_URL) -vvvv

fork-transfer-ownership-arbitrum-sepolia:
	$(BIN_FORGE) script script/testnets/TransferOwnershipArbitrumSepolia.s.sol --broadcast --fork-url $(ARBITRUM_SEPOLIA_RPC_URL) -vvvv

fork-transfer-ownership-base-sepolia:
	$(BIN_FORGE) script script/testnets/TransferOwnershipBaseSepolia.s.sol --broadcast --fork-url $(BASE_SEPOLIA_RPC_URL) -vvvv

# Mainnets
transfer-ownership-apechain:
	$(BIN_FORGE) script script/mainnets/TransferOwnershipApechain.s.sol --rpc-url $(APECHAIN_RPC_URL) --broadcast --private-key $(DEPLOYER_PRIVATE_KEY)

transfer-ownership-avalanche:
	$(BIN_FORGE) script script/mainnets/TransferOwnershipAvalanche.s.sol --rpc-url $(AVALANCHE_RPC_URL) --broadcast --private-key $(DEPLOYER_PRIVATE_KEY)

transfer-ownership-arbitrum:
	$(BIN_FORGE) script script/mainnets/TransferOwnershipArbitrum.s.sol --rpc-url $(ARBITRUM_RPC_URL) --broadcast --private-key $(DEPLOYER_PRIVATE_KEY)

transfer-ownership-base:
	$(BIN_FORGE) script script/mainnets/TransferOwnershipBase.s.sol --rpc-url $(BASE_RPC_URL) --broadcast --private-key $(DEPLOYER_PRIVATE_KEY)

# Forking
# Mainnets
fork-transfer-ownership-apechain:
	$(BIN_FORGE) script script/mainnets/TransferOwnershipApechain.s.sol --broadcast --fork-url $(APECHAIN_RPC_URL) -vvvv

fork-transfer-ownership-avalanche:
	$(BIN_FORGE) script script/mainnets/TransferOwnershipAvalanche.s.sol --broadcast --fork-url $(AVALANCHE_RPC_URL) -vvvv

fork-transfer-ownership-arbitrum:
	$(BIN_FORGE) script script/mainnets/TransferOwnershipArbitrum.s.sol --broadcast --fork-url $(ARBITRUM_RPC_URL) -vvvv

fork-transfer-ownership-base:
	$(BIN_FORGE) script script/mainnets/TransferOwnershipBase.s.sol --broadcast --fork-url $(BASE_RPC_URL) -vvvv
