// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.9;

import "../Test.t.sol";

contract VIPMintCosts is Test  {

    uint256 private constant _PRICE = 0.075 ether;
    address private constant _MINT_ADDRESS = address(1);
    bytes32[] private _proof = new bytes32[](2);

    function setUp() public {
        _contract.unpause();
        _contract.setPhase(MetaFashion.MintPhase.VIP);

        // Fund address
        _cheatCodes.deal(_MINT_ADDRESS, 10 ether);

        // Initialise merkle proof for mint address
        _proof[0] = 0x5b70e80538acdabd6137353b0f9d8d149f4dba91e8be2e7946e409bfdbe685b9;
        _proof[1] = 0xd52688a8f926c816ca1e079067caba944f158e764817b83fc43594370ca9cf62;
    }

    function testMint1() public { mint(1); }

    function testMint2() public { mint(2); }

    function testMint3() public { mint(3); }

    function mint(uint8 quantity) public {       
        _cheatCodes.prank(_MINT_ADDRESS);
        uint256 value = quantity * _PRICE;
        _contract.vipMint{value: value}(quantity, _proof);
    }
}