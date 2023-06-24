// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../implementation/Sender.sol";
import "../implementation/Greeting.sol";

contract SenderTest is Test {
    Sender public sender;
    function setUp() public {
        sender = new Sender();
    }
    function test_Fuzz_Sender(uint256 x) public {

        // We first send 1 Eth to the Sender contract.
        (bool success,) = address(sender).call{value: 1 ether}("");
        assertTrue(success);

        // We try to drain the contract.
        sender.guess(x);
        assertEq(address(sender).balance, 1 ether);
    }
}

contract GreetingTest is Test {

    function test_Fuzz_Greeting(string memory _greeting) public {
      HelloWorld hello = new HelloWorld(_greeting);
      assertEq(
          hello.greet(),
          _greeting
      );
  }
}
