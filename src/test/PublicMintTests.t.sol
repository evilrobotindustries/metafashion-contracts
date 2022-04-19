// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "./Test.t.sol";

contract PublicMintTests is Test  {

    uint256 private constant _PRICE = 0.085 ether;

    function setUp() public {
        _contract.unpause();
        _contract.setPhase(MetaFashion.Phase.Public);
    }

    function testCannotMintUntilPublicMintActive() public {
        _contract.setPhase(MetaFashion.Phase.Paused);

        _cheatCodes.expectRevert(PublicMintInactive.selector);
        _contract.publicMint(1);
    }

    function testQuantityCannotExceedMaxMint() public {
        _cheatCodes.expectRevert(TransactionMintLimitExceeded.selector);
        _contract.publicMint(6);
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

    function testCannotMintWhenIncorrectValueSent() public {
        _cheatCodes.expectRevert(IncorrectValue.selector);
        _contract.publicMint(5);
    }

    function testCannotExceedCollectionSize() public {
        uint256 value = 5 * _PRICE;

        // Mint until collection size exceeded
        for (uint160 a = 1; a <= 10000 / 5; a++){
            // Fund address
            address addr = address(a);
            _cheatCodes.deal(addr, 5 * _PRICE);
            _cheatCodes.prank(addr);
            _contract.publicMint{value: value}(5);
        }

        assertEq(_contract.totalSupply(), 10000);

        // Fund address
        _cheatCodes.deal(address(1), 3 * _PRICE);
        _cheatCodes.prank(address(1));
        _cheatCodes.expectRevert(InsufficientSupply.selector);
        _contract.publicMint{value: 3 * _PRICE}(3);
    }

    /// @dev Use forge fuzz testing to test using random addresses
    function testMint1(uint160 mintAddress) public { mint(mintAddress, 1); }

    /// @dev Use forge fuzz testing to test using random addresses
    function testMint2(uint160 mintAddress) public { mint(mintAddress, 2); }

    /// @dev Use forge fuzz testing to test using random addresses
    function testMint3(uint160 mintAddress) public { mint(mintAddress, 3); }

    /// @dev Use forge fuzz testing to test using random addresses
    function testMint4(uint160 mintAddress) public { mint(mintAddress, 4); }

    /// @dev Use forge fuzz testing to test using random addresses
    function testMint5(uint160 mintAddress) public { mint(mintAddress, 5); }

    /// @dev Use forge fuzz testing to test using random addresses
    function mint(uint160 mintAddress, uint8 quantity) public {
        _cheatCodes.assume(mintAddress > 0); // Zero address cannot mint

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
        _cheatCodes.assume(mintAddress > 0); // Zero address cannot mint

        // Fund address
        address addr = address(mintAddress);
        _cheatCodes.deal(addr, 3 * 5 * 0.085 ether);

        // Mint as address, sending required value and checking balance
        uint256 value = 5 * _PRICE;
        _cheatCodes.startPrank(addr);
        _contract.publicMint{value: value}(5);
        _contract.publicMint{value: value}(5);
        _contract.publicMint{value: value}(5);
        assertEq(addr.balance, 0);

        // Ensure contract updated
        assertEq(_contract.totalSupply(), 15);
        assertEq(address(_contract).balance, 3 * value);
    }
}