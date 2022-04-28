// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;

import "../Test.t.sol";

contract PublicMintCosts is Test  {

    uint256 private constant _PRICE = 0.085 ether;
    address private constant _MINT_ADDRESS = address(1);

    function setUp() public {
        _contract.unpause();
        _contract.setPhase(MetaFashion.MintPhase.Public);

        // Fund address
        _cheatCodes.deal(_MINT_ADDRESS, 10 ether); 
    }

    function testMint1() public { mint(1); }

    function testMint2() public { mint(2); }

    function testMint3() public { mint(3); }

    function testMint4() public { mint(4); }

    function testMint5() public { mint(5); }

    function mint(uint8 quantity) public {       
        _cheatCodes.prank(_MINT_ADDRESS);
        uint256 value = quantity * _PRICE;
        _contract.publicMint{value: value}(quantity);
    }
}