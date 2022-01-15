// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "./MSNft.sol";

contract MSGemoNft is MSNft {

    constructor (string memory name_, string memory symbol_) 
                MSNft(name_, symbol_)
    {

    }
}