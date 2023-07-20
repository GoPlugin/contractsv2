# Chainlink Smart Contracts

## Installation

```sh
# via pnpm
$ pnpm add @goplugin/contractsv2
# via npm
$ npm install @goplugin/contractsv2 --save
```

### Directory Structure

```sh
@goplugin/contracts
├── src # Solidity contracts
│   ├── v0.4
│   ├── v0.5
│   ├── v0.6
│   ├── v0.7
│   └── v0.8
└── abi # ABI json output
    ├── v0.4
    ├── v0.5
    ├── v0.6
    ├── v0.7
    └── v0.8
```

### Usage

The solidity smart contracts themselves can be imported via the `src` directory of `@chainlink/contracts`:

```solidity
import '@goplugin/contracts/src/v0.8/AutomationCompatibleInterface.sol';

```

## Local Development

Note: Contracts in `dev/` directories are under active development and are likely unaudited. Please refrain from using these in production applications.

```bash
# Clone Chainlink repository
$ git clone https://github.com/goplugin/pluginV2.git
# Continuing via pnpm
$ cd contracts/
$ pnpm
$ pnpm test
```

## Contributing

Please try to adhere to [Solidity Style Guide](https://github.com/goplugin/pluginV2/blob/develop/contracts/STYLE.md).

Contributions are welcome! Please refer to
[Plugin's contributing guidelines](https://github.com/goplugin/pluginV2/blob/develop/docs/CONTRIBUTING.md) for detailed
contribution information.

Thank you!

## License

[MIT](https://choosealicense.com/licenses/mit/)
