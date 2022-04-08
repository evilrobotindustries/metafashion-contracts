// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "./Test.t.sol";

contract PausableTests is Test {

    function testPausedInitially() public {
        assertTrue(_contract.paused());
    }

    function testPauses() public {
        _contract.unpause(); // Unpause, as paused initially
        assertTrue(!_contract.paused());

        _contract.pause();
        assertTrue(_contract.paused());
    }

    function testUnpauses() public {
        assertTrue(_contract.paused());

        _contract.unpause();
        assertTrue(!_contract.paused());
    }

    function testCannotPauseWhenAlreadyPaused() public {
        assertTrue(_contract.paused());
        _cheatCodes.expectRevert("Pausable: paused");
        _contract.pause();
    }

    function testCannotUnpauseWhenAlreadyUnpaused() public {
        assertTrue(_contract.paused());
        _contract.unpause();

        _cheatCodes.expectRevert("Pausable: not paused");
        _contract.unpause();
    }

//    function testCannotTransferTokenWhenPaused() public {
//        address a = address(1);
//        address b = address(2);
//        _contract.transferFrom(a, b, 1);
//    }
}