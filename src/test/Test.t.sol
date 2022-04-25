// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;

import "ds-test/test.sol";
import "./interfaces/CheatCodes.t.sol";
import "../MetaFashion.sol";

abstract contract Test is DSTest, IERC721Receiver {
    string internal constant _URI = "https://metafashionhq.io/";
    bytes32 internal constant _VIP_MERKLE_ROOT = 
        0x7c9a6bf3de43ef03c24f3fffbe0a5a52057670d5f03702b6d753b13f4a584451;

    MetaFashion internal _contract = new MetaFashion(_VIP_MERKLE_ROOT, "https://placeholder.metafashionhq.io/");
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