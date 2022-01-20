// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./IMSGameFunctionData.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract MSGameFunctionData is IMSGameFunctionData, Ownable, AccessControl {
    bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");
    using SafeMath for uint256;

    address     public vaultAddress;
    uint8       public openBBXBySpaceFeeRate;

    uint64      public openBlindboxBeginTime;
    uint64      public openBlindBoxEndTime;

    uint256     public openBlindBoxMaxCnt_lv1;
    uint256     public openBlindBoxCurCnt_lv1;

    uint256     public openBlindBoxMaxCnt_lv2;
    uint256     public openBlindBoxCurCnt_lv2;

    uint256     public openBlindBoxBySpacePrice_lv1;
    uint256     public openBlindBoxBySpacePrice_lv2;

    uint256     public overTimeBlockCnt;
    
    
    constructor(
    uint8 _openBBXBySpaceFeeRate, 

    uint256     _openBlindBoxMaxCnt_lv1,
    uint256     _openBlindBoxMaxCnt_lv2,

    uint256 _openBlindBoxBySpacePrice_lv1,
    uint256 _openBlindBoxBySpacePrice_lv2,
    address _vaultAddress, 
    uint256 _overTimeBlockCnt) {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        
        openBBXBySpaceFeeRate = _openBBXBySpaceFeeRate;

        openBlindboxBeginTime =0;
        openBlindBoxEndTime =0;
        
        openBlindBoxMaxCnt_lv1 =_openBlindBoxMaxCnt_lv1;
        openBlindBoxCurCnt_lv1 =0;
        
        openBlindBoxMaxCnt_lv2 =_openBlindBoxMaxCnt_lv2;
        openBlindBoxCurCnt_lv2 =0;

        openBlindBoxBySpacePrice_lv1 = _openBlindBoxBySpacePrice_lv1;
        openBlindBoxBySpacePrice_lv2 = _openBlindBoxBySpacePrice_lv2;

        vaultAddress = _vaultAddress;
        overTimeBlockCnt = _overTimeBlockCnt;
    }

    function setOpenBBXBySpaceFeeRate(uint8 FeeRate) onlyOwner() external {
        openBBXBySpaceFeeRate = FeeRate;
    }

    function setopenBlindboxBeginTime(uint64 _time) onlyOwner() external {
        openBlindboxBeginTime = _time;
    }

    function setopenBlindBoxEndTime(uint64 _time) onlyOwner() external {
        openBlindBoxEndTime = _time;
    }   

    function setopenBlindBoxMaxCnt_lv1(uint256 count) onlyOwner() external {
        openBlindBoxMaxCnt_lv1 = count;
    }   

    function setopenBlindBoxCurCnt_lv1(uint256 count) onlyOwner() external {
        openBlindBoxCurCnt_lv1 = count;
    }   
    
    function setopenBlindBoxMaxCnt_lv2(uint256 count) onlyOwner() external {
        openBlindBoxMaxCnt_lv2 = count;
    }   

    function setopenBlindBoxCurCnt_lv2(uint256 count) onlyOwner() external {
        openBlindBoxCurCnt_lv2 = count;
    }   

    function setVaultAddress(address vault) onlyOwner() external {
        vaultAddress = vault;
    }
    
    function setOpenBlindBoxBySpacePrice_lv1(uint256 price) onlyOwner() external{
        openBlindBoxBySpacePrice_lv1 = price;
    }

    function setOpenBlindBoxBySpacePrice_lv2(uint256 price) onlyOwner() external{
        openBlindBoxBySpacePrice_lv2 = price;
    }

    function setOverTimeBlockCnt(uint256 BlockCnt) onlyOwner() external{
        overTimeBlockCnt = BlockCnt;
    }

    function getOpenBBXBySpaceFeeRate() override external view returns(uint8) {
        return openBBXBySpaceFeeRate;
    }

    function getopenBlindboxBeginTime() override external view  returns(uint64) {
        return openBlindboxBeginTime;
    }

    function getopenBlindBoxEndTime() override external view  returns(uint64) {
        return openBlindBoxEndTime;
    }   

    function getopenBlindBoxMaxCnt_lv1() override external view  returns(uint256) {
        return openBlindBoxMaxCnt_lv1;
    }   

    function getopenBlindBoxCurCnt_lv1() override external view  returns(uint256) {
        return openBlindBoxCurCnt_lv1;
    }   
    
    function getopenBlindBoxMaxCnt_lv2() override external view  returns(uint256) {
        return openBlindBoxMaxCnt_lv2;
    }   

    function getopenBlindBoxCurCnt_lv2() override external view  returns(uint256) {
        return openBlindBoxCurCnt_lv2;
    }   
    
    function getVaultAddress() override external view returns(address) {
        return vaultAddress;
    }
    
    function getOpenBlindBoxBySpacePrice_lv1() override external view returns(uint256){
        return openBlindBoxBySpacePrice_lv1;
    }

    function getOpenBlindBoxBySpacePrice_lv2() override external view returns(uint256){
        return openBlindBoxBySpacePrice_lv2;
    }

    function getopenBlindBoxAllInfo() override external view returns(uint8,uint64,uint64,uint256,uint256,uint256,uint256,uint256,uint256,uint256)
    {
        return (openBBXBySpaceFeeRate,
        openBlindboxBeginTime,
        openBlindBoxEndTime,
        block.timestamp,
        openBlindBoxMaxCnt_lv1,
        openBlindBoxCurCnt_lv1,
        openBlindBoxMaxCnt_lv2,
        openBlindBoxCurCnt_lv2,
        openBlindBoxBySpacePrice_lv1,
        openBlindBoxBySpacePrice_lv2);
    }
    
    function GetOverTimeBlockCnt()  override external view  returns(uint256){
        return overTimeBlockCnt;
    }    

    function IsOpenBlindBoxDisable(uint8 lv) override external view returns(bool)
    {
        if (block.timestamp < openBlindboxBeginTime || block.timestamp > openBlindBoxEndTime)return true;
        bool re = lv == 1? openBlindBoxCurCnt_lv1 >= openBlindBoxMaxCnt_lv1 : openBlindBoxCurCnt_lv2 >= openBlindBoxMaxCnt_lv2;
        return re;
    }

    function AddOpenllBlindBoxCntCur(uint8 lv) override external
    {
        require(hasRole(OPERATOR_ROLE, _msgSender()), "Caller is not a operator");
        lv == 1?    openBlindBoxCurCnt_lv1 = openBlindBoxCurCnt_lv1.add(1):
                    openBlindBoxCurCnt_lv2 = openBlindBoxCurCnt_lv2.add(1);
    }    

}