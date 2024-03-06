pragma solidity ^0.8.0;

contract FuzzTest {
    uint public counter;

    function increment() public {
        counter++;
    }
}