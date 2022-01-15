// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IMSLibrary{
    function MSSecret(uint256 param1, uint256 param2, address param3, uint256 param4)  view external returns(bytes32);
    function recoverEx(bytes32 hash, bytes memory signature) external pure returns (address);
    function recover( bytes32 hash, uint8 v, bytes32 r, bytes32 s ) external pure returns (address) ;
}