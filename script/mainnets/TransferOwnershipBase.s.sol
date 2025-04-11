// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {Vm} from "forge-std/Vm.sol";
import {ERC1967Utils} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract TransferOwnershipBase is Script {
    // MULTISIG, CHECKED
    address public newOwner = 0x15c1eAE4187991e36373f9b6D95A48CD9f0F7eC3;

    address[] public proxyAddresses = [
        0x13C853aAA3fDECF7c65A6656Ed1A09d35b82505D, // BASE_PROXY_ADMIN
        0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913, // BASE_USDC
        0xad3794Ef13bb0be422D53CabbeEaEc31059C64F4, // BASE_VERIFIER
        0x435a27bbC475400B069Fe4665FF3BB87E5005c0B, // BASE_FEE_DISTRIBUTOR
        0x337b6362D315BacDf118E2b19CF88DcdE3f3Bc43, // BASE_NFT_REGISTRY
        0xFAc2021F26345d47dEda7636224DEadf3Dd449dD, // BASE_ROYALTY_SPLITTER
        0x40bE70962e5Da5dab08Fe44ba61F135887F3ee48, // BASE_NFT_DEPLOYER
        0xfb0692a01800Db39f939175E903ADe6Bc1A0aDa3, // BASE_NFT_FACTORY
        0x01Ebb961d307EE7047c7079Ade27b14BDEb4C934, // BASE_PASS_CLAIM
        0x0b65406C25702ff494EDe648D4892dc4a2805d06, // BASE_NFT_OPERATOR
        0x05B44d8AeA2B387c8A36047A8927421D86ff9872, // BASE_INCINERATOR
        0x81377f4981ab9fc127b4480D5d4F239306ceEe89, // BASE_PAYMENT
        0x9fe186073435AC878D6e12D049710b38aFA55905, // BASE_NFT_MARKETPLACE
        0x2131604200Fa41d9E0AE16f20Fc71E7A0bD7860C, // BASE_WINNER_ORACLE_FACTORY
        0x7A55a98f23c7040Df3C508d528b28Fe0e558BBF5, // BASE_LEADERBOARD_FACTORY
        0x5f9034E02B3131334640e13159c27Cd0beC64006, // BASE_ESCROW_POOL_FACTORY
        0x630C7c69E116D6006C91Fa70e172309704AC0225 // BASE_TOKEN_STAKING_FACTORY
    ];

    function run() public {
        vm.startBroadcast(0x8601A07385FbD135627373e9938d6B0fd92aeee1);
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
