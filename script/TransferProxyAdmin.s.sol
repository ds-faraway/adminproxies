// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script} from "forge-std/Script.sol";
import {IOwnable} from "./interfaces/IOwnable.sol";
import {console} from "forge-std/console.sol";
import {Vm} from "forge-std/Vm.sol";
import {ERC1967Utils} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Utils.sol";

contract TransferProxyAdminScript is Script {
    // Storage slot for admin implementation (EIP-1967)
    bytes32 private constant ADMIN_SLOT = 0xb53127684a568b3173ae13b9f8a6016e243e63b6e8ee1178d6a717850b5d6103;

    struct JsonInput {
        address[] proxyAddresses;
        address newOwner;
    }

    function setUp() public {}

    function run() public {
        // Read JSON input
        string memory root = vm.projectRoot();
        string memory path = string.concat(root, "/script/input.json");
        string memory json = vm.readFile(path);
        JsonInput memory input = abi.decode(vm.parseJson(json), (JsonInput));
        
        require(input.newOwner != address(0), "New owner cannot be zero address");
        require(input.proxyAddresses.length > 0, "No proxy addresses provided");

        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        for (uint256 i = 0; i < input.proxyAddresses.length; i++) {
            address proxy = input.proxyAddresses[i];
            
            // Get admin address from storage slot
            bytes32 adminSlotData;
            assembly {
                adminSlotData := sload(ADMIN_SLOT)
            }
            address adminProxy = address(uint160(uint256(adminSlotData)));
            
            // Transfer ownership of admin contract
            IOwnable(adminProxy).transferOwnership(input.newOwner);
            
            console.log("Transferred ownership of admin contract at", adminProxy);
            console.log("for proxy", proxy);
            console.log("to new owner", input.newOwner);
            console.log("---");
        }

        vm.stopBroadcast();
    }
} 