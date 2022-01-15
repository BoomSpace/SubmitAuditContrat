// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./IMSNft.sol";

contract MSNft is IMSNft, ERC721, AccessControl {

    bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");
    uint256 lastNFTID;

    constructor (string memory name_, string memory symbol_) 
                ERC721(name_, symbol_)
    {
        lastNFTID = 0;
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    function msIsApprovedForAll(address owner, address operator) external view  override returns (bool) {
        return isApprovedForAll(owner, operator);
    }

    function msTransferFrom(address sender,address recipient, uint256 tokenId) override external returns (bool){
        transferFrom( sender, recipient,  tokenId);
        return true;
    }
    
    function msMint(address recipient) override external returns (uint256){
        require(hasRole(OPERATOR_ROLE, _msgSender()), "Caller is not a operator");
        _safeMint(recipient, ++lastNFTID);
        return lastNFTID;
    }

    function msMintArray(address recipient, uint256 amount) override external returns (uint256[] memory){
        require(hasRole(OPERATOR_ROLE, _msgSender()), "Caller is not a operator");
        uint256[] memory idArray;
        idArray = new uint256[](amount);
        for (uint256 i = 0; i < amount; i++)
        {
            _safeMint(recipient, ++lastNFTID);
            idArray[i] = lastNFTID;
        }
        return idArray;
    }    

    function msIsExists(uint256 tokenId) override external view returns(bool){
        return _exists(tokenId);
    }

    function msGetBalanceOf(address owner) override external view returns(uint256){
        return balanceOf(owner);
    }

    function msGetOwner(uint256 MSNftID) override view external returns(address)
    {
        return ownerOf(MSNftID);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, AccessControl) returns (bool) {
        return
            interfaceId == type(IERC721).interfaceId ||
            interfaceId == type(IERC721Metadata).interfaceId ||
            interfaceId == type(IAccessControl).interfaceId ||
            super.supportsInterface(interfaceId);
    }
}