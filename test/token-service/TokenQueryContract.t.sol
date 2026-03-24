// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.5.0 <0.9.0;

import {BaseTest} from "../Base.t.sol";
import {TokenQueryContract, IHederaTokenService} from "hiero-contracts/extensions/token-query/TokenQueryContract.sol";

contract TokenQueryContractTest is BaseTest {
    TokenQueryContract tokenQueryContract;
    // Known HTS mainnet token address: Sauce (SAUCE) token
    address constant SAUCE_TOKEN = address(0x00000000000000000000000000000000000b2aD5);
    address constant MOCK_TOKEN = address(0x1111);
    address constant OWNER = address(0x2222);
    address constant SPENDER = address(0x3333);

    function setUp() public override {
        super.setUp();
        tokenQueryContract = new TokenQueryContract();
    }

    function test_GetTokenInfo() public {
        IHederaTokenService.TokenInfo memory mockInfo;
        mockInfo.token.symbol = "SAUCE";
        mockInfo.token.name = "Sauce";

        vm.mockCall(
            HTS_PRECOMPILE,
            abi.encodeWithSelector(IHederaTokenService.getTokenInfo.selector, SAUCE_TOKEN),
            abi.encode(TX_SUCCESS_CODE, mockInfo)
        );

        (int256 responseCode, IHederaTokenService.TokenInfo memory tokenInfo) =
            tokenQueryContract.getTokenInfoPublic(SAUCE_TOKEN);
        assertEq(responseCode, int256(TX_SUCCESS_CODE));
        assertEq(tokenInfo.token.symbol, "SAUCE", "Token symbol should match SAUCE");
        assertEq(tokenInfo.token.name, "Sauce", "Token name should match Sauce");
    }

    function test_Allowance() public {
        vm.mockCall(
            HTS_PRECOMPILE,
            abi.encodeWithSelector(IHederaTokenService.allowance.selector, MOCK_TOKEN, OWNER, SPENDER),
            abi.encode(TX_SUCCESS_CODE, uint256(100))
        );
        (int256 responseCode, uint256 amount) = tokenQueryContract.allowancePublic(MOCK_TOKEN, OWNER, SPENDER);
        assertEq(responseCode, int256(TX_SUCCESS_CODE));
        assertEq(amount, 100);
    }

    function test_GetApproved() public {
        vm.mockCall(
            HTS_PRECOMPILE,
            abi.encodeWithSelector(IHederaTokenService.getApproved.selector, MOCK_TOKEN, 1),
            abi.encode(TX_SUCCESS_CODE, SPENDER)
        );
        (int256 responseCode, address approved) = tokenQueryContract.getApprovedPublic(MOCK_TOKEN, 1);
        assertEq(responseCode, int256(TX_SUCCESS_CODE));
        assertEq(approved, SPENDER);
    }

    function test_IsApprovedForAll() public {
        vm.mockCall(
            HTS_PRECOMPILE,
            abi.encodeWithSelector(IHederaTokenService.isApprovedForAll.selector, MOCK_TOKEN, OWNER, SPENDER),
            abi.encode(TX_SUCCESS_CODE, true)
        );
        (int256 responseCode, bool approved) = tokenQueryContract.isApprovedForAllPublic(MOCK_TOKEN, OWNER, SPENDER);
        assertEq(responseCode, int256(TX_SUCCESS_CODE));
        assertTrue(approved);
    }

    function test_IsFrozen() public {
        vm.mockCall(
            HTS_PRECOMPILE,
            abi.encodeWithSelector(IHederaTokenService.isFrozen.selector, MOCK_TOKEN, OWNER),
            abi.encode(TX_SUCCESS_CODE, true)
        );
        (int256 responseCode, bool frozen) = tokenQueryContract.isFrozenPublic(MOCK_TOKEN, OWNER);
        assertEq(responseCode, int256(TX_SUCCESS_CODE));
        assertTrue(frozen);
    }

    function test_IsKyc() public {
        vm.mockCall(
            HTS_PRECOMPILE,
            abi.encodeWithSelector(IHederaTokenService.isKyc.selector, MOCK_TOKEN, OWNER),
            abi.encode(TX_SUCCESS_CODE, true)
        );
        (int64 responseCode, bool kycGranted) = tokenQueryContract.isKycPublic(MOCK_TOKEN, OWNER);
        assertEq(responseCode, int64(TX_SUCCESS_CODE));
        assertTrue(kycGranted);
    }

    function test_GetTokenCustomFees() public {
        IHederaTokenService.FixedFee[] memory fixedFees = new IHederaTokenService.FixedFee[](0);
        IHederaTokenService.FractionalFee[] memory fractionalFees = new IHederaTokenService.FractionalFee[](0);
        IHederaTokenService.RoyaltyFee[] memory royaltyFees = new IHederaTokenService.RoyaltyFee[](0);

        vm.mockCall(
            HTS_PRECOMPILE,
            abi.encodeWithSelector(IHederaTokenService.getTokenCustomFees.selector, MOCK_TOKEN),
            abi.encode(TX_SUCCESS_CODE, fixedFees, fractionalFees, royaltyFees)
        );
        (
            int64 responseCode,
            IHederaTokenService.FixedFee[] memory f1,
            IHederaTokenService.FractionalFee[] memory f2,
            IHederaTokenService.RoyaltyFee[] memory f3
        ) = tokenQueryContract.getTokenCustomFeesPublic(MOCK_TOKEN);
        assertEq(responseCode, int64(TX_SUCCESS_CODE));
        assertEq(f1.length, 0);
        assertEq(f2.length, 0);
        assertEq(f3.length, 0);
    }

    function test_GetTokenDefaultFreezeStatus() public {
        vm.mockCall(
            HTS_PRECOMPILE,
            abi.encodeWithSelector(IHederaTokenService.getTokenDefaultFreezeStatus.selector, MOCK_TOKEN),
            abi.encode(TX_SUCCESS_CODE, true)
        );
        (int256 responseCode, bool defaultFreezeStatus) =
            tokenQueryContract.getTokenDefaultFreezeStatusPublic(MOCK_TOKEN);
        assertEq(responseCode, int256(TX_SUCCESS_CODE));
        assertTrue(defaultFreezeStatus);
    }

    function test_GetTokenDefaultKycStatus() public {
        vm.mockCall(
            HTS_PRECOMPILE,
            abi.encodeWithSelector(IHederaTokenService.getTokenDefaultKycStatus.selector, MOCK_TOKEN),
            abi.encode(TX_SUCCESS_CODE, true)
        );
        (int256 responseCode, bool defaultKycStatus) = tokenQueryContract.getTokenDefaultKycStatusPublic(MOCK_TOKEN);
        assertEq(responseCode, int256(TX_SUCCESS_CODE));
        assertTrue(defaultKycStatus);
    }

    function test_GetTokenExpiryInfo() public {
        IHederaTokenService.Expiry memory expiryInfo;
        expiryInfo.second = 1000;

        vm.mockCall(
            HTS_PRECOMPILE,
            abi.encodeWithSelector(IHederaTokenService.getTokenExpiryInfo.selector, MOCK_TOKEN),
            abi.encode(TX_SUCCESS_CODE, expiryInfo)
        );
        (int256 responseCode, IHederaTokenService.Expiry memory res) =
            tokenQueryContract.getTokenExpiryInfoPublic(MOCK_TOKEN);
        assertEq(responseCode, int256(TX_SUCCESS_CODE));
        assertEq(res.second, 1000);
    }

    function test_GetFungibleTokenInfo() public {
        IHederaTokenService.FungibleTokenInfo memory info;
        info.tokenInfo.token.symbol = "FUNG";

        vm.mockCall(
            HTS_PRECOMPILE,
            abi.encodeWithSelector(IHederaTokenService.getFungibleTokenInfo.selector, MOCK_TOKEN),
            abi.encode(TX_SUCCESS_CODE, info)
        );
        (int256 responseCode, IHederaTokenService.FungibleTokenInfo memory res) =
            tokenQueryContract.getFungibleTokenInfoPublic(MOCK_TOKEN);
        assertEq(responseCode, int256(TX_SUCCESS_CODE));
        assertEq(res.tokenInfo.token.symbol, "FUNG");
    }

    function test_GetTokenKey() public {
        IHederaTokenService.KeyValue memory keyInfo;
        keyInfo.contractId = address(0x4444);

        vm.mockCall(
            HTS_PRECOMPILE,
            abi.encodeWithSelector(IHederaTokenService.getTokenKey.selector, MOCK_TOKEN, 1),
            abi.encode(TX_SUCCESS_CODE, keyInfo)
        );
        (int64 responseCode, IHederaTokenService.KeyValue memory res) =
            tokenQueryContract.getTokenKeyPublic(MOCK_TOKEN, 1);
        assertEq(responseCode, int64(TX_SUCCESS_CODE));
        assertEq(res.contractId, address(0x4444));
    }

    function test_GetNonFungibleTokenInfo() public {
        IHederaTokenService.NonFungibleTokenInfo memory info;
        info.serialNumber = 5;

        vm.mockCall(
            HTS_PRECOMPILE,
            abi.encodeWithSelector(IHederaTokenService.getNonFungibleTokenInfo.selector, MOCK_TOKEN, 5),
            abi.encode(TX_SUCCESS_CODE, info)
        );
        (int256 responseCode, IHederaTokenService.NonFungibleTokenInfo memory res) =
            tokenQueryContract.getNonFungibleTokenInfoPublic(MOCK_TOKEN, 5);
        assertEq(responseCode, int256(TX_SUCCESS_CODE));
        assertEq(res.serialNumber, 5);
    }

    function test_IsToken() public {
        vm.mockCall(
            HTS_PRECOMPILE,
            abi.encodeWithSelector(IHederaTokenService.isToken.selector, MOCK_TOKEN),
            abi.encode(TX_SUCCESS_CODE, true)
        );
        (int64 responseCode, bool isTokenFlag) = tokenQueryContract.isTokenPublic(MOCK_TOKEN);
        assertEq(responseCode, int64(TX_SUCCESS_CODE));
        assertTrue(isTokenFlag);
    }

    function test_GetTokenType() public {
        vm.mockCall(
            HTS_PRECOMPILE,
            abi.encodeWithSelector(IHederaTokenService.getTokenType.selector, MOCK_TOKEN),
            abi.encode(TX_SUCCESS_CODE, int32(1)) // NON_FUNGIBLE_UNIQUE
        );
        (int64 responseCode, int32 tokenType) = tokenQueryContract.getTokenTypePublic(MOCK_TOKEN);
        assertEq(responseCode, int64(TX_SUCCESS_CODE));
        assertEq(tokenType, 1);
    }
}
