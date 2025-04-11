// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {Vm} from "forge-std/Vm.sol";
import {ERC1967Utils} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract TransferOwnershipArbitrumSepolia is Script {
    // NON-MULTISIG, CHECKED
    address public newOwner = 0xDb779a06F0430DE0e8a9Bd64dE3448Db8cccb4FE;

    address[] public proxyAddresses = [
        0xeD3de904637C50c4bDB305F3B995a5ADE2AF3442, // ARBITRUM_SEPOLIA_PROXY_ADMIN
        0x3cd80E6AeB7B90F442fD7C1A6e01f2ab040f65e1, // ARBITRUM_SEPOLIA_DEV_VERIFIER
        0xEAbb04Ae3C37311929fbF325398374d7414eB51B, // ARBITRUM_SEPOLIA_DEV_FEE_DISTRIBUTOR
        0x3d96ca6D63d93bceE5137D2148a06077d06173Fd, // ARBITRUM_SEPOLIA_DEV_NFT_REGISTRY
        0xDfa6eFA5ED8CdfF2D1630Ce49D74198BC3F73A01, // ARBITRUM_SEPOLIA_DEV_ROYALTY_SPLITTER
        0x8d835629470aE1b36A1bE0a652108351505323e5, // ARBITRUM_SEPOLIA_DEV_NFT_DEPLOYER
        0xB31D15B2fA20739e0C506F3E0ce446BE4487099C, // ARBITRUM_SEPOLIA_DEV_NFT_FACTORY
        0x37f193eabFB73f11fC79A5A67fd5c226544462A9, // ARBITRUM_SEPOLIA_DEV_PASS_CLAIM
        0xFe6e4E3E8A798d9f1f32Dba4228D9be9B1B1f2E3, // ARBITRUM_SEPOLIA_DEV_NFT_OPERATOR
        0xf8e1d9230AE7eF03083e127e6C8b0A85A41a12e3, // ARBITRUM_SEPOLIA_DEV_INCINERATOR
        0x92EC7B6b48f3cA5FD1634bCf196F6e14d6D7fc16, // ARBITRUM_SEPOLIA_DEV_PAYMENT
        0x99d3F47ed0BfE24Ff39E915DC98049645940f06C, // ARBITRUM_SEPOLIA_DEV_NFT_MARKETPLACE
        0x2149A94dA2E2D848705539191A97c3eB05d759D0, // ARBITRUM_SEPOLIA_DEV_WINNER_ORACLE_FACTORY
        0xBab700c07a8E342D3aba3b261525365b2f0b3C87, // ARBITRUM_SEPOLIA_DEV_LEADERBOARD_FACTORY
        0x0846fabA551838F387d8119c93Da7656F6Ddce9B, // ARBITRUM_SEPOLIA_DEV_TOKEN_CLAIMER_APE
        0x0605bD6D41F8e80AC567AB4D36B5608bd7428fA5, // ARBITRUM_SEPOLIA_DEV_ESCROW_POOL_FACTORY
        0x2b1469B4F69C5ceb44572552cb2A3C3A9794e6F8, // ARBITRUM_SEPOLIA_DEV_TOKEN_STAKING_FACTORY
        0x144cE7490241D374D3c02B5840d0D1D53A4948A1, // ARBITRUM_SEPOLIA_SANDBOX_VERIFIER
        0xa50ea729456872afa4E6c6e71961d6e5d13c88e1, // ARBITRUM_SEPOLIA_SANDBOX_FEE_DISTRIBUTOR
        0xCdDFf339981643EB1B6c830cb0da39bba84B40B9, // ARBITRUM_SEPOLIA_SANDBOX_NFT_REGISTRY
        0xB90656479bd4165B6e7FAfF98e79326736d21282, // ARBITRUM_SEPOLIA_SANDBOX_ROYALTY_SPLITTER
        0x15a6e3f6aa9f3C22fdDf33fBB27A20b61cAB5D36, // ARBITRUM_SEPOLIA_SANDBOX_NFT_DEPLOYER
        0xA679B9420beE5da73E56B037801F69786A555Ce2, // ARBITRUM_SEPOLIA_SANDBOX_NFT_FACTORY
        0xEF940f99fEd0da0b8Abd983459148CfE47EA7102, // ARBITRUM_SEPOLIA_SANDBOX_PASS_CLAIM
        0x3D1033999C34F3AdE920d7049329660A3d801f5b, // ARBITRUM_SEPOLIA_SANDBOX_NFT_OPERATOR
        0x30E9109DF694F8c65c64F63c1809f5c654319629, // ARBITRUM_SEPOLIA_SANDBOX_INCINERATOR
        0x3e70cF3420ce504f5Ed8f7c156ec0B598Ac417Ee, // ARBITRUM_SEPOLIA_SANDBOX_PAYMENT
        0xbb27CB55607079769435b8995135A9e9aCE93793, // ARBITRUM_SEPOLIA_SANDBOX_NFT_MARKETPLACE
        0x1E3358A1346372c5D052A5a705c8E4a9e53058CD, // ARBITRUM_SEPOLIA_SANDBOX_WINNER_ORACLE_FACTORY
        0x7Bb1C8B94C263162fD17374Be4cdaB95027100bb, // ARBITRUM_SEPOLIA_SANDBOX_LEADERBOARD_FACTORY
        0x3f675f0392C188cb0DceBBF4B876d93C8F062cee, // ARBITRUM_SEPOLIA_SANDBOX_TOKEN_CLAIMER_APE
        0xC907F409A767f4dB61f71EbD70233E9843B20Cd4, // ARBITRUM_SEPOLIA_SANDBOX_ESCROW_POOL_FACTORY
        0x625A03910842d44AfABd5576183d709fA27A73C3 // ARBITRUM_SEPOLIA_SANDBOX_TOKEN_STAKING_FACTORY
    ];

    function run() public {
        vm.startBroadcast(0x8AFfBdec195700dB11465733146c708af538C0ED);
        console.log("For network polygon amoy");

        for (uint256 i = 0; i < proxyAddresses.length; i++) {
            address proxy = proxyAddresses[i];
            address adminProxy = getAdminAddress(proxy);
            if (adminProxy != address(0)) {
                console.log("---");
                console.log("for proxy", proxy);
                console.log("Transferring ownership of admin proxy(", adminProxy, ") to", newOwner);
                console.log("old owner", Ownable(adminProxy).owner());
                Ownable(adminProxy).transferOwnership(newOwner);
                console.log("new owner", Ownable(adminProxy).owner());
                console.log("---");
            } else {
                console.log("---");
                console.log("no admin proxy found for", proxy);
                console.log("---");
            }
        }

        vm.stopBroadcast();
    }

    function getAdminAddress(address proxy) internal view returns (address) {
        address CHEATCODE_ADDRESS = 0x7109709ECfa91a80626fF3989D68f67F5b1DD12D;
        Vm vm = Vm(CHEATCODE_ADDRESS);

        bytes32 adminSlot = vm.load(proxy, ERC1967Utils.ADMIN_SLOT);
        return address(uint160(uint256(adminSlot)));
    }
}
