// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {Vm} from "forge-std/Vm.sol";
import {ERC1967Utils} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract TransferOwnershipApechain is Script {
    // NON-MULTISIG, CHECKED
    address public newOwner = 0xDb779a06F0430DE0e8a9Bd64dE3448Db8cccb4FE;

    address[] public proxyAddresses = [
        0xC6b13d243CAd99F52b8D0Aa588ad1e11d89DC498, // APECHAIN_PROXY_ADMIN
        0xF2b6c0A2107b120e52998F4840C9B11bE4a4C8E6, // APECHAIN_VERIFIER
        0xA88d97Bf1D079b872b366E0361C5b44b8682eb73, // APECHAIN_FEE_DISTRIBUTOR
        0x435a27bbC475400B069Fe4665FF3BB87E5005c0B, // APECHAIN_NFT_REGISTRY
        0x81377f4981ab9fc127b4480D5d4F239306ceEe89, // APECHAIN_ROYALTY_SPLITTER
        0xD4a9c94adc5DD14d0624F30f97729Dd3743583A4, // APECHAIN_NFT_DEPLOYER
        0x71cA6b273bcDeCD432BE6D5F949F9Bc186AEB412, // APECHAIN_NFT_FACTORY
        0x300DD5C0cB539F773d70363b911EA2c1345e9c0C, // APECHAIN_PASS_CLAIM
        0xdFbdde4369ce32524Cb4A208B1241E61fCe032d3, // APECHAIN_NFT_OPERATOR
        0xce2822a740e37f0B3d9F3e098c3d850d8C0634c3, // APECHAIN_INCINERATOR
        0x13C853aAA3fDECF7c65A6656Ed1A09d35b82505D, // APECHAIN_PAYMENT
        0x7a8e1769A6ae4e570e71CC22eDe14761c893b848, // APECHAIN_NFT_MARKETPLACE
        0x1F9C4Ab53f900b62aa4F43070Cee279155fbDBaB, // APECHAIN_WINNER_ORACLE_FACTORY
        0x1E4764De1C2fd3563CBE10e5332F7E5b636DC18e // APECHAIN_LEADERBOARD_FACTORY
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
