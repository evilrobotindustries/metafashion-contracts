// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.10;

import "../../lib/ds-test/src/test.sol";
import "./interfaces/CheatCodes.t.sol";
import "../MetaFashion.sol";
import "../../lib/openzeppelin-contracts/contracts/token/ERC721/IERC721Receiver.sol";
import "../MetaFashion.sol";

contract ERC721Tests is DSTest, IERC721Receiver  {
    MetaFashion _contract;
    CheatCodes cheats = CheatCodes(HEVM_ADDRESS);

    string constant URI = "https://metafashionhq.io/";
    bytes32 constant VIP_MERKLE_ROOT = bytes32(bytes("as9d87sad98as7d98sa7d"));

    function setUp() public {
        _contract = new MetaFashion(VIP_MERKLE_ROOT);
    }

    function testName() public {
        assertEq("MetaFashion", _contract.name());
    }

    function testSymbol() public {
        assertEq("MFHQ", _contract.symbol());
    }



    function testSetBaseURI() public {
        _contract.setBaseURI(URI);

        // Mint a token and then check the uri
        _contract.unpause();
        _contract.publicMint(1);

        assertEq(string(abi.encodePacked(URI, "1")), _contract.tokenURI(1));
    }

    function testPublicMint() public {
        _contract.unpause();
        _contract.publicMint(1);
    }

    function testVIPMint() public {
        _contract.unpause();
        _contract.setContractStatus(MetaFashion.ContractStatus.VIPOnly);
        bytes32[] memory proof = new bytes32[](1);
        proof[0] = bytes32(bytes("as9d87sad98as7d98sa7d"));
        _contract.vipMint(1, proof);
    }


    // Required for safe mint
    function onERC721Received(
        address,
        address,
        uint256,
        bytes calldata
    ) external pure returns(bytes4) {
        return bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"));
    }
}