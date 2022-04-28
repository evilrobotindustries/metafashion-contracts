pragma solidity 0.8.9;

import "../MetaFashion.sol";

abstract contract PropertyTests is MetaFashion {

    string internal constant _URI = "https://metafashionhq.io/";
    bytes32 internal constant _VIP_MERKLE_ROOT = 
        0x7c9a6bf3de43ef03c24f3fffbe0a5a52057670d5f03702b6d753b13f4a584451;
    
    constructor() payable MetaFashion(_VIP_MERKLE_ROOT, _URI) { }
}

contract OwnerTests is PropertyTests {
    constructor() payable {
        renounceOwnership();
    }

    function echidnaCannoMint() public view returns(bool){
        return _totalMinted() == 0;
    }

    function echidnaCannotUnpause() public view returns(bool){
        // Contract remains paused
        return paused();
    }

    function echidnaCannotSetBaseURI() public view returns(bool){
        // base URI value remains as initialised
        return keccak256(bytes(_baseURI())) == keccak256(bytes(_URI));
    }

    function echidnaCannotSetMaxSupply() public view returns(bool){
        // max supply remains as initialised 
        return maxSupply == 10000;
    }

    function echidnaCannotSetPhase() public view returns(bool){
        // phase remains as initialised
        return phase == MetaFashion.MintPhase.None;
    }

    function echidnaCannotSetVIPMerkleRoot() public view returns(bool){
        // VIP merkle root remains as initialised
        return vipMerkleRoot == _VIP_MERKLE_ROOT;
    }

    function echidnaCannotWithdraw() public view returns(bool){
        // balance remains as initialised 
        return address(this).balance == 1 ether; // See config
    }

    function echidnaCannotChangeStartTokenId() public pure returns(bool){
        // start token remains as one 
        return _startTokenId() == 1;
    }
}

contract MintTests is PropertyTests {
    constructor() payable { }

    function echidnaCannotExceedMaxSupply() public view returns(bool){
        return _totalMinted() <= maxSupply;
    }

    function echidnaCannotExceedMaxMint() public view returns(bool){
         return balanceOf(address(_msgSender())) <= 18; // 3 VIP + 15 Public
    }

    function echidnaCannotExceedGiveawayMint() public view returns(bool){
        return balanceOf(COMMUNITY_WALLET) <= 100;
    }

    function echidnaCannotExceedPublicTransactionLimit() public view returns(bool){
         return _getAux(address(_msgSender())) <= 3;
    }
}