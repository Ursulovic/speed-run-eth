pragma solidity 0.8.4; //Do not change the solidity version as it negativly impacts submission grading
// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/access/Ownable.sol";
import "./YourToken.sol";
import "hardhat/console.sol";

contract Vendor is Ownable {

  uint256 public constant tokensPerEth = 100;

  YourToken public yourToken;

  constructor(address tokenAddress) {
    yourToken = YourToken(tokenAddress);
  }

  // ToDo: create a payable buyTokens() function:

  function buyTokens() public payable {
    yourToken.transfer(msg.sender, msg.value * tokensPerEth);
    emit BuyTokens(msg.sender, msg.value, msg.value * tokensPerEth);
  }


  // ToDo: create a withdraw() function that lets the owner withdraw ETH

  function withdraw() public onlyOwner() {
    payable(owner()).transfer(address(this).balance);
  }

  // ToDo: create a sellTokens(uint256 _amount) function:

  function sellTokens(uint256 _amount) public {
    require(yourToken.balanceOf(msg.sender) >= _amount, "Insufficient token balance");
    uint256 ethAmount = _amount / tokensPerEth;
    require(address(this).balance >= ethAmount, "Insufficient contract balance in ETH");

    yourToken.transferFrom(msg.sender, address(this), _amount);
    
    payable(msg.sender).transfer(ethAmount);

    emit SellTokens(msg.sender, _amount, ethAmount);
    
    }


  event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
  event SellTokens(address seller, uint256 amountOfTokens, uint256 amountOfETH);
}
