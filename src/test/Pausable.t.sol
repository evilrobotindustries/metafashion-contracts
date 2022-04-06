// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "../../lib/ds-test/src/test.sol";
import "../Contract.sol";

interface CheatCodes {
    // Expects an error on next call
    function expectRevert() external;
    function expectRevert(bytes calldata) external;
    function expectRevert(bytes4) external;

    // Sets the *next* call's msg.sender to be the input address
    function prank(address) external;
}

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
        cheats.expectRevert(abi.encodeWithSignature("Panic(uint256)", 0x11));
        _contract.pause();
    }

    function testFailPauseAsNotOwner() public {
        cheats.prank(address(0));
        _contract.pause();
    }

    function testFailUnpauseAsNotOwner() public {
        cheats.prank(address(0));
        _contract.unpause();
    }
}

contract PausableTests is DSTest {
    MetaFashion _contract;

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

    function testFailWhenAlreadyPaused() public {
        assertTrue(_contract.paused());
        _contract.pause();
    }
}