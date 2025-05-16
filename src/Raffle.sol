// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {VRFConsumerBaseV2Plus} from "@chainlink/contracts/src/v0.8/vrf/dev/VRFConsumerBaseV2Plus.sol";
import {VRFV2PlusClient} from "@chainlink/contracts/src/v0.8/vrf/dev/libraries/VRFV2PlusClient.sol";
/**
 * @title A sample Raffle contract
 * @author Thanh
 * @notice This contract is for creating a sample raffle
 * @dev This implements the Chainlink VRF Version 2
 */
contract Raffle is VRFConsumerBaseV2Plus {
    /* Errors Errors*/
    error Raffle_SendMoreToEnterRaffle();
    error Raffle_RaffleNotOpen();

    uint256 private immutable i_entranceFee;
    //@dev The time interval between raffles is in seconds
    uint256 private immutable i_interval;
    address payable[] private s_players;

    // variable for VRF contracts

    uint16 private constant REQUEST_CONFIRMATION = 3;
    uint32 private constant NUM_WORDS = 1;

    bytes32 private immutable i_keyHash;
    uint64 private immutable i_subscriptionId;
    uint32 private immutable i_callbackGasLimit;
    bool private immutable i_enableNativePayment;

    uint256 private s_lastTimeStamp;

    /* Events */
    event RaffleEntered(address indexed player);
    event DiceRolled(uint256 indexed requestId, address indexed roller);

    constructor(
        uint256 entranceFee,
        uint256 interval,
        address vrfCoordinator,
        bytes32 gasLane,
        uint64 subscriptionId,
        uint32 callbackGasLimit,
        bool enableNativePayment
    ) VRFConsumerBaseV2Plus(vrfCoordinator) {
        i_entranceFee = entranceFee;
        i_interval = interval;
        s_lastTimeStamp = block.timestamp;
        i_keyHash = gasLane;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;
        i_enableNativePayment = enableNativePayment;
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

    function pickWinner() external view {
        if (block.timestamp - s_lastTimeStamp < i_interval) {
            revert Raffle_RaffleNotOpen();
        }

        // get random number from chainlink vrf
        // 1. Request RNG
        VRFV2PlusClient.RandomWordsRequest memory request = VRFV2PlusClient
            .RandomWordsRequest({
                keyHash: i_keyHash,
                subId: i_subscriptionId,
                requestConfirmations: REQUEST_CONFIRMATION,
                callbackGasLimit: CALLBACK_GAS_LIMIT,
                numWords: NUM_WORDS,
                extraArgs: VRFV2PlusClient._argsToBytes(
                    VRFV2PlusClient.ExtraArgsV1({
                        nativePayment: enableNativePayment
                    })
                )
            });

        uint256 requestId = s_vrfCoordinator.requestRandomWords(request);

        // 2. Wait for the callback and get RNG
    }

    function fulfillRandomWords(
        uint256 requestId,
        uint256[] calldata randomWords
    ) internal override {}

    function getEntranceFee() external view returns (uint256) {
        return i_entranceFee;
    }
}
