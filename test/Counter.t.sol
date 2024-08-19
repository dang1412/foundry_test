// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {Counter} from "../src/Counter.sol";

contract CounterTest is Test {
    Counter public counter;

    function setUp() public {
        counter = new Counter();
        counter.setNumber(0);
    }

    function test_Increment() public {
        counter.increment();
        assertEq(counter.number(), 1);
    }

    function testFuzz_SetNumber(uint256 x) public {
        counter.setNumber(x);
        assertEq(counter.number(), x);
    }

    function test_CallContract() public {
        address calleeAddress = 0x64192819Ac13Ef72bF6b5AE239AC672B43a9AF08;
        (bool success, bytes memory data) = calleeAddress.call(
            // abi.encodeWithSignature("checkThreshold(uint256)", 0)
            // abi.encodeWithSignature("paused()")
            abi.encodeWithSignature("depositCount()")
        );

        uint256 result = abi.decode(data, (uint256));

        assertEq(result, 92277);
    }

// function submitWithdrawal(Transfer.Receipt calldata _receipt, Signature[] calldata _signatures) external virtual whenNotPaused returns (bool _locked) {
//     return _submitWithdrawal(_receipt, _signatures);
//   }
    function test_AttackRonin() public {
        address calleeAddress = 0x64192819Ac13Ef72bF6b5AE239AC672B43a9AF08;
        (bool success, bytes memory data) = calleeAddress.call(
            // abi.encodeWithSignature("checkThreshold(uint256)", 0)
            // abi.encodeWithSignature("paused()")
            abi.encodeWithSignature("depositCount()")
        );
    }
}
