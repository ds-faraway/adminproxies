// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {Vm} from "forge-std/Vm.sol";
import {ERC1967Utils} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract TransferOwnershipBaseSepolia is Script {
    // MULTISIG, CHECKED
    address public newOwner = 0x15c1eAE4187991e36373f9b6D95A48CD9f0F7eC3;

    address[] public proxyAddresses = [
        0x583eEa2Ae401b50DB5832F545b0060699A8a8488, // BASE_SEPOLIA_PROXY_ADMIN
        0x3cd80E6AeB7B90F442fD7C1A6e01f2ab040f65e1, // BASE_SEPOLIA_DEV_VERIFIER
        0xEAbb04Ae3C37311929fbF325398374d7414eB51B, // BASE_SEPOLIA_DEV_FEE_DISTRIBUTOR
        0xFe6e4E3E8A798d9f1f32Dba4228D9be9B1B1f2E3, // BASE_SEPOLIA_DEV_NFT_REGISTRY
        0x8d835629470aE1b36A1bE0a652108351505323e5, // BASE_SEPOLIA_DEV_ROYALTY_SPLITTER
        0x44a6510eCd7b3F9EDBc4ca066eB93f1B5007FBa4, // BASE_SEPOLIA_DEV_NFT_DEPLOYER
        0x2d71B31573334920F8402E1D87395Cae0487723F, // BASE_SEPOLIA_DEV_NFT_FACTORY
        0xdD2cA8468A835C42437Dd21c07e6c3357FDeB974, // BASE_SEPOLIA_DEV_PASS_CLAIM
        0xB31D15B2fA20739e0C506F3E0ce446BE4487099C, // BASE_SEPOLIA_DEV_NFT_OPERATOR
        0xDb409Fb334aC2908776BcD46847d440533A831c0, // BASE_SEPOLIA_DEV_INCINERATOR
        0x92EC7B6b48f3cA5FD1634bCf196F6e14d6D7fc16, // BASE_SEPOLIA_DEV_PAYMENT
        0x5Ce8B02f023676304b314520DF19C92257401E9E, // BASE_SEPOLIA_DEV_NFT_MARKETPLACE
        0x08E5451597863434fdb717ac65281943c7782D00, // BASE_SEPOLIA_DEV_WINNER_ORACLE_FACTORY
        0xE2921e62aa8fd86f1308E42B8421c01e3cFeBa3D, // BASE_SEPOLIA_DEV_LEADERBOARD_FACTORY
        0x5229CC1F949722CCd60efd1e110D7147C98f9Dec, // BASE_SEPOLIA_DEV_TOKEN_CLAIMER_APE
        0x1c16551d2b9465477b43Cc0a92F14dECFe7c1E12, // BASE_SEPOLIA_DEV_ESCROW_POOL_FACTORY
        0x83F1CaBb03cf4b6F4D10266e42185e7a0A5820FF, // BASE_SEPOLIA_DEV_TOKEN_STAKING_FACTORY
        0x144cE7490241D374D3c02B5840d0D1D53A4948A1, // BASE_SEPOLIA_SANDBOX_VERIFIER
        0xa50ea729456872afa4E6c6e71961d6e5d13c88e1, // BASE_SEPOLIA_SANDBOX_FEE_DISTRIBUTOR
        0xD5E9F636B4a4946559848e71fbe26361ca79Ae15, // BASE_SEPOLIA_SANDBOX_NFT_REGISTRY
        0xCdDFf339981643EB1B6c830cb0da39bba84B40B9, // BASE_SEPOLIA_SANDBOX_ROYALTY_SPLITTER
        0x3D1033999C34F3AdE920d7049329660A3d801f5b, // BASE_SEPOLIA_SANDBOX_NFT_DEPLOYER
        0x15a6e3f6aa9f3C22fdDf33fBB27A20b61cAB5D36, // BASE_SEPOLIA_SANDBOX_NFT_FACTORY
        0xA679B9420beE5da73E56B037801F69786A555Ce2, // BASE_SEPOLIA_SANDBOX_PASS_CLAIM
        0xB90656479bd4165B6e7FAfF98e79326736d21282, // BASE_SEPOLIA_SANDBOX_NFT_OPERATOR
        0xEF940f99fEd0da0b8Abd983459148CfE47EA7102, // BASE_SEPOLIA_SANDBOX_INCINERATOR
        0x3e70cF3420ce504f5Ed8f7c156ec0B598Ac417Ee, // BASE_SEPOLIA_SANDBOX_PAYMENT
        0x30E9109DF694F8c65c64F63c1809f5c654319629, // BASE_SEPOLIA_SANDBOX_NFT_MARKETPLACE
        0xbb27CB55607079769435b8995135A9e9aCE93793, // BASE_SEPOLIA_SANDBOX_WINNER_ORACLE_FACTORY
        0x1E3358A1346372c5D052A5a705c8E4a9e53058CD, // BASE_SEPOLIA_SANDBOX_LEADERBOARD_FACTORY
        0x625A03910842d44AfABd5576183d709fA27A73C3, // BASE_SEPOLIA_SANDBOX_TOKEN_CLAIMER_APE
        0x7Bb1C8B94C263162fD17374Be4cdaB95027100bb, // BASE_SEPOLIA_SANDBOX_ESCROW_POOL_FACTORY
        0xC907F409A767f4dB61f71EbD70233E9843B20Cd4 // BASE_SEPOLIA_SANDBOX_TOKEN_STAKING_FACTORY
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
