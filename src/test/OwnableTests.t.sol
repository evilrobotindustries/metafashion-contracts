// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "../../lib/ds-test/src/test.sol";
import "./interfaces/CheatCodes.t.sol";
import "../Contract.sol";

contract OwnableTests is DSTest {
    MetaFashion _contract;
    CheatCodes cheats = CheatCodes(HEVM_ADDRESS);

    function setUp() public {
        _contract = new MetaFashion();
    }

    function testPausedInitially() public {
        assertTrue(_contract.paused());
    }

    function testUnpauses() public {
        assertTrue(_contract.paused());
        _contract.unpause();
        assertTrue(!_contract.paused());
    }

    function testCannotPauseWhenAlreadyPaused() public {
        assertTrue(_contract.paused());
        cheats.expectRevert("Pausable: paused");
        _contract.pause();
    }

    function testCannotPauseAsNotOwner() public {
        cheats.prank(address(0));
        cheats.expectRevert("Ownable: caller is not the owner");
        _contract.pause();
    }

    function testCannotUnpauseAsNotOwner() public {
        cheats.prank(address(0));
        cheats.expectRevert("Ownable: caller is not the owner");
        _contract.unpause();
    }
}