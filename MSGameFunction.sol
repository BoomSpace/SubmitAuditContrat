// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IMSSpaceToken.sol";
import "./IMSNft.sol";
import "./IMSGameFunctionData.sol";
import "./IMSLibrary.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/**
 * The MSGameFunction contract 
 */
contract MSGameFunction is Ownable{
    using SafeMath for uint256;

	IMSSpaceToken public msSpaceToken;
    IMSNft public msGemoNft;    
	IMSGameFunctionData public msGameFunctionData;
    IMSLibrary public msLibrary;

    address private signerAddress;
    mapping(uint256 => bool) private MoneyChangingOrderId;
    mapping(uint256 => bool) private BBXByDebrisOrderId;
    mapping(uint256 => bool) private OpenBlindBoxOrderId;    

	constructor(
		address _IMSSpaceToken,
        address _IMSGemoNft,
		address _IMSGameFunctionData,
        address _IMSLibrary,        
        address _signerAddress
		) {
		msSpaceToken 		= IMSSpaceToken(_IMSSpaceToken);
        msGemoNft           = IMSNft(_IMSGemoNft);        
		msGameFunctionData 	= IMSGameFunctionData(_IMSGameFunctionData);
        msLibrary  = IMSLibrary(_IMSLibrary);        
        signerAddress = _signerAddress;
	}

    event ev_Space_To_CSpace(
        uint256 indexed amount, 
        address indexed sender,
        uint256 balance);

	event ev_CSpace_To_Space(
		uint256 indexed orderId,
		uint256 indexed amount,
		address indexed sender,
        uint256 balance);	

	event ev_OpenBlindBoxBySpaceForGemoNftArray(
        uint256[] GemoIDAry,
		address indexed sender,
        address FeeTo,
        uint256 Fee,
        uint8   quality,
        uint256 balance);

    function setSignerAddress(address signerAddress_) external onlyOwner()
    {
        signerAddress = signerAddress_;
    }

    function Space_To_CSpace (uint256 amount) external
    {
        require(msSpaceToken.msGetBalanceOf(msg.sender) >= amount, "Your balance is not enough");
        msSpaceToken.msBurn(msg.sender, amount);
        emit ev_Space_To_CSpace( amount, 
                    msg.sender,
                    msSpaceToken.msGetBalanceOf(msg.sender));

    }
	
    function CSpace_To_Spcae(
        uint256 orderId,
        uint256 amount,
        uint256 blocknum,
        bytes memory signature
    ) external {
        require(MoneyChangingOrderId[orderId] == false, "already use orderId");
        bytes32 hash = msLibrary.MSSecret(amount, orderId, msg.sender, blocknum);
        address _signer = msLibrary.recoverEx(hash, signature);
        require(_signer == signerAddress, "invalid signer");
        require(block.number.sub(blocknum)  < msGameFunctionData.GetOverTimeBlockCnt(), "your signer is over time");

        MoneyChangingOrderId[orderId] = true;
        msSpaceToken.msMint(msg.sender, amount);            

        emit ev_CSpace_To_Space(orderId, 
                            amount, 
                            msg.sender,
                            msSpaceToken.msGetBalanceOf(msg.sender));
    }

    function OpenBlindBoxBySpaceForGemoNftArray(
        uint256 orderId,
        uint256 amount,
        address FeeTo,
        uint256 blocknum,
        uint8   quality,
        bytes memory signature 
        ) external {

        uint256 SpacePrice = quality == 1 ? msGameFunctionData.getOpenBlindBoxBySpacePrice_lv1() : msGameFunctionData.getOpenBlindBoxBySpacePrice_lv2();
        require( msSpaceToken.msGetBalanceOf(msg.sender) >= SpacePrice * amount, "Your balance is not enough");
        require(block.number.sub(blocknum)  < msGameFunctionData.GetOverTimeBlockCnt(), "your signer is over time");
        require(msGameFunctionData.IsOpenBlindBoxDisable(quality)==false, "pre sell blindbox is over");

        uint256[] memory nftIDArray = new uint256[](amount);
        uint256 fee = 0;
        uint256 feeAll = 0;

        if (FeeTo != address(0))
        {
            require(OpenBlindBoxOrderId[orderId] == false, "already use orderId");
            bytes32 hash = msLibrary.MSSecret(amount, orderId, FeeTo, blocknum);
            address _signer = msLibrary.recoverEx(hash, signature);
            require(_signer == signerAddress, "invalid signer");

            OpenBlindBoxOrderId[orderId] = true;
            fee = SpacePrice.mul( msGameFunctionData.getOpenBBXBySpaceFeeRate()).div(100);
        }

        for (uint8 i = 0; i < amount; i++)
        {
            if (msGameFunctionData.IsOpenBlindBoxDisable(quality)==false)
            {
                if(FeeTo != address(0)) 
                {
                    feeAll = feeAll.add(fee);
                    msSpaceToken.msTransferFrom(msg.sender, FeeTo, fee);
                }
                
                msGameFunctionData.AddOpenllBlindBoxCntCur(quality);
                msSpaceToken.msTransferFrom(msg.sender, msGameFunctionData.getVaultAddress(), SpacePrice.sub(fee));
                nftIDArray[i] = msGemoNft.msMint(msg.sender);                 
            }
        }

	    emit ev_OpenBlindBoxBySpaceForGemoNftArray( nftIDArray, 
                                                    msg.sender,
                                                    FeeTo,
                                                    feeAll,
                                                    quality,
                                                    msSpaceToken.msGetBalanceOf(msg.sender));
    }
}
