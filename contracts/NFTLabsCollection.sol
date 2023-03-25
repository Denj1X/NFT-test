// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

//STEP1: create the contract that inherits ERC721 and Ownable
contract NFTLabsCollection is ERC721, Ownable {
    using Strings for uint256;

    string public baseURI;

    event BaseURIChanged(string _newBaseURI);

    //STEP2: CONSTRUCTOR WITH NAME AND SYMBOL + TESTS
    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}

    //STEP3: MINT AND BURN FUNCTION + TESTS
    function mint(address _to, uint256 _tokenId) external onlyOwner {
        _mint(_to, _tokenId);
    }

    function burn(uint256 _tokenId) external onlyOwner {
        _burn(_tokenId);
    }

    
    //STEP4: IMPLEMENT BASE_URI (declare as variable in our contract, create a get function and set function) + TESTS
    function _baseURI() internal view override returns (string memory) {
        return baseURI;
    }

    function setBaseURI(string calldata _newBaseURI) external onlyOwner{
        baseURI = _newBaseURI;
        emit BaseURIChanged(_newBaseURI);
    }

    //STEP5: METADATA: create a folder and add 4 jsons
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        _requireMinted(tokenId);

        string memory cachedBaseURI = _baseURI();
        return bytes(cachedBaseURI).length > 0 ? string(abi.encodePacked(cachedBaseURI, tokenId.toString(), ".json")) : "";
    }

}