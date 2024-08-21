// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "../src/lib/Transfer.sol";

contract TransferTest is Test {
    TokenOwner mainchain = TokenOwner({
        addr: 0xcf7eaaC7eE94261603e0600183EA2c739356cBf3,
        tokenAddr: 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2,
        chainId: 1
    });

    TokenOwner ronin = TokenOwner({
        addr: 0x03E1f309d281b0af1A17EBb29e89136c05b67206,
        tokenAddr: 0xc99a6A985eD2Cac1ef41640596C5A5f9F4E19Ef5,
        chainId: 2020
    });

    TokenInfo info = TokenInfo({
        erc: TokenStandard.ERC20,
        id: 0,
        quantity: 3996093750000000000000
    });

    Transfer.Receipt receipt = Transfer.Receipt({
        id: 166631,
        kind: Transfer.Kind.Withdrawal,
        mainchain: mainchain,
        ronin: ronin,
        info: info
    });

    function test_hash() view public {
        bytes32 h = Transfer.hash(receipt);
        assertEq(h, 0xb577a130c54d89c4227872ae7413a1e8d76a3eedac8c5e8ba15e30b62cd8ca43);
    }

    function test_digest() pure public {
        bytes32 separator = 0x2b00d883a78a8b8d324cfe3cc451d9550b8509512a316b5dba270df178853071;
        bytes32 receiptHash = 0xb577a130c54d89c4227872ae7413a1e8d76a3eedac8c5e8ba15e30b62cd8ca43;

        bytes32 digest = Transfer.receiptDigest(separator, receiptHash);

        assertEq(digest, 0x2bfcedc9e24cb6e217f024e126af3c5bdd0647096d00f4aeb6a5b5cd9df979c6);
    }

    struct Signature {
        uint8 v;
        bytes32 r;
        bytes32 s;
    }

    // function submitWithdrawal(Transfer.Receipt calldata _receipt, Signature[] calldata _signatures) external virtual returns (bool _locked) {
    //     return false;
    // }

    function test_RoninWithdraw() public {
        // check balance before
        address receiver = 0xcf7eaaC7eE94261603e0600183EA2c739356cBf3;
        assertEq(receiver.balance, 332360355140776000);

        address bridgeAddress = 0x64192819Ac13Ef72bF6b5AE239AC672B43a9AF08;

        uint8 v = 28;
        bytes32 r = 0xd44cf54b611a01d097b8315b1675dfecb9950b3cdaa71c65f233a84e87fe554b;
        bytes32 s = 0x2e5dfbd5d8a750a267bc7279c3944235453949684726bcd0755ef37bbf8f3777;

        Signature[] memory signatures = new Signature[](1);
        signatures[0] = Signature({v: v, r: r, s: s});
        (bool success, bytes memory data) = bridgeAddress.call(
            abi.encodeWithSignature(
                "submitWithdrawal((uint256,uint8,(address,address,uint256),(address,address,uint256),(uint8,uint256,uint256)),(uint8,bytes32,bytes32)[])",
                receipt,
                signatures
            )
        );

        bool result = abi.decode(data, (bool));
        assertEq(success, true);
        assertEq(result, false);

        // check balance after
        // IERC20 WETH = IERC20(0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2);
        // uint256 balance = WETH.balanceOf(receiver);
        assertEq(receiver.balance, 3996426110355140776000);
    }
}
