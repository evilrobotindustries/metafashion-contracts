// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "ds-test/test.sol";
import "./interfaces/CheatCodes.t.sol";
import "../MetaFashion.sol";

abstract contract Test is DSTest, IERC721Receiver {
    string internal constant _URI = "https://metafashionhq.io/";
    bytes32 private constant _VIP_MERKLE_ROOT = 
        bytes32(bytes("b90c58b99228b1eaec8a7bda81525372c7cfb225c12a85331dde5afce7a7ee63"));

    MetaFashion internal _contract = new MetaFashion(_VIP_MERKLE_ROOT);
    CheatCodes internal _cheatCodes = CheatCodes(HEVM_ADDRESS);

    // Required for safe mint
    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure returns(bytes4) {
        return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
    }

}