// SPDX-License-Identifier: MIT
pragma solidity 0.8.4;  //Do not change the solidity version as it negativly impacts submission grading

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {

  ExampleExternalContract public exampleExternalContract;

  mapping ( address => uint256 ) public balances;

  uint256 public constant threshold = 1 ether;

  uint256 public deadline = block.timestamp + 72 hours;

  bool public openForWithdraw;

  constructor(address exampleExternalContractAddress) {
      exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
      openForWithdraw = false;
  }

  

  // Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
  // (Make sure to add a `Stake(address,uint256)` event and emit it for the frontend `All Stakings` tab to display)

  function stake() public payable {
    balances[msg.sender] += msg.value;
    emit Stake(msg.sender, msg.value);
  }

  event Stake(address,uint256);

  // After some `deadline` allow anyone to call an `execute()` function
  // If the deadline has passed and the threshold is met, it should call `exampleExternalContract.complete{value: address(this).balance}()` 

  function execute() public notCompleted() {
    if (block.timestamp >= deadline) {
      if (address(this).balance >= threshold) {
        exampleExternalContract.complete{value: address(this).balance}();
      }
      else {
        openForWithdraw = true;
      }
    }
  }

  function timeLeft () public view returns (uint256) {
    if (block.timestamp < deadline) {
      return deadline - block.timestamp;
    }
    return 0;
  }

  function withdraw() public notCompleted() {
    if (openForWithdraw == true) {
      // payable(msg.sender).transfer(balances[msg.sender]);
      payable(msg.sender).call{value: balances[msg.sender]}("");
      balances[msg.sender] = 0;
    }
  }

  receive() external payable {
    balances[msg.sender] += msg.value;
  }

  modifier notCompleted() {
    require(!exampleExternalContract.completed(), "Threshold completed!");
    _;
  }

  // If the `threshold` was not met, allow everyone to call a `withdraw()` function to withdraw their balance


  // Add a `timeLeft()` view function that returns the time left before the deadline for the frontend


  // Add the `receive()` special function that receives eth and calls stake()

}
