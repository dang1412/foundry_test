// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";

import "../src/lib/LibTokenOwner.sol";

contract TokenOwnerHashTest is Test {
    function test_hash() pure public {
        TokenOwner memory info = TokenOwner({
            addr: 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266,
            tokenAddr: 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2,
            chainId: 1
        });

        bytes32 h = LibTokenOwner.hash(info);
        assertEq(h, 0xa7680efcbbbc97fe73c539a47782dcb8a0e55a6b8a94c85cd52625244d201e62);
    }
}
