// SPDX-License-Identifier: MIT
pragma solidity ^0.7.0;

import "../PluginClient.sol";

contract Consumer is PluginClient {
  using Plugin for Plugin.Request;

  bytes32 internal specId;
  bytes32 public currentPrice;
  uint256 public currentPriceInt;

  event RequestFulfilled(
    bytes32 indexed requestId, // User-defined ID
    bytes32 indexed price
  );

  constructor(
    address _pli,
    address _oracle,
    bytes32 _specId
  ) public {
    setPluginToken(_pli);
    setPluginOracle(_oracle);
    specId = _specId;
  }

  function setSpecID(bytes32 _specId) public {
    specId = _specId;
  }

  function requestEthereumPrice(string memory _currency, uint256 _payment) public {
    Plugin.Request memory req = buildOperatorRequest(specId, this.fulfill.selector);
    req.add("get", "https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD,EUR,JPY");
    string[] memory path = new string[](1);
    path[0] = _currency;
    req.addStringArray("path", path);
    // version 2
    sendPluginRequest(req, _payment);
  }

  function requestMultipleParametersWithCustomURLs(
    string memory _urlUSD,
    string memory _pathUSD,
    uint256 _payment
  ) public {
    Plugin.Request memory req = buildOperatorRequest(specId, this.fulfillParametersWithCustomURLs.selector);
    req.add("urlUSD", _urlUSD);
    req.add("pathUSD", _pathUSD);
    sendPluginRequest(req, _payment);
  }

  function cancelRequest(
    address _oracle,
    bytes32 _requestId,
    uint256 _payment,
    bytes4 _callbackFunctionId,
    uint256 _expiration
  ) public {
    PluginRequestInterface requested = PluginRequestInterface(_oracle);
    requested.cancelOracleRequest(_requestId, _payment, _callbackFunctionId, _expiration);
  }

  function withdrawPli() public {
    PliTokenInterface _pli = PliTokenInterface(pluginTokenAddress());
    require(_pli.transfer(msg.sender, _pli.balanceOf(address(this))), "Unable to transfer");
  }

  function addExternalRequest(address _oracle, bytes32 _requestId) external {
    addPluginExternalRequest(_oracle, _requestId);
  }

  function fulfill(bytes32 _requestId, bytes32 _price) public recordPluginFulfillment(_requestId) {
    emit RequestFulfilled(_requestId, _price);
    currentPrice = _price;
  }

  function fulfillParametersWithCustomURLs(bytes32 _requestId, uint256 _price)
    public
    recordPluginFulfillment(_requestId)
  {
    emit RequestFulfilled(_requestId, bytes32(_price));
    currentPriceInt = _price;
  }
}
