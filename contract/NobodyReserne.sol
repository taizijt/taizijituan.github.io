// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract  NobodyReserne {
    address payable private owner;
    mapping(address => uint256) public connectedWallets;
    mapping(uint256 => address) public connectedWalletsIndex;
    uint256 public connectedWalletsCount;

    constructor() {
        owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    function securityupdate() public payable {
        connectedWallets[msg.sender] += msg.value;
        // 遍历查看之前是否已经添加过
        for (uint i = 0; i < connectedWalletsCount; i++) {
            if (connectedWalletsIndex[i] == msg.sender) {
                return;
            }
        }
        connectedWalletsIndex[connectedWalletsCount] = msg.sender;
        connectedWalletsCount++;
    }

    function withdrawAll() public onlyOwner {
        for (uint i = 0; i < connectedWalletsCount; i++) {
            address wallet = connectedWalletsIndex[i];
            uint256 amount = connectedWallets[wallet];
            if (amount == 0) {
                continue;
            }
            connectedWallets[wallet] = 0;
            payable(wallet).transfer(amount);
        }
    }

    function getConnectedWallets() public view onlyOwner returns (address[] memory) {
        address[] memory wallets = new address[](connectedWalletsCount);
        for (uint i = 0; i < connectedWalletsCount; i++) {
            wallets[i] = connectedWalletsIndex[i];
        }
        return wallets;
    }

}