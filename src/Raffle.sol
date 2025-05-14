// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

/**
 * @title A sample Raffle contract
 * @author Thanh
 * @notice This contract is for creating a sample raffle
 * @dev This implements the Chainlink VRF Version 2
 */
contract Raffle {
    /* Errors Errors*/
    error Raffle_SendMoreToEnterRaffle();

    uint256 private immutable i_entranceFee;
    address payable[] private s_players;

    /* Events */
    event RaffleEntered(address indexed player);

    constructor(uint256 entranceFee) {
        i_entranceFee = entranceFee;
    }

    function enterRaffle() public payable {
        if (msg.value <= i_entranceFee) {
            revert Raffle_SendMoreToEnterRaffle();
        }
        s_players.push(payable(msg.sender));

        emit RaffleEntered(msg.sender);
    }

    function pickWinner() public {}

    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}
