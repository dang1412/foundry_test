// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./LibTokenInfo.sol";
import "./LibTokenOwner.sol";

library Transfer {
  using LibTokenOwner for TokenOwner;
  using LibTokenInfo for TokenInfo;

  enum Kind {
    Deposit,
    Withdrawal
  }

  struct Receipt {
    uint256 id;
    Kind kind;
    TokenOwner mainchain;
    TokenOwner ronin;
    TokenInfo info;
  }

  // keccak256("Receipt(uint256 id,uint8 kind,TokenOwner mainchain,TokenOwner ronin,TokenInfo info)TokenInfo(uint8 erc,uint256 id,uint256 quantity)TokenOwner(address addr,address tokenAddr,uint256 chainId)");
  bytes32 public constant TYPE_HASH = 0xb9d1fe7c9deeec5dc90a2f47ff1684239519f2545b2228d3d91fb27df3189eea;

  /**
   * @dev Returns token info struct hash.
   */
  function hash(Receipt memory _receipt) internal pure returns (bytes32 digest) {
    bytes32 hashedReceiptMainchain = _receipt.mainchain.hash();
    bytes32 hashedReceiptRonin = _receipt.ronin.hash();
    bytes32 hashedReceiptInfo = _receipt.info.hash();

    /*
     * return
     *   keccak256(
     *     abi.encode(
     *       TYPE_HASH,
     *       _receipt.id,
     *       _receipt.kind,
     *       Token.hash(_receipt.mainchain),
     *       Token.hash(_receipt.ronin),
     *       Token.hash(_receipt.info)
     *     )
     *   );
     */
    assembly {
      let ptr := mload(0x40)
      mstore(ptr, TYPE_HASH)
      mstore(add(ptr, 0x20), mload(_receipt)) // _receipt.id
      mstore(add(ptr, 0x40), mload(add(_receipt, 0x20))) // _receipt.kind
      mstore(add(ptr, 0x60), hashedReceiptMainchain)
      mstore(add(ptr, 0x80), hashedReceiptRonin)
      mstore(add(ptr, 0xa0), hashedReceiptInfo)
      digest := keccak256(ptr, 0xc0)
    }
  }

  /**
   * @dev Returns the receipt digest.
   */
  function receiptDigest(bytes32 _domainSeparator, bytes32 _receiptHash) internal pure returns (bytes32) {
    return toTypedDataHash(_domainSeparator, _receiptHash);
  }

  /**
   * @dev Returns an Ethereum Signed Typed Data, created from a
   * `domainSeparator` and a `structHash`. This produces hash corresponding
   * to the one signed with the
   * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
   * JSON-RPC method as part of EIP-712.
   *
   * See {recover}.
   */
  function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
    return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
  }
}
