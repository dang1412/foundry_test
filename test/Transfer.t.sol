// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";

import "../src/lib/Transfer.sol";

contract TransferTest is Test {
    TokenOwner mainchain = TokenOwner({
        addr: 0x4Ab12E7CE31857Ee022f273e8580F73335a73c0B,
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
        assertEq(h, 0x1e5e99eb46ee39b2e2c1debda52013111db220f0e57758c85696f8dd884b4937);
    }

    function test_digest() pure public {
        bytes32 separator = 0x2b00d883a78a8b8d324cfe3cc451d9550b8509512a316b5dba270df178853071;
        bytes32 receiptHash = 0x1e5e99eb46ee39b2e2c1debda52013111db220f0e57758c85696f8dd884b4937;

        bytes32 digest = Transfer.receiptDigest(separator, receiptHash);

        assertEq(digest, 0xd0281c1222b87dcf936168e477d7a4a6d494eba327cfa92514c60404cd55fc3f);
    }

    struct Signature {
        uint8 v;
        bytes32 r;
        bytes32 s;
    }

    function submitWithdrawal(Transfer.Receipt calldata _receipt, Signature[] calldata _signatures) external virtual returns (bool _locked) {
        return false;
    }

    function test_RoninWithdraw() public {
        // expect(sig.v).toBe(28)
        // expect(sig.r).toBe('0x0db2950001044871c82a0a0e4dc48121fe8fde654a092b6d6cd46ffc2a645deb')
        // expect(sig.s).toBe('0x2c9f1da40a4e166b061f174bd7ba4f2e487b9c2e92c9c1702f6b5da7fe99e835')
        address calleeAddress = 0x64192819Ac13Ef72bF6b5AE239AC672B43a9AF08;
        // Signature sig = Signature({});

        uint8 v = 28;
        bytes32 r = 0x897058e20ee89766649370ec29a43ddef9543d3923488eecaf6b04c26627b522;
        bytes32 s = 0x23e9fc3d539039e06e741b84c9fe2ad263c27fef5b63e85e86f2206acc6b2f6e;

        Signature[] memory signatures = new Signature[](1);
        signatures[0] = Signature({v: v, r: r, s: s});
        (bool success, bytes memory data) = calleeAddress.call(
            abi.encodeWithSignature(
                "submitWithdrawal((uint256,uint8,(address,address,uint256),(address,address,uint256),(uint8,uint256,uint256)),(uint8,bytes32,bytes32)[])",
                receipt,
                signatures
            )
        );

        bool result = abi.decode(data, (bool));
        assertEq(success, true);
        assertEq(result, true);
    }
}
