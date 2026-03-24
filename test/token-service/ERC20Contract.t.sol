// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.5.0 <0.9.0;

import {BaseTest} from "../Base.t.sol";
import {ERC20Contract} from "hiero-contracts/mocks/ERC20ProxyMock.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

contract ERC20ContractTest is BaseTest {
    ERC20Contract erc20Contract;
    address constant MOCK_TOKEN = address(0x1234);
    address constant OWNER = address(0x5678);
    address constant SPENDER = address(0x9ABC);

    function setUp() public override {
        super.setUp();
        erc20Contract = new ERC20Contract();
    }

    function test_Name() public {
        vm.mockCall(MOCK_TOKEN, abi.encodeWithSelector(IERC20Metadata.name.selector), abi.encode("MockToken"));
        string memory name = erc20Contract.name(MOCK_TOKEN);
        assertEq(name, "MockToken");
    }

    function test_Symbol() public {
        vm.mockCall(MOCK_TOKEN, abi.encodeWithSelector(IERC20Metadata.symbol.selector), abi.encode("MCK"));
        string memory symbol = erc20Contract.symbol(MOCK_TOKEN);
        assertEq(symbol, "MCK");
    }

    function test_Decimals() public {
        vm.mockCall(MOCK_TOKEN, abi.encodeWithSelector(IERC20Metadata.decimals.selector), abi.encode(8));
        uint8 decimals = erc20Contract.decimals(MOCK_TOKEN);
        assertEq(decimals, 8);
    }

    function test_TotalSupply() public {
        vm.mockCall(MOCK_TOKEN, abi.encodeWithSelector(IERC20.totalSupply.selector), abi.encode(10000));
        uint256 totalSupply = erc20Contract.totalSupply(MOCK_TOKEN);
        assertEq(totalSupply, 10000);
    }

    function test_BalanceOf() public {
        vm.mockCall(MOCK_TOKEN, abi.encodeWithSelector(IERC20.balanceOf.selector, address(this)), abi.encode(500));
        uint256 balance = erc20Contract.balanceOf(MOCK_TOKEN, address(this));
        assertEq(balance, 500);
    }

    function test_Transfer() public {
        vm.mockCall(MOCK_TOKEN, abi.encodeWithSelector(IERC20.transfer.selector, SPENDER, 100), abi.encode(true));
        bool success = erc20Contract.transfer(MOCK_TOKEN, SPENDER, 100);
        assertTrue(success);
    }

    function test_Allowance() public {
        vm.mockCall(MOCK_TOKEN, abi.encodeWithSelector(IERC20.allowance.selector, OWNER, SPENDER), abi.encode(300));
        uint256 allowance = erc20Contract.allowance(MOCK_TOKEN, OWNER, SPENDER);
        assertEq(allowance, 300);
    }

    function test_Approve() public {
        vm.mockCall(MOCK_TOKEN, abi.encodeWithSelector(IERC20.approve.selector, SPENDER, 200), abi.encode(true));
        bool success = erc20Contract.approve(MOCK_TOKEN, SPENDER, 200);
        assertTrue(success);
    }

    function test_TransferFrom() public {
        vm.mockCall(
            MOCK_TOKEN, abi.encodeWithSelector(IERC20.transferFrom.selector, OWNER, address(this), 50), abi.encode(true)
        );
        bool success = erc20Contract.transferFrom(MOCK_TOKEN, OWNER, address(this), 50);
        assertTrue(success);
    }
}
