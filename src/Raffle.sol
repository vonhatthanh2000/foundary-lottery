// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

/**
 * @title A sample Raffle contract
 * @author Thanh
 * @notice This contract is for creating a sample raffle
 * @dev This implements the Chainlink VRF Version 2
 */
contract Raffle {
    uint256 private immutable i_entranceFee;

    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
    }

    function enterRaffle() public payable {}

    function pickWinner() public {}

    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}
