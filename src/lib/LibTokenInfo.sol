// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

enum TokenStandard {
  ERC20,
  ERC721,
  ERC1155
}

struct TokenInfo {
  TokenStandard erc;
  // For ERC20:  the id must be 0 and the quantity is larger than 0.
  // For ERC721: the quantity must be 0.
  uint256 id;
  uint256 quantity;
}

library LibTokenInfo {
  /**
   *
   *        HASH
   *
   */

  // keccak256("TokenInfo(uint8 erc,uint256 id,uint256 quantity)");
  bytes32 public constant INFO_TYPE_HASH_SINGLE = 0x1e2b74b2a792d5c0f0b6e59b037fa9d43d84fbb759337f0112fcc15ca414fc8d;

  /**
   * @dev Returns token info struct hash.
   */
  function hash(TokenInfo memory self) internal pure returns (bytes32 digest) {
    // keccak256(abi.encode(INFO_TYPE_HASH_SINGLE, info.erc, info.id, info.quantity))
    assembly ("memory-safe") {
      let ptr := mload(0x40)
      mstore(ptr, INFO_TYPE_HASH_SINGLE)
      mstore(add(ptr, 0x20), mload(self)) // info.erc
      mstore(add(ptr, 0x40), mload(add(self, 0x20))) // info.id
      mstore(add(ptr, 0x60), mload(add(self, 0x40))) // info.quantity
      digest := keccak256(ptr, 0x80)
    }
  }
}
