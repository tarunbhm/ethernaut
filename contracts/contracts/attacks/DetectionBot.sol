// SPDX-License-Identifier: MIT
pragma solidity ^0.6.0;

interface IDetectionBot {
    function handleTransaction(address user, bytes calldata msgData) external;
}

interface IForta {
    function setDetectionBot(address detectionBotAddress) external;
    function notify(address user, bytes calldata msgData) external;
    function raiseAlert(address user) external;
}

contract DetectionBot is IDetectionBot {

  IForta public fortaContract;
  address public cryptoVault;

  constructor(address forta, address vault) public {
    fortaContract = IForta(forta);
    cryptoVault = vault;
  }
  
  function handleTransaction(address user, bytes calldata msgData) public override {
    // Only the Forta contract can call this method
    require(msg.sender == address(fortaContract), "Unauthorized");
    (address to, uint256 value, address origSender) = abi.decode(msgData[4:], (address, uint256, address));
    if (origSender == cryptoVault) {
      fortaContract.raiseAlert(user);
    }
    msgData;
  }
}
