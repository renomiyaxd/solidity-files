// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.17;

contract ExampleViewPure{

    uint public myStorageVariable;

    //a function that reads from the state but doesn't write to the state.
    function getMyStorageVariable() public view returns(uint) {
        return myStorageVariable;
    }

    //a function that neither writes, nor reads from state variables. It can only access its own arguments and other pure functions.
    function getAddition(uint a, uint b) public pure returns(uint) {
        return a+b;
    }

    // not a good function, need to use an event for this
    function setMyStorageVariable(uint _newVar) public returns(uint) {
        myStorageVariable = _newVar;
        return _newVar;
    }

}