// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.17;

contract WillThrow {
    error NotAllowedError(string);

    function aFunction() public pure {
        //require(false, "Error message");
        //assert(false);
        revert NotAllowedError("You are not allowed.");

    }
}

contract ErrorHandling {

    event ErrorLogging(string reason);
    event ErrorLogCode(uint code);
    event ErrorLogBytes(bytes LowLevelData);

    function catchTheError() public {
        WillThrow will = new WillThrow();
        try will.aFunction(){
            //code when function works here
        } catch Error(string memory reason){
            //will catch Require error here
            emit ErrorLogging(reason);
        } catch Panic(uint errorCode){ 
            //will catch Assert error here
            emit ErrorLogCode(errorCode);
        } catch(bytes memory LowLevelData) {
            //will catch Custom error here, but "not catch-able", very crude exception
            //outputs a low level data rather than the text itself. 
            //May need "web3.utils.toAscii("insert address here");" to get the text
            emit ErrorLogBytes(LowLevelData);
        }
    }
}