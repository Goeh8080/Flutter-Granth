// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract GranthRegistry {
    string[] public granths;

    function add(string calldata title) external {
        granths.push(title);
    }
}
// Granth list sample — prints titles in order.
// Granth list sample Grant
