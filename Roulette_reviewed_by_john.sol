// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract RouletteGame {
    // ----------------------------------
    // Constants
    // ----------------------------------
    uint8 private constant OPTION_TOTAL_COUNT = 38;

    // Options for the roulette
    // 0 to 36 and 00 (represented as 37)
    uint8 private constant OPTION_ZERO = 0;
    uint8 private constant OPTION_ONE = 1;
    uint8 private constant OPTION_TWO = 2;
    uint8 private constant OPTION_THREE = 3;
    uint8 private constant OPTION_FOUR = 4;
    uint8 private constant OPTION_FIVE = 5;
    uint8 private constant OPTION_SIX = 6;
    uint8 private constant OPTION_SEVEN = 7;
    uint8 private constant OPTION_EIGHT = 8;
    uint8 private constant OPTION_NINE = 9;
    uint8 private constant OPTION_TEN = 10;
    uint8 private constant OPTION_ELEVEN = 11;
    uint8 private constant OPTION_TWELVE = 12;
    uint8 private constant OPTION_THIRTEEN = 13;
    uint8 private constant OPTION_FOURTEEN = 14;
    uint8 private constant OPTION_FIFTEEN = 15;
    uint8 private constant OPTION_SIXTEEN = 16;
    uint8 private constant OPTION_SEVENTEEN = 17;
    uint8 private constant OPTION_EIGHTEEN = 18;
    uint8 private constant OPTION_NINETEEN = 19;
    uint8 private constant OPTION_TWENTY = 20;
    uint8 private constant OPTION_TWENTY_ONE = 21;
    uint8 private constant OPTION_TWENTY_TWO = 22;
    uint8 private constant OPTION_TWENTY_THREE = 23;
    uint8 private constant OPTION_TWENTY_FOUR = 24;
    uint8 private constant OPTION_TWENTY_FIVE = 25;
    uint8 private constant OPTION_TWENTY_SIX = 26;
    uint8 private constant OPTION_TWENTY_SEVEN = 27;
    uint8 private constant OPTION_TWENTY_EIGHT = 28;
    uint8 private constant OPTION_TWENTY_NINE = 29;
    uint8 private constant OPTION_THIRTY = 30;
    uint8 private constant OPTION_THIRTY_ONE = 31;
    uint8 private constant OPTION_THIRTY_TWO = 32;
    uint8 private constant OPTION_THIRTY_THREE = 33;
    uint8 private constant OPTION_THIRTY_FOUR = 34;
    uint8 private constant OPTION_THIRTY_FIVE = 35;
    uint8 private constant OPTION_THIRTY_SIX = 36;
    uint8 private constant OPTION_ZERO_ZERO = 37;

    uint8 private constant ODDS_MAX = 37;
    uint8 private constant ODDS_STRAIGHT_UP = 37;

    uint8 private constant STATUS_PENDING_HOST_DEPOSIT = 0;
    uint8 private constant STATUS_PENDING_PLAYER_BET = 1;
    uint8 private constant STATUS_NO_MORE_BETS = 2;
    uint8 private constant STATUS_RESULT_GENERATED = 3;
    uint8 private constant STATUS_RESULT_VALIDATED = 4;

    uint8 private constant BLOCK_NUMBER_OFFSET = 12;



    // ----------------------------------
    // Events
    // ----------------------------------
    event GameCreated(address indexed host, uint256 minBet);
    event DepositPlaced(address indexed host, uint256 amount);
    event BetPlaced(address indexed player, uint8 option, uint256 amount);
    event NoMoreBets(uint256 cutOffBlockNumber);
    event ResultGenerated(uint8 result);
    event ResultValidated(uint8 result);
    event BetPayout(address indexed player, uint8 option, uint256 amount);
    event GameEnded(address indexed host, uint256 amount);
    // New event to prove step-by-step hashing
    event ProofStep(uint8 stepIndex, bytes32 intermediateHash);

    // ----------------------------------
    // Struct
    // ----------------------------------
    struct Bet {
        address player;
        uint8 option; // option: [0, 37], where 0-36 are the numbers and 37 is 00
        uint256 amount;
    }

    // ----------------------------------
    // Variables
    // ----------------------------------
    address public host;
    uint256 public minBet;
    uint8 public status;
    Bet[] public bets;
    uint256 public cutOffBlockNumber;
    uint8 public result;
    //add threshold
    uint8 public Authen_threshold;
    //validator arry
    address[] public validator_address;
    //mini 
    uint256 public minDeposite;
    //max deposite (optional?)
    uint256 public maxBet;

    // ----------------------------------
    // Constructor
    // ----------------------------------
    //**** Tempory allow input the validator address for testing purpose
    constructor(address _host, uint256 _minBet, address[] memory _validatorAddressList) {
        host = _host;
        minBet = _minBet;
        status = STATUS_PENDING_HOST_DEPOSIT;
        validator_address = _validatorAddressList;
        emit GameCreated(_host, _minBet);
    }

    // ----------------------------------
    // Public / External Functions
    // ----------------------------------
    function getStatus() public view returns (uint8) {
        return status;
    }

    function getBetsCount() public view returns (uint256) {
        return bets.length;
    }

    function getTotalBetsAmount() public view returns (uint256) {
        uint256 totalAmount = 0;
        for (uint256 i = 0; i < bets.length; i++) {
            totalAmount += bets[i].amount;
        }
        return totalAmount;
    }

    function deposit() public payable {
        require(
            status == STATUS_PENDING_HOST_DEPOSIT,
            "Deposit is not allowed"
        );
        require(msg.sender == host, "Only host can deposit");

        status = STATUS_PENDING_PLAYER_BET;
        emit DepositPlaced(msg.sender, msg.value);
    }

    function placeBet(uint8 option) public payable {
        require(option <= 37, "Number must be between 0 and 37");
        require(msg.value >= minBet, "Bet amount is below the minimum bet");

        bets.push(Bet({player: msg.sender, option: option, amount: msg.value}));
        emit BetPlaced(msg.sender, option, msg.value);

        // Assume only one player versus the host, we can directly call noMoreBets, i.e. no need to wait for the host to call it
        noMoreBets();
    }

    function noMoreBets() public {
        require(status == STATUS_PENDING_PLAYER_BET, "No more bets allowed");

        // Assume only one player versus the host, we can directly call noMoreBets, i.e. no need to wait for the host to call it
        // require(msg.sender == host, "Only host can call no more bets");

        status = STATUS_NO_MORE_BETS;
        cutOffBlockNumber = block.number;
        emit NoMoreBets(cutOffBlockNumber);
    }


    // wait at least 12 blocks before calling this function
    function generateResult() public {
        require(status == STATUS_NO_MORE_BETS, "No more bets allowed");
        require(msg.sender == host, "Only host can generate result");

        // Ensure the block number is reached for randomness
        require(
            block.number >= cutOffBlockNumber + BLOCK_NUMBER_OFFSET + 1,
            "Block number not reached"
        );

        // Get the block hash of the earlier block
        bytes32 randomHash = blockhash(cutOffBlockNumber + 1);
        // adding host to generate randomhash
        randomHash = keccak256(abi.encodePacked(randomHash, host));
        //adding hash of all players
        for (uint256 i = 0; i < bets.length; i++) {
            randomHash = keccak256(
                abi.encodePacked(randomHash, bets[i].player)
            );
        }
        //adding RNG???

        // Naive pseudo-randomness based on the blockhash
        uint256 randomNumber = uint256(randomHash);
        result = uint8(randomNumber % OPTION_TOTAL_COUNT); // Random number between 0 and 37

        status = STATUS_RESULT_GENERATED;
        emit ResultGenerated(result);
    }

    // this function should be called by third party validator for mulitple signature validation
    // ----------------------------------
    // Validator Logic
    // ----------------------------------
    function isValidator(address _caller) internal view returns (bool) {
        for (uint256 i = 0; i < validator_address.length; i++) {
            if (validator_address[i] == _caller) {
                return true;
            }
        }
        return false;
    }

    /**
     * @dev validateResult re-computes the random hash in a step-by-step manner.
     *      For each step, it emits a ProofStep event, so it can be verified on-chain.
     *      If the final result does not match the contract's stored `result`, it reverts.
     */
    function validateResult() public {
        require(status == STATUS_RESULT_GENERATED, "Result not generated");
        require(isValidator(msg.sender), "Only a validator can validate");

        // Step-by-step recomputation of the random seed
        uint8 stepIndex = 1;

        // Step 1: Start from the block hash
        bytes32 checkHash = blockhash(cutOffBlockNumber + 1);
        emit ProofStep(stepIndex, checkHash);
        stepIndex++;

        // Step 2: Include the host address
        checkHash = keccak256(abi.encodePacked(checkHash, host));
        emit ProofStep(stepIndex, checkHash);
        stepIndex++;

        // Steps 3..(3 + bets.length - 1): Include each player
        for (uint256 i = 0; i < bets.length; i++) {
            checkHash = keccak256(abi.encodePacked(checkHash, bets[i].player));
            emit ProofStep(stepIndex, checkHash);
            stepIndex++;
        }

        // Compute final random result
        uint8 recomputedResult = uint8(uint256(checkHash) % OPTION_TOTAL_COUNT);

        // Compare
        require(
            recomputedResult == result,
            "Stored result != recomputed result"
        );

        // If successful, mark validated, then settle
        emit ResultValidated(result);
        status = STATUS_RESULT_VALIDATED;
        settleBet();
    }

    //
    function settleBet() public {
        require(status == STATUS_RESULT_VALIDATED, "Result not validated yet");

        // Assume only one player versus the host, we can directly settle the bet, i.e. no need to wait for the host to call it
        // require(msg.sender == host, "Only host can settle the bet");
        for (uint256 i = 0; i < bets.length; i++) {
            // assume always straight up bet first, add more logic for other bet types later
            if (bets[i].option == result) {
                // Player wins
                uint256 payout = bets[i].amount * ODDS_STRAIGHT_UP;
                payable(bets[i].player).transfer(payout);
                emit BetPayout(bets[i].player, bets[i].option, payout);
            }
        }
        emit GameEnded(host, address(this).balance);
        payable(host).transfer(address(this).balance);
    }
}
