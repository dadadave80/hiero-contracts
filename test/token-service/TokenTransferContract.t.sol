// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.5.0 <0.9.0;

import {BaseTest, Vm} from "../Base.t.sol";
import {
    TokenTransferContract,
    IHederaTokenService
} from "hiero-contracts/extensions/token-transfer/TokenTransferContract.sol";

contract TokenTransferContractTest is BaseTest {
    TokenTransferContract tokenTransferContract;
    address constant MOCK_TOKEN = address(0x1234);
    address constant MOCK_NFT = address(0x5678);

    event ResponseCode(int256 responseCode);

    function setUp() public override {
        super.setUp();
        tokenTransferContract = new TokenTransferContract();
    }

    function mockHTSResponse() internal {
        bytes memory successReturn = abi.encode(int64(TX_SUCCESS_CODE));
        vm.mockCall(HTS_PRECOMPILE, abi.encodeWithSelector(IHederaTokenService.transferTokens.selector), successReturn);
        vm.mockCall(HTS_PRECOMPILE, abi.encodeWithSelector(IHederaTokenService.transferNFTs.selector), successReturn);
        vm.mockCall(HTS_PRECOMPILE, abi.encodeWithSelector(IHederaTokenService.transferToken.selector), successReturn);
        vm.mockCall(HTS_PRECOMPILE, abi.encodeWithSelector(IHederaTokenService.transferNFT.selector), successReturn);
        vm.mockCall(HTS_PRECOMPILE, abi.encodeWithSelector(IHederaTokenService.cryptoTransfer.selector), successReturn);
    }

    function test_TransferTokens() public {
        mockHTSResponse();

        int64 amount = 33;
        address[] memory accountIds = new address[](2);
        accountIds[0] = address(this);
        accountIds[1] = address(0x1);

        int64[] memory amounts = new int64[](2);
        amounts[0] = -amount;
        amounts[1] = amount;

        vm.recordLogs();
        tokenTransferContract.transferTokensPublic(MOCK_TOKEN, accountIds, amounts);

        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries[0].topics[0], keccak256("ResponseCode(int256)"));
        int256 responseCode = abi.decode(entries[0].data, (int256));
        assertEq(responseCode, int256(TX_SUCCESS_CODE));
    }

    function test_TransferNFTs() public {
        mockHTSResponse();

        address[] memory senderIds = new address[](1);
        senderIds[0] = address(this);

        address[] memory receiverIds = new address[](1);
        receiverIds[0] = address(0x1);

        int64[] memory serialNumbers = new int64[](1);
        serialNumbers[0] = 1;

        vm.recordLogs();
        tokenTransferContract.transferNFTsPublic(MOCK_NFT, senderIds, receiverIds, serialNumbers);

        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries[0].topics[0], keccak256("ResponseCode(int256)"));
        int256 responseCode = abi.decode(entries[0].data, (int256));
        assertEq(responseCode, int256(TX_SUCCESS_CODE));
    }

    function test_TransferToken() public {
        mockHTSResponse();

        int64 amount = 33;

        vm.recordLogs();
        tokenTransferContract.transferTokenPublic(MOCK_TOKEN, address(this), address(0x1), amount);

        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries[0].topics[0], keccak256("ResponseCode(int256)"));
        int256 responseCode = abi.decode(entries[0].data, (int256));
        assertEq(responseCode, int256(TX_SUCCESS_CODE));
    }

    function test_TransferNFT() public {
        mockHTSResponse();

        int64 serialNumber = 1;

        vm.recordLogs();
        tokenTransferContract.transferNFTPublic(MOCK_NFT, address(this), address(0x1), serialNumber);

        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries[0].topics[0], keccak256("ResponseCode(int256)"));
        int256 responseCode = abi.decode(entries[0].data, (int256));
        assertEq(responseCode, int256(TX_SUCCESS_CODE));
    }

    function test_CryptoTransfer() public {
        mockHTSResponse();

        IHederaTokenService.AccountAmount[] memory hbarTransfers = new IHederaTokenService.AccountAmount[](2);
        hbarTransfers[0] =
            IHederaTokenService.AccountAmount({accountID: address(this), amount: -10000, isApproval: false});
        hbarTransfers[1] =
            IHederaTokenService.AccountAmount({accountID: address(0x1), amount: 10000, isApproval: false});

        IHederaTokenService.TransferList memory cryptoTransfers =
            IHederaTokenService.TransferList({transfers: hbarTransfers});
        IHederaTokenService.TokenTransferList[] memory tokenTransferList =
            new IHederaTokenService.TokenTransferList[](0);

        vm.recordLogs();
        tokenTransferContract.cryptoTransferPublic(cryptoTransfers, tokenTransferList);

        Vm.Log[] memory entries = vm.getRecordedLogs();
        assertEq(entries[0].topics[0], keccak256("ResponseCode(int256)"));
        int256 responseCode = abi.decode(entries[0].data, (int256));
        assertEq(responseCode, int256(TX_SUCCESS_CODE));
    }
}
