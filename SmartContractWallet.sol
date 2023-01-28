// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.17;

contract Consumer {
    function getBalance() public view returns(uint){
        return address(this).balance;
    }

    function deposit () public payable {}
}


contract SmartContractWallet {

    address payable public owner;

    mapping ( address => uint) public allowance;
    mapping ( address => bool) public isAllowedToSend;

    mapping (address => bool) public guardians;

    address payable nextOwner;

    mapping (address => mapping(address => bool)) nextOwnerGuardianVotedBool;

    uint guardianResetCount;
    uint public constant confirmationsFromGuardiansReset = 3;

    constructor() {
        owner = payable(msg.sender);
    }

    function setGuardian(address _guardian, bool _isGuardian) public {
        require(msg.sender == owner, "You're not the owner, aborting...");
        guardians[_guardian] = _isGuardian;
    }

    function proposeNewOwner(address payable _newOwner) public {
        require(guardians[msg.sender], "You're not guardian owner, aborting...");
        require(nextOwnerGuardianVotedBool[_newOwner][msg.sender] == false, "You have already voted, aborting...");
        if (_newOwner != nextOwner){
            nextOwner = _newOwner;
            guardianResetCount = 0;
        }

        guardianResetCount++;
        if (guardianResetCount >= confirmationsFromGuardiansReset){
            owner = nextOwner;
            nextOwner = payable(address(0));
        }
    }

    function setAllowance(address _for, uint _amount) public {
        require(msg.sender == owner, "You're not the owner, aborting...");

        allowance[_for] = _amount;

        if(_amount>0){
            isAllowedToSend[_for] = true;
        } else {
            isAllowedToSend[_for] = false;
        }
    }

    function transfer(address payable _to, uint _amount, bytes memory _payload) public returns(bytes memory) {
        
        if (msg.sender !=owner){
            require(isAllowedToSend[msg.sender], "Not allowed to send, aborting...");
            require(allowance[msg.sender] >= _amount, "Amount exceed more than is allowed, aborting...");

            allowance[msg.sender] -= _amount;
        }

        (bool success, bytes memory returnData) = _to.call{value: _amount}(_payload);
        require(success, "Call unsuccessful, aborting...");
        return returnData;

    }

    receive() external payable {

    }

}
