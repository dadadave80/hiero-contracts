// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.5.0 <0.9.0;

import {BaseTest, Vm} from "../Base.t.sol";
import {Airdrop, IHederaTokenService} from "hiero-contracts/extensions/hrc-904/Airdrop.sol";

contract AirdropContractTest is BaseTest {
    Airdrop airdropContract;
    address constant SENDER = address(0x1111);
    address constant RECEIVER = address(0x2222);
    address constant TOKEN_ADDRESS = address(0x3333);
    address constant NFT_ADDRESS = address(0x4444);

    function setUp() public override {
        super.setUp();
        airdropContract = new Airdrop();
    }

    function test_TokenAirdrop() public {
        vm.mockCall(
            HTS_PRECOMPILE,
            abi.encodeWithSelector(IHederaTokenService.airdropTokens.selector),
            abi.encode(TX_SUCCESS_CODE)
        );
        int64 responseCode = airdropContract.tokenAirdrop(TOKEN_ADDRESS, SENDER, RECEIVER, 100);
        assertEq(responseCode, int64(TX_SUCCESS_CODE));
    }

    function test_NftAirdrop() public {
        vm.mockCall(
            HTS_PRECOMPILE,
            abi.encodeWithSelector(IHederaTokenService.airdropTokens.selector),
            abi.encode(TX_SUCCESS_CODE)
        );
        int64 responseCode = airdropContract.nftAirdrop(NFT_ADDRESS, SENDER, RECEIVER, 1);
        assertEq(responseCode, int64(TX_SUCCESS_CODE));
    }

    function test_MultipleFtAirdrop() public {
        address[] memory tokens = new address[](2);
        tokens[0] = TOKEN_ADDRESS;
        tokens[1] = address(0x5555);

        vm.mockCall(
            HTS_PRECOMPILE,
            abi.encodeWithSelector(IHederaTokenService.airdropTokens.selector),
            abi.encode(TX_SUCCESS_CODE)
        );
        int64 responseCode = airdropContract.multipleFtAirdrop(tokens, SENDER, RECEIVER, 50);
        assertEq(responseCode, int64(TX_SUCCESS_CODE));
    }

    function test_MultipleNftAirdrop() public {
        address[] memory nfts = new address[](2);
        nfts[0] = NFT_ADDRESS;
        nfts[1] = address(0x6666);

        int64[] memory serials = new int64[](2);
        serials[0] = 1;
        serials[1] = 2;

        vm.mockCall(
            HTS_PRECOMPILE,
            abi.encodeWithSelector(IHederaTokenService.airdropTokens.selector),
            abi.encode(TX_SUCCESS_CODE)
        );
        int64 responseCode = airdropContract.multipleNftAirdrop(nfts, SENDER, RECEIVER, serials);
        assertEq(responseCode, int64(TX_SUCCESS_CODE));
    }
}
