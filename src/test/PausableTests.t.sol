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

   function testCannotTransferTokenWhenPaused() public {

        assertTrue(_contract.paused());
        _contract.unpause();
        _contract.setPhase(MetaFashion.Phase.Public); // Enable public to mint a token for transfer

        address a = address(1);
        _cheatCodes.deal(a, 0.085 ether);
        _cheatCodes.prank(a);
        _contract.publicMint{value: 0.085 ether}(1);

        _contract.pause();
        assertTrue(_contract.paused());

        address b = address(2);
        _cheatCodes.prank(a);
        _cheatCodes.expectRevert(ContractPaused.selector);
        _contract.transferFrom(a, b, 1);
   }
}