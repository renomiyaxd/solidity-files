// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.17;

contract ExampleStrings {

    string public myString = "Hello World"; //UTF-8 Format
    bytes public myBytes = "Hello World"; //bytes Format

    function setMyString (string memory _myString) public {
        myString = _myString;

    }

    function compareTwoStrings(string memory _myString) public view returns(bool) {
        return keccak256(abi.encodePacked(myString)) == keccak256(abi.encodePacked(_myString));
    }

}