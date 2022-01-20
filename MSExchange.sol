// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "./IMSSpaceToken.sol";
import "./IMSNft.sol";
import "./IMSExchangeData.sol";
import "./IMSLibrary.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MSExchange is Ownable {
    using SafeMath for uint256;

    IMSNft private msGemoNft;
    IMSExchangeData private msExchangeData;
    IMSLibrary public msLibrary;
    IERC20 USTDToken;
    address private signerAddress;
    constructor( 
        address _USTDToken,
        address _IMSGemoNft,
        address _IExchangeData,
        address _IMSLibrary,
        address _signerAddress
        ) {
        USTDToken       = IERC20(_USTDToken);
        msGemoNft       = IMSNft(_IMSGemoNft);
        msExchangeData  = IMSExchangeData(_IExchangeData);
        msLibrary  = IMSLibrary(_IMSLibrary); 
        signerAddress = _signerAddress;
    }

    event ev_nftForSell(
        uint256 indexed nftID,
        uint256 indexed sellPrice,
        address indexed owner
    );

    event ev_NftForSoldOut(
        uint256 indexed nftID,
        address indexed owner
    );

    event ev_buyNft(
        uint8   isValid,
        uint256 indexed nftID,
        uint256  sellPrice,
        address indexed seller,
        address indexed buyer
    );
    
    event ev_openPreSellBlindBox(
        uint8   quality,
        uint256 indexed itemId,
        uint256 fee, 
        address FeeTo,
        address indexed Address
    );

    function setSignerAddress(address signerAddress_) external onlyOwner()
    {
        signerAddress = signerAddress_;
    }

    function NftForSell(uint256 nftID, uint256 sellPrice) external{
        require(msGemoNft.msGetOwner(nftID) == msg.sender, "You don't own this .");
        require(msExchangeData.hasGoods(nftID) == false, "this goods already for sell");        
        require(msGemoNft.msIsApprovedForAll(msg.sender, address(this)), "Approve this goods first.");
        require(sellPrice >= msExchangeData.GetMinGemoSellPrice(), "Price reaches the lower limit.");
        require(sellPrice <= msExchangeData.GetMaxGemoSellPrice(), "Price reaches the upper limit.");

        msExchangeData.NftForSell(nftID,  sellPrice, msg.sender);
        emit ev_nftForSell(nftID, 
                         sellPrice, 
                         msg.sender);
    }

    function NftForSoldOut(uint256 nftID) external{
        require(msGemoNft.msGetOwner(nftID) == msg.sender, "You don't own this goods.");

        msExchangeData.NftForSoldOut(nftID);
        emit ev_NftForSoldOut(nftID, msg.sender);
    }

    function buyNft(uint256 nftID) external {
        (uint256 sellPrice, bool isVaild, address seller) = msExchangeData.GetNftGoodsContent(nftID);
        require(USTDToken.balanceOf(msg.sender) >= sellPrice, "Your balance is not enough");
        require(isVaild, "This goods not actually for sale.");
        require(msg.sender != msGemoNft.msGetOwner(nftID), "You can't buy yours goods.");

        uint256 retNftID = nftID;
        if(seller == msGemoNft.msGetOwner(nftID))
        {
            address VaultAddres = msExchangeData.GetVaultAddress();
            uint8 feeRate = msExchangeData.get_exchenge_FeeRate();
            uint256 fee = sellPrice.mul(feeRate).div(100);

            USTDToken.transferFrom(msg.sender, seller, sellPrice.sub(fee));
            USTDToken.transferFrom(msg.sender, VaultAddres, fee);

            msGemoNft.msTransferFrom(seller, msg.sender, nftID);
        }
        else
            retNftID = 0;

        msExchangeData.buyNftFinish(nftID);
        emit ev_buyNft(retNftID == nftID? 1:0, retNftID, sellPrice, seller, msg.sender);
    }

    function openPreSellBlindBox(
        uint8 quality,
        address FeeTo,
        bytes memory signature 
        ) external {
        uint256 price = quality == 1? msExchangeData.get_preSell_BlindBox_Price_lv1() : msExchangeData.get_preSell_BlindBox_Price_lv2();
        require(USTDToken.balanceOf(msg.sender) >= price, "Your balance is not enough");
        require(msExchangeData.IsPreSellBlindBoxDisable(quality)==false, "pre sell blindbox is over");

        uint256 fee = 0;    
        msExchangeData.AddPreSellBlindBoxCntCur(quality);
        if (FeeTo != address(0))
        {
            bytes32 hash = msLibrary.MSSecret(1, 0, FeeTo, 0);
            address _signer = msLibrary.recoverEx(hash, signature);
            require(_signer == signerAddress, "invalid signer");

            fee = price.mul( msExchangeData.get_preSell_BlindBox_FeeRate()).div(100);
            USTDToken.transferFrom(msg.sender, FeeTo, fee);
        }

        USTDToken.transferFrom(msg.sender, msExchangeData.GetVaultAddress(), price.sub(fee));
        uint256 nftID = msGemoNft.msMint(msg.sender);
        
        emit ev_openPreSellBlindBox(quality, nftID, fee, FeeTo, msg.sender);
    }
}
