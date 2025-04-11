// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {Vm} from "forge-std/Vm.sol";
import {ERC1967Utils} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract TransferOwnershipAvalanche is Script {
    // MULTISIG, CHECKED
    address public newOwner = 0x15c1eAE4187991e36373f9b6D95A48CD9f0F7eC3;

    address[] public proxyAddresses = [
        0x324cC18A09091EA2E7CF931deD940981c101cF52, // AVALANCHE_PROXY_ADMIN
        0x49D5c2BdFfac6CE2BFdB6640F4F80f226bc10bAB, // AVALANCHE_WETH
        0xB97EF9Ef8734C71904D8002F8b6Bc66Dd9c48a6E, // AVALANCHE_USDC
        0xA88d97Bf1D079b872b366E0361C5b44b8682eb73, // AVALANCHE_VERIFIER
        0x104962BD1836187ad525F40A6CdFd6be0809917C, // AVALANCHE_FEE_DISTRIBUTOR
        0x337b6362D315BacDf118E2b19CF88DcdE3f3Bc43, // AVALANCHE_NFT_REGISTRY
        0xFAc2021F26345d47dEda7636224DEadf3Dd449dD, // AVALANCHE_ROYALTY_SPLITTER
        0xDd07392a6F34afd5015F10Eb70dC9D135148E9b9, // AVALANCHE_NFT_DEPLOYER
        0xf4C8489441C54a0B2D30233c0ecd75257106C07F, // AVALANCHE_NFT_FACTORY
        0x85800628c0d83511AAa2b828F5D0316D27a657af, // AVALANCHE_PASS_CLAIM
        0x0b65406C25702ff494EDe648D4892dc4a2805d06, // AVALANCHE_NFT_OPERATOR
        0x40bE70962e5Da5dab08Fe44ba61F135887F3ee48, // AVALANCHE_INCINERATOR
        0xEE9c23B90084F4B4667bEc3164eB5eE92D60832B, // AVALANCHE_PAYMENT
        0xfb0692a01800Db39f939175E903ADe6Bc1A0aDa3, // AVALANCHE_NFT_MARKETPLACE
        0x01Ebb961d307EE7047c7079Ade27b14BDEb4C934, // AVALANCHE_WINNER_ORACLE_FACTORY
        0x05B44d8AeA2B387c8A36047A8927421D86ff9872, // AVALANCHE_LEADERBOARD_FACTORY
        0x9fe186073435AC878D6e12D049710b38aFA55905, // AVALANCHE_ESCROW_POOL_FACTORY
        0x2131604200Fa41d9E0AE16f20Fc71E7A0bD7860C // AVALANCHE_TOKEN_STAKING_FACTORY
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
