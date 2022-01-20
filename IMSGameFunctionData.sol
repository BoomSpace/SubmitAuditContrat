// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IMSGameFunctionData {
    function getOpenBBXBySpaceFeeRate() external view returns(uint8);
    function getopenBlindboxBeginTime() external view  returns(uint64);
    function getopenBlindBoxEndTime() external view  returns(uint64);
    function getopenBlindBoxMaxCnt_lv1() external view  returns(uint256);
    function getopenBlindBoxCurCnt_lv1() external view  returns(uint256);
    function getopenBlindBoxMaxCnt_lv2() external view  returns(uint256);
    function getopenBlindBoxCurCnt_lv2() external view  returns(uint256);
    function getopenBlindBoxAllInfo() external view returns(uint8,uint64,uint64,uint256,uint256,uint256,uint256,uint256,uint256,uint256);
    function getVaultAddress() external view returns(address);
    function getOpenBlindBoxBySpacePrice_lv1() external view returns(uint256);
    function getOpenBlindBoxBySpacePrice_lv2() external view returns(uint256);    
    function GetOverTimeBlockCnt() external view  returns(uint256);
    function IsOpenBlindBoxDisable(uint8 lv) external view returns(bool);
    function AddOpenllBlindBoxCntCur(uint8 lv) external;
}