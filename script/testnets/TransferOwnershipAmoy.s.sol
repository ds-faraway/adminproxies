// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";
import {Vm} from "forge-std/Vm.sol";
import {ERC1967Utils} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract TransferOwnershipAmoy is Script {
    // NON-MULTISIG, CHECKED
    address public newOwner = 0xDb779a06F0430DE0e8a9Bd64dE3448Db8cccb4FE;

    address[] public proxyAddresses = [
        0xf220e1C4567DAF66932e08Dd72EB0c1A57422FEc, // AMOY_PROXY_ADMIN
        0x840376B7b231aa87c845012e9d09a32c14531EDf, // AMOY_HOT_WALLET
        0xFe6e4E3E8A798d9f1f32Dba4228D9be9B1B1f2E3, // AMOY_WETH
        0xe3AD93513C9B4B2b134F2dCf101F4C4b16F3EB6A, // AMOY_APE
        0x41E94Eb019C0762f9Bfcf9Fb1E58725BfB0e7582, // AMOY_USDC
        0x44a6510eCd7b3F9EDBc4ca066eB93f1B5007FBa4, // AMOY_DEV_VERIFIER
        0xEAbb04Ae3C37311929fbF325398374d7414eB51B, // AMOY_DEV_FEE_DISTRIBUTOR
        0x5Ed1A82fA016843E1ca723aC63bcedcd70573267, // AMOY_DEV_NFT_REGISTRY
        0xdc493e2E4B1Db9eb386Ec68FcE4b9DA20fF6D7a9, // AMOY_DEV_ROYALTY_SPLITTER
        0x3e70cF3420ce504f5Ed8f7c156ec0B598Ac417Ee, // AMOY_DEV_NFT_DEPLOYER
        0xB49b1b5CeaB1675F8728C3Ee3937c4ff25131E6C, // AMOY_DEV_NFT_FACTORY
        0xeD3de904637C50c4bDB305F3B995a5ADE2AF3442, // AMOY_DEV_PASS_CLAIM
        0x764F178064349087D4782e269B11dE1b4888CD1E, // AMOY_DEV_NFT_OPERATOR
        0x89148f896bA6920e0d6416Ad6D1be919ecbF9939, // AMOY_DEV_INCINERATOR
        0x583eEa2Ae401b50DB5832F545b0060699A8a8488, // AMOY_DEV_PAYMENT
        0x9185B62417d559CA57CD4A7c794B8c3EcEb2ce14, // AMOY_DEV_NFT_MARKETPLACE
        0xB31D15B2fA20739e0C506F3E0ce446BE4487099C, // AMOY_DEV_WINNER_ORACLE_FACTORY
        0x3a4675a429970Db4209252F0415bB60E89085F2E, // AMOY_DEV_LEADERBOARD_FACTORY
        0x476676Da50B8b5aE28dDBECfB2fbAD93E479F280, // AMOY_DEV_TOKEN_CLAIMER_APE
        0x3D5c01e503B673589b2936755A0594a2346a5626, // AMOY_DEV_ESCROW_POOL_FACTORY
        0x9a653A3e110147efd16B29578F432fD62E25aD64, // AMOY_DEV_TOKEN_STAKING_FACTORY
        0x9a20858b497a398C9b62e4633761eC3e78Fa8C92, // AMOY_DEV_FT_FACTORY
        0x7EFA1F45eB285B1d01AEfdCfC2D8497DC3969cE0, // AMOY_SANDBOX_VERIFIER
        0x567143153b9431cA33885D8A442408E01a024BF6, // AMOY_SANDBOX_FEE_DISTRIBUTOR
        0xecD8888829a3c495b559e501e7f066c1182eC7f3, // AMOY_SANDBOX_NFT_REGISTRY
        0xFA811D5c5086c3be1E2F3a5A778f9B2893DEFBC1, // AMOY_SANDBOX_ROYALTY_SPLITTER
        0x87087E069f276eF44db54692a7591D996A52A460, // AMOY_SANDBOX_NFT_DEPLOYER
        0x7A4448A38e763f86502136837648Edc27065A9C0, // AMOY_SANDBOX_NFT_FACTORY
        0x873FA3B1f799c70112b7277943b8C66D1CD03ACE, // AMOY_SANDBOX_PASS_CLAIM
        0x579A5DE0d2eb5F246186053a058D317fc4fd007c, // AMOY_SANDBOX_NFT_OPERATOR
        0xeE162d42Cb89Ff3038eB955d15E45C48315F4BE3, // AMOY_SANDBOX_INCINERATOR
        0xe7C78173f4BeA047a0df47051c1759c39Cb5A100, // AMOY_SANDBOX_PAYMENT
        0x25F846dC6929286a6f513FF4C0385e2D54B25B0B, // AMOY_SANDBOX_NFT_MARKETPLACE
        0xA3e9Fe35C9700E82358eE7d4e87a53bcC176187b, // AMOY_SANDBOX_WINNER_ORACLE_FACTORY
        0xEBF67a6c01b02703aC48e28deebB1866F9C6EcfB, // AMOY_SANDBOX_LEADERBOARD_FACTORY
        0xC77AA77a5181ab9e0E309e459f8D76c72fB3A9df, // AMOY_SANDBOX_TOKEN_CLAIMER_APE
        0xF735B91588036098D79Af2fd9e4B4217E31edC06, // AMOY_SANDBOX_ESCROW_POOL_FACTORY
        0x13a6738fb3f93C4289f78f9ffca903a5F54D13A4 // AMOY_SANDBOX_TOKEN_STAKING_FACTORY
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
