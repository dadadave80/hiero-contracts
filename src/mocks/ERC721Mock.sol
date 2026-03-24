// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract ERC721Mock is ERC721 {
    constructor() ERC721("ERCERC721Mock", "ERC721M") {}
}
