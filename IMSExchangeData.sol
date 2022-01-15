// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IMSExchangeData {
    function get_exchenge_FeeRate() external view  returns(uint8);
    function get_preSell_BlindBox_FeeRate() external view  returns(uint8);
    function get_preSell_BlindBox_BeginTime() external view  returns(uint64);
    function get_preSell_BlindBox_EndTime() external view  returns(uint64);
    function get_preSell_BlindBox_MaxCnt_lv1() external view  returns(uint256);
    function get_preSell_BlindBox_CntCur_lv1() external view  returns(uint256);
    function get_preSell_BlindBox_MaxCnt_lv2() external view  returns(uint256);
    function get_preSell_BlindBox_CntCur_lv2() external view  returns(uint256);
    function get_preSell_BlindBox_Price_lv1() external view  returns(uint256);
    function get_preSell_BlindBox_Price_lv2() external view  returns(uint256);
    function get_preSell_BlindBox_AllInfo() external view returns(uint8,uint64,uint64,uint256,uint256,uint256,uint256,uint256,uint256,uint256);
    function GetMinGemoSellPrice() external view  returns(uint256);
    function GetMaxGemoSellPrice() external view  returns(uint256);
    function GetVaultAddress() external view returns(address);
    function IsPreSellBlindBoxDisable(uint8 lv) external view returns(bool);
    function hasGoods(uint256 nftID) external view returns(bool);
    function GetNftGoodsContent(uint256 nftID) external view returns(uint256,bool,address);
    function AddPreSellBlindBoxCntCur(uint8 lv) external;
    function NftForSell(uint256 nftID, uint256 price, address seller) external;
    function NftForSoldOut(uint256 nftID) external;
    function buyNftFinish(uint256 nftID) external;
}
