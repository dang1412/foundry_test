// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";

import "../src/lib/LibTokenInfo.sol";

contract TokenInfoHashTest is Test {
    function test_hash() pure public {
        TokenInfo memory info = TokenInfo({
            erc: TokenStandard.ERC20,
            id: 100,
            quantity: 1000
        });

        bytes32 h = LibTokenInfo.hash(info);
        assertEq(h, 0x7584d535c00d6ba6c434d717d41544757af5ee5e0849bfa1754b30749e2570c4);
    }
}
