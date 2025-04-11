// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {Vm} from "forge-std/Vm.sol";
import {ERC1967Utils} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract TransferOwnershipCurtis is Script {
    // NON-MULTISIG, CHECKED
    address public newOwner = 0xDb779a06F0430DE0e8a9Bd64dE3448Db8cccb4FE;

    address[] public proxyAddresses = [
        0x99EC4543233a3D0b3eD894F3d02CB006aBdDAfa6, // CURTIS_DEV_VERIFIER
        0x974780b150ADac1f8e30bc15c3bD12a44f9Dd92B, // CURTIS_DEV_FEE_DISTRIBUTOR
        0x5FF73f4F82B8D0620E2D705e13884d988D3482A6, // CURTIS_DEV_NFT_REGISTRY
        0xB3b8fc5689679eb6106005BCD998AEBC9378ff7b, // CURTIS_DEV_ROYALTY_SPLITTER
        0xCF99a05cf3914A009d438200eFF487519145404D, // CURTIS_DEV_NFT_DEPLOYER
        0x3a4675a429970Db4209252F0415bB60E89085F2E, // CURTIS_DEV_NFT_FACTORY
        0x7EFA1F45eB285B1d01AEfdCfC2D8497DC3969cE0, // CURTIS_DEV_PASS_CLAIM
        0xAe1BB03BB634958e60dF3FbEb76cfA9dEBb5Abd1, // CURTIS_DEV_NFT_OPERATOR
        0x567143153b9431cA33885D8A442408E01a024BF6, // CURTIS_DEV_INCINERATOR
        0xecD8888829a3c495b559e501e7f066c1182eC7f3, // CURTIS_DEV_PAYMENT
        0xFA811D5c5086c3be1E2F3a5A778f9B2893DEFBC1, // CURTIS_DEV_NFT_MARKETPLACE
        0x579A5DE0d2eb5F246186053a058D317fc4fd007c, // CURTIS_DEV_WINNER_ORACLE_FACTORY
        0x87087E069f276eF44db54692a7591D996A52A460, // CURTIS_DEV_LEADERBOARD_FACTORY
        0x7A4448A38e763f86502136837648Edc27065A9C0, // CURTIS_DEV_TOKEN_CLAIMER_APE
        0x78F4cF302e39C324DE8976C177916a7F2847931d, // CURTIS_DEV_ESCROW_POOL_FACTORY
        0x1A3a2c132b9e172D63f8727b76D59a808600B00F, // CURTIS_DEV_TOKEN_STAKING_FACTORY
        0x3cd80E6AeB7B90F442fD7C1A6e01f2ab040f65e1, // CURTIS_SANDBOX_VERIFIER
        0xEAbb04Ae3C37311929fbF325398374d7414eB51B, // CURTIS_SANDBOX_FEE_DISTRIBUTOR
        0x5a5c26c2Ba0BB5446decA7A27e509d8a2a7d35D4, // CURTIS_SANDBOX_NFT_REGISTRY
        0xdc493e2E4B1Db9eb386Ec68FcE4b9DA20fF6D7a9, // CURTIS_SANDBOX_ROYALTY_SPLITTER
        0xa50ea729456872afa4E6c6e71961d6e5d13c88e1, // CURTIS_SANDBOX_NFT_DEPLOYER
        0x0383aE49042d433AFD9Dd3E7aFa0eb1Ba9de4FA8, // CURTIS_SANDBOX_NFT_FACTORY
        0x840376B7b231aa87c845012e9d09a32c14531EDf, // CURTIS_SANDBOX_PASS_CLAIM
        0x764F178064349087D4782e269B11dE1b4888CD1E, // CURTIS_SANDBOX_NFT_OPERATOR
        0xeD3de904637C50c4bDB305F3B995a5ADE2AF3442, // CURTIS_SANDBOX_INCINERATOR
        0x89148f896bA6920e0d6416Ad6D1be919ecbF9939, // CURTIS_SANDBOX_PAYMENT
        0x583eEa2Ae401b50DB5832F545b0060699A8a8488, // CURTIS_SANDBOX_NFT_MARKETPLACE
        0x9185B62417d559CA57CD4A7c794B8c3EcEb2ce14, // CURTIS_SANDBOX_WINNER_ORACLE_FACTORY
        0xe3AD93513C9B4B2b134F2dCf101F4C4b16F3EB6A, // CURTIS_SANDBOX_LEADERBOARD_FACTORY
        0x06376f2285e0FC1D4aE6C559D1d3EFA3BCe2184d, // CURTIS_SANDBOX_TOKEN_CLAIMER_APE
        0xd00bA933215c962B200fEdCb757A3cf905BD4237 // CURTIS_SANDBOX_ESCROW_POOL_FACTORY
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
