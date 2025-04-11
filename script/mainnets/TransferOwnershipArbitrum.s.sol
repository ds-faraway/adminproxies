// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {Vm} from "forge-std/Vm.sol";
import {ERC1967Utils} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract TransferOwnershipArbitrum is Script {
    // MULTISIG, CHECKED
    address public newOwner = 0x15c1eAE4187991e36373f9b6D95A48CD9f0F7eC3;

    address[] public proxyAddresses = [
        0xA88d97Bf1D079b872b366E0361C5b44b8682eb73, // ARBITRUM_ONE_VERIFIER
        0x104962BD1836187ad525F40A6CdFd6be0809917C, // ARBITRUM_ONE_FEE_DISTRIBUTOR
        0x1F9C4Ab53f900b62aa4F43070Cee279155fbDBaB, // ARBITRUM_ONE_NFT_REGISTRY
        0x1E4764De1C2fd3563CBE10e5332F7E5b636DC18e, // ARBITRUM_ONE_ROYALTY_SPLITTER
        0xC6b13d243CAd99F52b8D0Aa588ad1e11d89DC498, // ARBITRUM_ONE_NFT_DEPLOYER
        0xD4a9c94adc5DD14d0624F30f97729Dd3743583A4, // ARBITRUM_ONE_NFT_FACTORY
        0x71cA6b273bcDeCD432BE6D5F949F9Bc186AEB412, // ARBITRUM_ONE_PASS_CLAIM
        0x7a8e1769A6ae4e570e71CC22eDe14761c893b848, // ARBITRUM_ONE_NFT_OPERATOR
        0x300DD5C0cB539F773d70363b911EA2c1345e9c0C, // ARBITRUM_ONE_INCINERATOR
        0xEE9c23B90084F4B4667bEc3164eB5eE92D60832B, // ARBITRUM_ONE_PAYMENT
        0x0b64004d3807cad70871108b8FC8f60F128F9479, // ARBITRUM_ONE_NFT_MARKETPLACE
        0x324cC18A09091EA2E7CF931deD940981c101cF52, // ARBITRUM_ONE_WINNER_ORACLE_FACTORY
        0xDd07392a6F34afd5015F10Eb70dC9D135148E9b9, // ARBITRUM_ONE_LEADERBOARD_FACTORY
        0xf4C8489441C54a0B2D30233c0ecd75257106C07F, // ARBITRUM_ONE_ESCROW_POOL_FACTORY
        0x85800628c0d83511AAa2b828F5D0316D27a657af // ARBITRUM_ONE_TOKEN_STAKING_FACTORY
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
