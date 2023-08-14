// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/PliTokenInterface.sol";
import "../interfaces/VRFCoordinatorV2Interface.sol";
import "../VRFConsumerBaseV2.sol";

contract VRFExternalSubOwnerExample is VRFConsumerBaseV2 {
  VRFCoordinatorV2Interface COORDINATOR;
  PliTokenInterface PLITOKEN;

  uint256[] public s_randomWords;
  uint256 public s_requestId;
  address s_owner;

  constructor(address vrfCoordinator, address pli) VRFConsumerBaseV2(vrfCoordinator) {
    COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
    PLITOKEN = PliTokenInterface(pli);
    s_owner = msg.sender;
  }

  function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal override {
    require(requestId == s_requestId, "request ID is incorrect");
    s_randomWords = randomWords;
  }

  function requestRandomWords(
    uint64 subId,
    uint32 callbackGasLimit,
    uint16 requestConfirmations,
    uint32 numWords,
    bytes32 keyHash
  ) external onlyOwner {
    // Will revert if subscription is not funded.
    s_requestId = COORDINATOR.requestRandomWords(keyHash, subId, requestConfirmations, callbackGasLimit, numWords);
  }

  function transferOwnership(address newOwner) external onlyOwner {
    s_owner = newOwner;
  }

  modifier onlyOwner() {
    require(msg.sender == s_owner);
    _;
  }
}
