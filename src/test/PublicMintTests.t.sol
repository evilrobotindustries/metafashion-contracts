// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;

import "./Test.t.sol";

contract PublicMintTests is Test  {

    uint256 private constant _PRICE = 0.085 ether;

    function setUp() public {
        _contract.unpause();
        _contract.setPhase(MetaFashion.Phase.Public);
    }

    function testCannotMintWhenPaused() public {
        _contract.pause();
        _cheatCodes.expectRevert("Pausable: paused");
        _contract.publicMint(1);
    }

    function testCannotMintUntilPublicMintActive() public {
        _contract.setPhase(MetaFashion.Phase.None);

        _cheatCodes.expectRevert(PublicMintInactive.selector);
        _contract.publicMint(1);
    }

    function testQuantityCannotExceedMaxMint() public {
        _cheatCodes.expectRevert(TransactionMintLimitExceeded.selector);
        _contract.publicMint(6);
    }

    function testCannotMintWhenIncorrectValueSent() public {
        _cheatCodes.expectRevert(IncorrectValue.selector);
        _contract.publicMint(5);
    }

    function testCannotExceedCollectionSize() public {
        
        _contract.setCollectionSize(2);

        // Fund address
        _cheatCodes.deal(address(1), 3 * _PRICE);
        _cheatCodes.prank(address(1));
        _cheatCodes.expectRevert(InsufficientSupply.selector);
        _contract.publicMint{value: 3 * _PRICE}(3);
    }

    function testCannotExceedTransactionLimit() public {
        uint256 value = 5 * _PRICE;
        _contract.publicMint{value: value}(5);
        _contract.publicMint{value: value}(5);
        _contract.publicMint{value: value}(5);

        _cheatCodes.expectRevert(TransactionLimitExceeded.selector);
        _contract.publicMint{value: value}(5); 
    }

    function testCannotMintZeroQuantity() public {
        _cheatCodes.expectRevert(MintZeroQuantity.selector);
        _contract.publicMint(0);
    }

    /// @dev Use forge fuzz testing to test using random addresses
    function testMint(uint160 mintAddress, uint8 quantity) public {
        // Zero and contract address cannot mint
        _cheatCodes.assume(mintAddress > 0 && mintAddress != uint160(address(_contract)));
        _cheatCodes.assume(quantity > 0 && quantity < 6);

        // Fund address
        address addr = address(mintAddress);
        _cheatCodes.deal(addr, quantity * _PRICE); 
        
        // Mint as address, sending required value and checking balance
        _cheatCodes.prank(addr);
        uint256 value = quantity * _PRICE;
        _contract.publicMint{value: value}(quantity);
        assertEq(addr.balance, 0);

        // Ensure contract updated
        assertEq(_contract.totalSupply(), quantity);
        assertEq(address(_contract).balance, value);
    }

    /// @dev Use forge fuzz testing to test using random addresses
    function testMaxPublicMintTransactions(uint160 mintAddress) public {
        // Zero and contract address cannot mint
        _cheatCodes.assume(mintAddress > 0 && mintAddress != uint160(address(_contract))); 

        // Fund address
        address addr = address(mintAddress);
        _cheatCodes.deal(addr, 3 * 5 * 0.085 ether);

        // Mint as address, sending required value and checking balance
        uint256 value = 5 * _PRICE;
        _cheatCodes.startPrank(addr);
        _contract.publicMint{value: value}(5);
        _contract.publicMint{value: value}(5);
        _contract.publicMint{value: value}(5);
        assertEq(_contract.balanceOf(addr), 15);
        assertEq(addr.balance, 0);

        // Ensure contract updated
        assertEq(_contract.totalSupply(), 15);
        assertEq(address(_contract).balance, 3 * value);
    }
}