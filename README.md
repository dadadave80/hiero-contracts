# 🏛️ Hiero Contracts

[![Foundry](https://img.shields.io/badge/Built%20with-Foundry-FFD700.svg)](https://getfoundry.sh/)
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)
[![Solidity](https://img.shields.io/badge/Solidity-%5E0.8.20-363636.svg)](https://docs.soliditylang.org/)

**A library for hedera secure smart contract development.**

## 📖 Overview

### 📥 Installation

To start using `hiero-contracts` in your own Foundry project, you can install this repository:

```bash
forge install dadadave80/hiero-contracts
```

### ⚙️ Prerequisites

For this library to work in a live environment, you need to communicate with the Hedera consensus node precompiles.
To access them, you must connect to the Hedera Testnet or Mainnet.

1. Configure Foundry with Hedera RPC Endpoints

    Add the Hedera Testnet and Mainnet RPC endpoints to your `foundry.toml`:
    
    ```toml
    [rpc_endpoints]
    hedera_testnet = "https://testnet.hashio.io/api"
    hedera_mainnet = "https://mainnet.hashio.io/api"
    ```

2. Run Tests against a Live Network Fork

    When running tests that interact with the precompiles or require live state, use Foundry's fork testing feature to connect to the live network:
    
    ```bash
    forge test --fork-url hedera_testnet
    ```

### 🚀 Usage

Once installed, you can use the contracts in the library by importing them into your own contracts (e.g., `src/SampleHTSUsage.sol`):

```solidity
pragma solidity ^0.8.20;

import {IHederaTokenService} from "hiero-contracts/token-service/IHederaTokenService.sol";
import {HederaResponseCodes} from "hiero-contracts/common/HederaResponseCodes.sol";

contract SampleHTSUsage {
    function callPrecompile(address tokenAddress) external returns (bool) {
        try IHederaTokenService(address(0x167)).isToken(tokenAddress) returns (int64 responseCode, bool isToken) {
            require(responseCode == HederaResponseCodes.SUCCESS, "Failure");
            return isToken;
        } catch {
            return false;
        }
    }
}
```

A sample Foundry test for the Smart Contract above (`test/SampleHTSUsage.t.sol`):

```solidity
// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import {SampleHTSUsage} from "../src/SampleHTSUsage.sol";
import {IHederaTokenService} from "hiero-contracts/token-service/IHederaTokenService.sol";
import {HederaResponseCodes} from "hiero-contracts/common/HederaResponseCodes.sol";

contract SampleHTSUsageTest is Test {
    SampleHTSUsage testHTS;

    function setUp() public {
        testHTS = new SampleHTSUsage();
    }

    function test_ReturnsFalseForRegularEOA() public {
        address regularEOA = address(0x123);

        // Mock the precompile call to simulate Hedera network behavior locally
        vm.mockCall(
            address(0x167),
            abi.encodeWithSelector(IHederaTokenService.isToken.selector, regularEOA),
            abi.encode(HederaResponseCodes.SUCCESS, false)
        );

        bool result = testHTS.callPrecompile(regularEOA);
        assertFalse(result);
    }
}
```

If you're new to Hedera smart contract development, head to [Developing Hedera Smart Contracts](https://github.com/hashgraph/hedera-docs/blob/main/core-concepts/smart-contracts/understanding-hederas-evm-differences-and-compatibility/README.md).

## 🛠️ Local Development

If you are developing directly within the `hiero-contracts` repository:

1. **Build the contracts:**
   ```bash
   forge build
   ```

2. **Run the test suite:**
   ```bash
   forge test
   ```

## 📚 Learn More

The Hedera network utilizes system contracts at a reserved contract address on the EVM to surface HAPI service functionality through EVM processed transactions.
These system contracts are precompiled smart contracts whose function selectors are mapped to defined network logic.
In this way EVM users can utilize exposed HAPI features natively in their smart contracts.

The system contract functions are defined in this library and implemented by the [Hedera Services](https://github.com/hashgraph/hedera-services) repo as part of consensus node functionality.

## 🔒 Security

Please do not file a public ticket mentioning the vulnerability. To report a vulnerability, please send an email to <security@hashgraph.com>.

## 🤝 Contribute

Contributions are welcome. Please see the [contributing guide](https://github.com/hashgraph/.github/blob/main/CONTRIBUTING.md) to see how you can get involved.

## 📜 Code of Conduct

This project is governed by the
[Contributor Covenant Code of Conduct](https://github.com/hashgraph/.github/blob/main/CODE_OF_CONDUCT.md). By
participating, you are expected to uphold this code of conduct. Please report unacceptable behavior
to [oss@hedera.com](mailto:oss@hedera.com).

## 📝 License

[Apache License 2.0](https://github.com/hashgraph/hedera-smart-contracts/blob/main/LICENSE)
