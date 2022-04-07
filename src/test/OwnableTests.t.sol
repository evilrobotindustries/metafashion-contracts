// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "../../lib/ds-test/src/test.sol";
import "./interfaces/CheatCodes.t.sol";
import "../MetaFashion.sol";

contract OwnableTests is DSTest {
    MetaFashion _contract;
    CheatCodes cheats = CheatCodes(HEVM_ADDRESS);

    string constant URI = "https://metafashionhq.io/";
    bytes32 constant VIP_MERKLE_ROOT = bytes32(bytes("as9d87sad98as7d98sa7d"));

    function setUp() public {
        _contract = new MetaFashion(VIP_MERKLE_ROOT);
    }

    function testCannotPauseAsNonOwner() public {
        cheats.prank(address(0));
        cheats.expectRevert("Ownable: caller is not the owner");
        _contract.pause();
    }

    function testCannotUnpauseAsNonOwner() public {
        cheats.prank(address(0));
        cheats.expectRevert("Ownable: caller is not the owner");
        _contract.unpause();
    }

    function testCannotSetBaseURIAsNonOwner() public {
        cheats.prank(address(0));
        cheats.expectRevert("Ownable: caller is not the owner");
        _contract.setBaseURI(URI);
    }
}