// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;

import "./Test.t.sol";

contract VIPMintTests is Test  {

    uint256 private constant _PRICE = 0.075 ether;
    bytes32[] private _proof = new bytes32[](2);

    function setUp() public {
        _contract.unpause();
        _contract.setPhase(MetaFashion.Phase.VIP);

        // Initialise merkle proof for mint address
        _proof[0] = 0x5b70e80538acdabd6137353b0f9d8d149f4dba91e8be2e7946e409bfdbe685b9;
        _proof[1] = 0xd52688a8f926c816ca1e079067caba944f158e764817b83fc43594370ca9cf62;
    }

    function testCannotMintWhenPaused() public {
        _contract.pause();
        _cheatCodes.expectRevert("Pausable: paused");
        _contract.vipMint(1, new bytes32[](0));
    }

    function testCannotMintWhenVIPMintingInactive() public {
        _contract.setPhase(MetaFashion.Phase.None);

        _cheatCodes.expectRevert(VIPMintInactive.selector);
        _contract.vipMint(1, new bytes32[](0));
    }

    function testCannotMintWhenQuantityExceedsMaxMint() public {
        _cheatCodes.expectRevert(TransactionMintLimitExceeded.selector);
        _contract.vipMint(4, new bytes32[](0));
    }

    function testCannotMintWhenIncorrectValueSent() public {
        _cheatCodes.expectRevert(IncorrectValue.selector);
        _contract.vipMint(3, new bytes32[](0));
    }

    function testCannotExceedCollectionSize() public {
        _contract.setCollectionSize(2);
        
        _cheatCodes.deal(address(1), 3 * _PRICE);
        _cheatCodes.prank(address(1));

        _cheatCodes.expectRevert(InsufficientSupply.selector);
        _contract.vipMint{value: 3 * _PRICE}(3, _proof);
    }

    function testCannotMintZeroQuantity() public {
        _cheatCodes.prank(address(1));
        _cheatCodes.expectRevert(MintZeroQuantity.selector);
        _contract.vipMint(0, _proof);
    }

    function testCannotMintWhenNotOnVIPList() public {
        _cheatCodes.prank(address(10));
        _cheatCodes.expectRevert(NotVIP.selector);
        _contract.vipMint(0, _proof);
    }

    function testCannotMintMoreThanOnce() public {
        // Fund address and mint max
        uint256 value = 3 * _PRICE;
        address addr = address(1);
        _cheatCodes.deal(addr, value * 2);
        _cheatCodes.startPrank(addr);
        _contract.vipMint{value: value}(3, _proof);

        // Attempt a second mint
        _cheatCodes.expectRevert(TransactionLimitExceeded.selector);
        _contract.vipMint{value: value}(3, _proof);
    }

    function testMint(uint8 quantity) public {
        _cheatCodes.assume(quantity > 0 && quantity < 4);
        address addr = address(1);

        // Fund address and mint max
        uint256 value = quantity * _PRICE;
        _cheatCodes.deal(addr, value);
        _cheatCodes.prank(addr);
        _contract.vipMint{value: value}(quantity, _proof);
        assertEq(_contract.balanceOf(addr), quantity);
        assertEq(addr.balance, 0);

        // Ensure contract updated
        assertEq(_contract.totalSupply(), quantity);
        assertEq(address(_contract).balance, value);
    }
}