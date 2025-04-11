// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {Vm} from "forge-std/Vm.sol";
import {ERC1967Utils} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract TransferOwnershipFuji is Script {
    // NON-MULTISIG, CHECKED
    address public newOwner = 0xDb779a06F0430DE0e8a9Bd64dE3448Db8cccb4FE;

    address[] public proxyAddresses = [
        0x05435866Ccc7c76f1d9400Ab470d644CACC538F3, // FUJI_DEV_VERIFIER
        0xD3cf8fFb1A65ED3ab6586679FA31Be34FE902D98, // FUJI_DEV_FEE_DISTRIBUTOR
        0x8523586635aFD45c0F9477a4B72Dd5e2e3e540b5, // FUJI_DEV_NFT_REGISTRY
        0x87943126504f2117Ad144f51bC15ed74D6E5F212, // FUJI_DEV_ROYALTY_SPLITTER
        0x9185B62417d559CA57CD4A7c794B8c3EcEb2ce14, // FUJI_DEV_NFT_DEPLOYER
        0xe3AD93513C9B4B2b134F2dCf101F4C4b16F3EB6A, // FUJI_DEV_NFT_FACTORY
        0xB31D15B2fA20739e0C506F3E0ce446BE4487099C, // FUJI_DEV_PASS_CLAIM
        0x583eEa2Ae401b50DB5832F545b0060699A8a8488, // FUJI_DEV_NFT_OPERATOR
        0x44a6510eCd7b3F9EDBc4ca066eB93f1B5007FBa4, // FUJI_DEV_INCINERATOR
        0x5a5c26c2Ba0BB5446decA7A27e509d8a2a7d35D4, // FUJI_DEV_PAYMENT
        0x2d71B31573334920F8402E1D87395Cae0487723F, // FUJI_DEV_NFT_MARKETPLACE
        0xdD2cA8468A835C42437Dd21c07e6c3357FDeB974, // FUJI_DEV_WINNER_ORACLE_FACTORY
        0xDb409Fb334aC2908776BcD46847d440533A831c0, // FUJI_DEV_LEADERBOARD_FACTORY
        0x1c16551d2b9465477b43Cc0a92F14dECFe7c1E12, // FUJI_DEV_TOKEN_CLAIMER_APE
        0x5Ce8B02f023676304b314520DF19C92257401E9E, // FUJI_DEV_ESCROW_POOL_FACTORY
        0x08E5451597863434fdb717ac65281943c7782D00, // FUJI_DEV_TOKEN_STAKING_FACTORY
        0x6b44aB1576992cAE2f1B70C64cFbAAeb99335f9f, // FUJI_SANDBOX_VERIFIER
        0x764F178064349087D4782e269B11dE1b4888CD1E, // FUJI_SANDBOX_FEE_DISTRIBUTOR
        0x5941571C8e156E9d0DBD56c0CCb08170be085C9F, // FUJI_SANDBOX_NFT_REGISTRY
        0xD5E9F636B4a4946559848e71fbe26361ca79Ae15, // FUJI_SANDBOX_ROYALTY_SPLITTER
        0xB90656479bd4165B6e7FAfF98e79326736d21282, // FUJI_SANDBOX_NFT_DEPLOYER
        0x3D1033999C34F3AdE920d7049329660A3d801f5b, // FUJI_SANDBOX_NFT_FACTORY
        0x15a6e3f6aa9f3C22fdDf33fBB27A20b61cAB5D36, // FUJI_SANDBOX_PASS_CLAIM
        0xCdDFf339981643EB1B6c830cb0da39bba84B40B9, // FUJI_SANDBOX_NFT_OPERATOR
        0xA679B9420beE5da73E56B037801F69786A555Ce2, // FUJI_SANDBOX_INCINERATOR
        0x144cE7490241D374D3c02B5840d0D1D53A4948A1, // FUJI_SANDBOX_PAYMENT
        0xEF940f99fEd0da0b8Abd983459148CfE47EA7102, // FUJI_SANDBOX_NFT_MARKETPLACE
        0x30E9109DF694F8c65c64F63c1809f5c654319629, // FUJI_SANDBOX_WINNER_ORACLE_FACTORY
        0xbb27CB55607079769435b8995135A9e9aCE93793, // FUJI_SANDBOX_LEADERBOARD_FACTORY
        0xC907F409A767f4dB61f71EbD70233E9843B20Cd4, // FUJI_SANDBOX_TOKEN_CLAIMER_APE
        0x1E3358A1346372c5D052A5a705c8E4a9e53058CD // FUJI_SANDBOX_ESCROW_POOL_FACTORY
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
