// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;

import "./Test.t.sol";

contract GiveawayMintTests is Test  {

    uint256 private constant _PRICE = 0.075 ether;
    bytes32[] private _proof = new bytes32[](2);

    function setUp() public {
        _contract.unpause();
        _contract.setPhase(MetaFashion.Phase.VIP);
    }

    function testCannotMintWhenPaused() public {
        _contract.pause();
        _cheatCodes.expectRevert("Pausable: paused");
        _contract.publicMint(1);
    }

    function testCannotMintWhenVIPMintingInactive() public {
        _contract.setPhase(MetaFashion.Phase.None);

        _cheatCodes.expectRevert(VIPMintInactive.selector);
        _contract.giveawayMint();
    }

    function testCannotExceedCollectionSize() public {
        _contract.setCollectionSize(99);
        _cheatCodes.expectRevert(InsufficientSupply.selector);
        _contract.giveawayMint();
    }

    function testCannotMintMoreThanOnce() public {
        _contract.giveawayMint();
        assertEq(_contract.totalSupply(), 100);

        // Attempt a second mint
        _cheatCodes.expectRevert(TransactionLimitExceeded.selector);
        _contract.giveawayMint();
    }

    function testMint() public {
        assertEq(_contract.totalSupply(), 0);
        _contract.giveawayMint();
        assertEq(_contract.balanceOf(_contract.COMMUNITY_WALLET()), 100);

        // Ensure contract updated
        assertEq(_contract.totalSupply(), 100);
        assertEq(address(_contract).balance, 0);
    }
}