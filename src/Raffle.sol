// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import "@chainlink/contracts/src/v0.8/vrf/VRFConsumerBaseV2.sol";

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
    //@dev The time interval between raffles is in seconds
    uint256 private immutable i_interval;
    address payable[] private s_players;

    uint256 private s_lastTimeStamp;

    /* Events */
    event RaffleEntered(address indexed player);
    event DiceRolled(uint256 indexed requestId, address indexed roller);

    constructor(uint256 entranceFee, uint256 interval) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_lastTimeStamp = block.timestamp;
    }

    function enterRaffle() external payable {
        if (msg.value <= i_entranceFee) {
            revert Raffle_SendMoreToEnterRaffle();
        }
        s_players.push(payable(msg.sender));

        emit RaffleEntered(msg.sender);
    }

    // 1. Get a random number
    // 2. Use the random number to pick a winner

    function pickWinner() external {
        if (block.timestamp - s_lastTimeStamp < i_interval) {
            revert Raffle_RaffleNotOpen();
        }

        // get random number from chainlink vrf
        // 1. Request RNG
        requestId = COORDINATOR.requestRandomWords(
            s_keyHash,
            s_subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );

        s_rollers[requestId] = roller;
        s_results[roller] = ROLL_IN_PROGRESS;
        emit DiceRolled(requestId, roller);

        // 2. Wait for the callback and get RNG
    }

    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}
