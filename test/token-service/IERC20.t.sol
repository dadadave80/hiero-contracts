// SPDX-License-Identifier: Apache-2.0
pragma solidity >=0.5.0 <0.9.0;

import {BaseTest} from "../Base.t.sol";
import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import {IERC20Metadata} from "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";

contract IERC20Test is BaseTest {
    address constant MOCK_TOKEN = address(0x1234);
    address constant OWNER = address(0x5678);
    address constant SPENDER = address(0x9ABC);

    function setUp() public override {
        super.setUp();
    }

    function test_IERCNaming() public {
        vm.mockCall(MOCK_TOKEN, abi.encodeWithSelector(IERC20Metadata.name.selector), abi.encode("MockToken"));
        string memory name = IERC20Metadata(MOCK_TOKEN).name();
        assertEq(name, "MockToken");
    }

    function test_IERC20Symbol() public {
        vm.mockCall(MOCK_TOKEN, abi.encodeWithSelector(IERC20Metadata.symbol.selector), abi.encode("MCK"));
        string memory symbol = IERC20Metadata(MOCK_TOKEN).symbol();
        assertEq(symbol, "MCK");
    }

    function test_IERC20Decimals() public {
        vm.mockCall(MOCK_TOKEN, abi.encodeWithSelector(IERC20Metadata.decimals.selector), abi.encode(8));
        uint8 decimals = IERC20Metadata(MOCK_TOKEN).decimals();
        assertEq(decimals, 8);
    }

    function test_IERC20TotalSupply() public {
        vm.mockCall(MOCK_TOKEN, abi.encodeWithSelector(IERC20.totalSupply.selector), abi.encode(10000));
        uint256 totalSupply = IERC20(MOCK_TOKEN).totalSupply();
        assertEq(totalSupply, 10000);
    }

    function test_IERC20BalanceOf() public {
        vm.mockCall(MOCK_TOKEN, abi.encodeWithSelector(IERC20.balanceOf.selector, OWNER), abi.encode(500));
        uint256 balance = IERC20(MOCK_TOKEN).balanceOf(OWNER);
        assertEq(balance, 500);
    }

    function test_IERC20Approve() public {
        vm.mockCall(MOCK_TOKEN, abi.encodeWithSelector(IERC20.approve.selector, SPENDER, 100), abi.encode(true));
        bool success = IERC20(MOCK_TOKEN).approve(SPENDER, 100);
        assertTrue(success);
    }

    function test_IERC20Allowance() public {
        vm.mockCall(MOCK_TOKEN, abi.encodeWithSelector(IERC20.allowance.selector, OWNER, SPENDER), abi.encode(100));
        uint256 allowance = IERC20(MOCK_TOKEN).allowance(OWNER, SPENDER);
        assertEq(allowance, 100);
    }

    function test_IERC20Transfer() public {
        vm.mockCall(MOCK_TOKEN, abi.encodeWithSelector(IERC20.transfer.selector, SPENDER, 50), abi.encode(true));
        bool success = IERC20(MOCK_TOKEN).transfer(SPENDER, 50);
        assertTrue(success);
    }

    function test_IERC20TransferFrom() public {
        vm.mockCall(
            MOCK_TOKEN, abi.encodeWithSelector(IERC20.transferFrom.selector, OWNER, SPENDER, 50), abi.encode(true)
        );
        bool success = IERC20(MOCK_TOKEN).transferFrom(OWNER, SPENDER, 50);
        assertTrue(success);
    }
}
