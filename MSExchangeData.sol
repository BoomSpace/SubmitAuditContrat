// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "./IMSExchangeData.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract MSExchangeData is IMSExchangeData, Ownable, AccessControl{
    bytes32 public constant OPERATOR_ROLE = keccak256("OPERATOR_ROLE");
    using SafeMath for uint256;
    struct nftGoods {
        uint256 nftID;
        uint256 sellPrice;
        address seller;
        bool isVaild;
    }

    uint8       public exchenge_FeeRate;
    uint8       public preSell_BlindBox_FeeRate;

    uint64      public preSell_BlindBox_BeginTime;
    uint64      public preSell_BlindBox_EndTime;

    uint256     public preSell_BlindBox_MaxCnt_lv1;
    uint256     public preSell_BlindBox_CntCur_lv1; 

    uint256     public preSell_BlindBox_MaxCnt_lv2;
    uint256     public preSell_BlindBox_CntCur_lv2; 

    uint256     public preSell_BlindBox_Price_lv1;
    uint256     public preSell_BlindBox_Price_lv2;

    uint256     public minGemoSellPrice;
    uint256     public maxGemoSellPrice;

    address     public vaultAddress;

    mapping(uint256 => nftGoods) public goodsShelf_Gemo;

    constructor(
        uint8       _exchenge_FeeRate,
        uint8       _preSell_BlindBox_FeeRate,

        uint256     _preSell_BlindBox_MaxCnt_lv1, 
        uint256     _preSell_BlindBox_MaxCnt_lv2, 

        uint256     _preSell_BlindBox_Price_lv1, 
        uint256     _preSell_BlindBox_Price_lv2, 

        uint256     _minGemoSellPrice,
        uint256     _maxGemoSellPrice,

        address     _vaultAddress) {

        exchenge_FeeRate = _exchenge_FeeRate;
        preSell_BlindBox_FeeRate = _preSell_BlindBox_FeeRate;

        preSell_BlindBox_BeginTime = 0;
        preSell_BlindBox_EndTime = 0;

        preSell_BlindBox_MaxCnt_lv1 = _preSell_BlindBox_MaxCnt_lv1;
        preSell_BlindBox_CntCur_lv1 = 0;

        preSell_BlindBox_MaxCnt_lv2 = _preSell_BlindBox_MaxCnt_lv2;
        preSell_BlindBox_CntCur_lv2 = 0;

        preSell_BlindBox_Price_lv1 = _preSell_BlindBox_Price_lv1;
        preSell_BlindBox_Price_lv2 = _preSell_BlindBox_Price_lv2;

        minGemoSellPrice = _minGemoSellPrice;
        maxGemoSellPrice = _maxGemoSellPrice;

        vaultAddress = _vaultAddress;

        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    function set_exchenge_FeeRate(uint8 feerate) onlyOwner() external {
        exchenge_FeeRate = feerate;
    }

    function set_preSell_BlindBox_FeeRate(uint8 feerate) onlyOwner() external {
        preSell_BlindBox_FeeRate = feerate;
    }

    function set_preSell_BlindBox_BeginTime(uint64 _time) onlyOwner() external {
        preSell_BlindBox_BeginTime = _time;
    }

    function set_preSell_BlindBox_EndTime(uint64 _time) onlyOwner() external {
        preSell_BlindBox_EndTime = _time;
    }

    function set_preSell_BlindBox_MaxCnt_lv1(uint256 count) onlyOwner() external {
        preSell_BlindBox_MaxCnt_lv1 = count;
    }

    function set_preSell_BlindBox_CntCur_lv1(uint256 count) onlyOwner() external {
        preSell_BlindBox_CntCur_lv1 = count;
    }

    function set_preSell_BlindBox_MaxCnt_lv2(uint256 count) onlyOwner() external {
        preSell_BlindBox_MaxCnt_lv2 = count;
    }

    function set_preSell_BlindBox_CntCur_lv2(uint256 count) onlyOwner() external {
        preSell_BlindBox_CntCur_lv2 = count;
    }

    function set_preSell_BlindBox_Price_lv1(uint256 price) onlyOwner() external {
        preSell_BlindBox_Price_lv1 = price;
    }

    function set_preSell_BlindBox_Price_lv2(uint256 price) onlyOwner() external {
        preSell_BlindBox_Price_lv2 = price;
    }

    function setMinGemoSellPrice(uint256 price) onlyOwner() external{
        minGemoSellPrice = price;
    }

    function setMaxGemoSellPrice(uint256 price) onlyOwner() external{
        maxGemoSellPrice = price;
    }

    function setVaultAddress(address vault) onlyOwner() external {
        vaultAddress = vault;
    }
    
//////////////////////////////////////////////////
    function get_exchenge_FeeRate() override external view  returns(uint8) {
        return exchenge_FeeRate;
    }

    function get_preSell_BlindBox_FeeRate() override external view  returns(uint8) {
        return preSell_BlindBox_FeeRate;
    }

    function get_preSell_BlindBox_BeginTime() override external view  returns(uint64) {
        return preSell_BlindBox_BeginTime;
    }

    function get_preSell_BlindBox_EndTime() override external view  returns(uint64) {
        return preSell_BlindBox_EndTime;
    }

    function get_preSell_BlindBox_MaxCnt_lv1() override external view  returns(uint256) {
        return preSell_BlindBox_MaxCnt_lv1;
    }

    function get_preSell_BlindBox_CntCur_lv1() override external view  returns(uint256) {
        return preSell_BlindBox_CntCur_lv1;
    }

    function get_preSell_BlindBox_MaxCnt_lv2() override external view  returns(uint256) {
        return preSell_BlindBox_MaxCnt_lv2;
    }

    function get_preSell_BlindBox_CntCur_lv2() override external view  returns(uint256) {
        return preSell_BlindBox_CntCur_lv2;
    }

    function get_preSell_BlindBox_Price_lv1() override external view  returns(uint256) {
        return preSell_BlindBox_Price_lv1;
    }

    function get_preSell_BlindBox_Price_lv2() override external view  returns(uint256) {
        return preSell_BlindBox_Price_lv2;
    }   

    function GetMinGemoSellPrice()  override external view  returns(uint256){
        return minGemoSellPrice;
    }

    function GetMaxGemoSellPrice()  override external view  returns(uint256){
        return maxGemoSellPrice;
    }

    function GetVaultAddress() override external view returns(address) {
        return vaultAddress;
    }

    function get_preSell_BlindBox_AllInfo() override external view returns(uint8,uint64,uint64,uint256,uint256,uint256,uint256,uint256,uint256,uint256)
    {
        return (preSell_BlindBox_FeeRate,
        preSell_BlindBox_BeginTime,
        preSell_BlindBox_EndTime,
        block.timestamp,
        preSell_BlindBox_MaxCnt_lv1,
        preSell_BlindBox_CntCur_lv1,
        preSell_BlindBox_MaxCnt_lv2,
        preSell_BlindBox_CntCur_lv2,
        preSell_BlindBox_Price_lv1,
        preSell_BlindBox_Price_lv2);
    }
///////////////////////////////
    function IsPreSellBlindBoxDisable(uint8 lv) override external view returns(bool)
    {
        if (block.timestamp < preSell_BlindBox_BeginTime || block.timestamp > preSell_BlindBox_EndTime)return true;
        bool re = lv == 1? preSell_BlindBox_CntCur_lv1 >= preSell_BlindBox_MaxCnt_lv1 : preSell_BlindBox_CntCur_lv1 >= preSell_BlindBox_MaxCnt_lv2;
        return re;
    }   

    function hasGoods(uint256 nftID) override external view returns(bool)
    {
        return goodsShelf_Gemo[nftID].isVaild;
    }

    function GetNftGoodsContent(uint256 nftID) override external view returns(uint256,bool,address){
        return (goodsShelf_Gemo[nftID].sellPrice, goodsShelf_Gemo[nftID].isVaild, goodsShelf_Gemo[nftID].seller);
    }

    function AddPreSellBlindBoxCntCur(uint8 lv) override external {
        require(hasRole(OPERATOR_ROLE, _msgSender()), "Caller is not a operator");
        lv == 1?    preSell_BlindBox_CntCur_lv1 = preSell_BlindBox_CntCur_lv1.add(1):
                    preSell_BlindBox_CntCur_lv2 = preSell_BlindBox_CntCur_lv2.add(1);
    }

    function NftForSell(uint256 nftID, uint256 price, address seller) override external{
        require(hasRole(OPERATOR_ROLE, _msgSender()), "Caller is not a operator");
        require(!goodsShelf_Gemo[nftID].isVaild, "The Nft is already on the goods shelf ");
        nftGoods storage nft = goodsShelf_Gemo[nftID];
        nft.nftID = nftID;
        nft.sellPrice = price;
        nft.seller = seller;
        nft.isVaild = true;
    }

    function NftForSoldOut(uint256 nftID) override external{
        require(hasRole(OPERATOR_ROLE, _msgSender()), "Caller is not a operator");
        require(goodsShelf_Gemo[nftID].isVaild, "The Nft is not on the goods shelf ");
        delete goodsShelf_Gemo[nftID];
    }

    function buyNftFinish(uint256 nftID) override external{
        require(hasRole(OPERATOR_ROLE, _msgSender()), "Caller is not a operator");
        delete goodsShelf_Gemo[nftID];
    }
}