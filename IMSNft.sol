// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IMSNft {
    function msIsApprovedForAll(address owner, address operator) external view  returns (bool);
    function msMint(address recipient) external returns (uint256);
    function msMintArray(address recipient, uint256 amount) external returns (uint256[] memory);
    function msGetOwner(uint256 MSNftID) view external returns(address);
    function msTransferFrom(address sender,address recipient, uint256 tokenId) external returns (bool);
    function msIsExists(uint256 tokenId) external view returns(bool);
    function msGetBalanceOf(address owner) external view returns(uint256);    
}

