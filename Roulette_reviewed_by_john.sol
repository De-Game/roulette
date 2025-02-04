// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract RouletteGame {
    // ----------------------------------
    // Constants
    // ----------------------------------

    // 0 to 36 and 00 (represented as 37);
    uint8 private constant RESULT_COUNT = 38;

    uint8 private constant OPTION_MAX = 49;

    // Bet Options for the roulette
    // 0 to 36 and 00 (represented as 37);
    uint8 private constant OPTION_STRAIGHT_UP_ZERO = 0;
    uint8 private constant OPTION_STRAIGHT_UP_ONE = 1;
    uint8 private constant OPTION_STRAIGHT_UP_TWO = 2;
    uint8 private constant OPTION_STRAIGHT_UP_THREE = 3;
    uint8 private constant OPTION_STRAIGHT_UP_FOUR = 4;
    uint8 private constant OPTION_STRAIGHT_UP_FIVE = 5;
    uint8 private constant OPTION_STRAIGHT_UP_SIX = 6;
    uint8 private constant OPTION_STRAIGHT_UP_SEVEN = 7;
    uint8 private constant OPTION_STRAIGHT_UP_EIGHT = 8;
    uint8 private constant OPTION_STRAIGHT_UP_NINE = 9;
    uint8 private constant OPTION_STRAIGHT_UP_TEN = 10;
    uint8 private constant OPTION_STRAIGHT_UP_ELEVEN = 11;
    uint8 private constant OPTION_STRAIGHT_UP_TWELVE = 12;
    uint8 private constant OPTION_STRAIGHT_UP_THIRTEEN = 13;
    uint8 private constant OPTION_STRAIGHT_UP_FOURTEEN = 14;
    uint8 private constant OPTION_STRAIGHT_UP_FIFTEEN = 15;
    uint8 private constant OPTION_STRAIGHT_UP_SIXTEEN = 16;
    uint8 private constant OPTION_STRAIGHT_UP_SEVENTEEN = 17;
    uint8 private constant OPTION_STRAIGHT_UP_EIGHTEEN = 18;
    uint8 private constant OPTION_STRAIGHT_UP_NINETEEN = 19;
    uint8 private constant OPTION_STRAIGHT_UP_TWENTY = 20;
    uint8 private constant OPTION_STRAIGHT_UP_TWENTY_ONE = 21;
    uint8 private constant OPTION_STRAIGHT_UP_TWENTY_TWO = 22;
    uint8 private constant OPTION_STRAIGHT_UP_TWENTY_THREE = 23;
    uint8 private constant OPTION_STRAIGHT_UP_TWENTY_FOUR = 24;
    uint8 private constant OPTION_STRAIGHT_UP_TWENTY_FIVE = 25;
    uint8 private constant OPTION_STRAIGHT_UP_TWENTY_SIX = 26;
    uint8 private constant OPTION_STRAIGHT_UP_TWENTY_SEVEN = 27;
    uint8 private constant OPTION_STRAIGHT_UP_TWENTY_EIGHT = 28;
    uint8 private constant OPTION_STRAIGHT_UP_TWENTY_NINE = 29;
    uint8 private constant OPTION_STRAIGHT_UP_THIRTY = 30;
    uint8 private constant OPTION_STRAIGHT_UP_THIRTY_ONE = 31;
    uint8 private constant OPTION_STRAIGHT_UP_THIRTY_TWO = 32;
    uint8 private constant OPTION_STRAIGHT_UP_THIRTY_THREE = 33;
    uint8 private constant OPTION_STRAIGHT_UP_THIRTY_FOUR = 34;
    uint8 private constant OPTION_STRAIGHT_UP_THIRTY_FIVE = 35;
    uint8 private constant OPTION_STRAIGHT_UP_THIRTY_SIX = 36;
    uint8 private constant OPTION_STRAIGHT_UP_ZERO_ZERO = 37;

    // Low or High
    uint8 private constant OPTION_LOW = 38;
    uint8[18] public OPTION_LOW_SET = [
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12,
        13,
        14,
        15,
        16,
        17,
        18
    ];
    function isInLowSet(uint8 number) public view returns (bool) {
        for (uint8 i = 0; i < OPTION_LOW_SET.length; i++) {
            if (OPTION_LOW_SET[i] == number) {
                return true; // Number found in the set
            }
        }
        return false; // Number not found in the set
    }

    uint8 private constant OPTION_HIGH = 39;
    uint8[18] public OPTION_HIGH_SET = [
        19,
        20,
        21,
        22,
        23,
        24,
        25,
        26,
        27,
        28,
        29,
        30,
        31,
        32,
        33,
        34,
        35,
        36
    ];
    function isInHighSet(uint8 number) public view returns (bool) {
        for (uint8 i = 0; i < OPTION_HIGH_SET.length; i++) {
            if (OPTION_HIGH_SET[i] == number) {
                return true; // Number found in the set
            }
        }
        return false; // Number not found in the set
    }

    // Red or Black
    uint8 private constant OPTION_RED = 40;
    uint8[18] public OPTION_RED_SET = [
        1,
        3,
        5,
        7,
        9,
        12,
        14,
        16,
        18,
        19,
        21,
        23,
        25,
        27,
        30,
        32,
        34,
        36
    ];
    function isInRedSet(uint8 number) public view returns (bool) {
        for (uint8 i = 0; i < OPTION_RED_SET.length; i++) {
            if (OPTION_RED_SET[i] == number) {
                return true; // Number found in the set
            }
        }
        return false; // Number not found in the set
    }

    uint8 private constant OPTION_BLACK = 41;
    uint8[18] public OPTION_BLACK_SET = [
        2,
        4,
        6,
        8,
        10,
        11,
        13,
        15,
        17,
        20,
        22,
        24,
        26,
        28,
        29,
        31,
        33,
        35
    ];
    function isInBlackSet(uint8 number) public view returns (bool) {
        for (uint8 i = 0; i < OPTION_BLACK_SET.length; i++) {
            if (OPTION_BLACK_SET[i] == number) {
                return true; // Number found in the set
            }
        }
        return false; // Number not found in the set
    }

    // Even or Odd
    uint8 private constant OPTION_EVEN = 42;
    uint8[18] public OPTION_EVEN_SET = [
        2,
        4,
        6,
        8,
        10,
        12,
        14,
        16,
        18,
        20,
        22,
        24,
        26,
        28,
        30,
        32,
        34,
        36
    ];
    function isInEvenSet(uint8 number) public view returns (bool) {
        for (uint8 i = 0; i < OPTION_EVEN_SET.length; i++) {
            if (OPTION_EVEN_SET[i] == number) {
                return true; // Number found in the set
            }
        }
        return false; // Number not found in the set
    }

    uint8 private constant OPTION_ODD = 43;
    uint8[18] public OPTION_ODD_SET = [
        1,
        3,
        5,
        7,
        9,
        11,
        13,
        15,
        17,
        19,
        21,
        23,
        25,
        27,
        29,
        31,
        33,
        35
    ];
    function isInOddSet(uint8 number) public view returns (bool) {
        for (uint8 i = 0; i < OPTION_ODD_SET.length; i++) {
            if (OPTION_ODD_SET[i] == number) {
                return true; // Number found in the set
            }
        }
        return false; // Number not found in the set
    }

    // Columns
    uint8 private constant OPTION_FIRST_COLUMN = 44;
    uint8[12] public OPTION_FIRST_COLUMN_SET = [
        1,
        4,
        7,
        10,
        13,
        16,
        19,
        22,
        25,
        28,
        31,
        34
    ];
    function isInFirstColumnSet(uint8 number) public view returns (bool) {
        for (uint8 i = 0; i < OPTION_FIRST_COLUMN_SET.length; i++) {
            if (OPTION_FIRST_COLUMN_SET[i] == number) {
                return true; // Number found in the set
            }
        }
        return false; // Number not found in the set
    }

    uint8 private constant OPTION_SECOND_COLUMN = 45;
    uint8[12] public OPTION_SECOND_COLUMN_SET = [
        2,
        5,
        8,
        11,
        14,
        17,
        20,
        23,
        26,
        29,
        32,
        35
    ];
    function isInSecondColumnSet(uint8 number) public view returns (bool) {
        for (uint8 i = 0; i < OPTION_SECOND_COLUMN_SET.length; i++) {
            if (OPTION_SECOND_COLUMN_SET[i] == number) {
                return true; // Number found in the set
            }
        }
        return false; // Number not found in the set
    }

    uint8 private constant OPTION_THIRD_COLUMN = 46;
    uint8[12] public OPTION_THIRD_COLUMN_SET = [
        3,
        6,
        9,
        12,
        15,
        18,
        21,
        24,
        27,
        30,
        33,
        36
    ];
    function isInThirdColumnSet(uint8 number) public view returns (bool) {
        for (uint8 i = 0; i < OPTION_THIRD_COLUMN_SET.length; i++) {
            if (OPTION_THIRD_COLUMN_SET[i] == number) {
                return true; // Number found in the set
            }
        }
        return false; // Number not found in the set
    }

    // Dozen
    uint8 private constant OPTION_FIRST_DOZEN = 47;
    uint8[12] public OPTION_FIRST_DOZEN_SET = [
        1,
        2,
        3,
        4,
        5,
        6,
        7,
        8,
        9,
        10,
        11,
        12
    ];
    function isInFirstDozenSet(uint8 number) public view returns (bool) {
        for (uint8 i = 0; i < OPTION_FIRST_DOZEN_SET.length; i++) {
            if (OPTION_FIRST_DOZEN_SET[i] == number) {
                return true; // Number found in the set
            }
        }
        return false; // Number not found in the set
    }

    uint8 private constant OPTION_SECOND_DOZEN = 48;
    uint8[12] public OPTION_SECOND_DOZEN_SET = [
        13,
        14,
        15,
        16,
        17,
        18,
        19,
        20,
        21,
        22,
        23,
        24
    ];
    function isInSecondDozenSet(uint8 number) public view returns (bool) {
        for (uint8 i = 0; i < OPTION_SECOND_DOZEN_SET.length; i++) {
            if (OPTION_SECOND_DOZEN_SET[i] == number) {
                return true; // Number found in the set
            }
        }
        return false; // Number not found in the set
    }

    uint8 private constant OPTION_THIRD_DOZEN = 49;
    uint8[12] public OPTION_THIRD_DOZEN_SET = [
        25,
        26,
        27,
        28,
        29,
        30,
        31,
        32,
        33,
        34,
        35,
        36
    ];
    function isInThirdDozenSet(uint8 number) public view returns (bool) {
        for (uint8 i = 0; i < OPTION_THIRD_DOZEN_SET.length; i++) {
            if (OPTION_THIRD_DOZEN_SET[i] == number) {
                return true; // Number found in the set
            }
        }
        return false; // Number not found in the set
    }

    // Odds
    // Maximum odds is 37
    uint256 private constant ODDS_MAX = 3700;

    // scaling factor because solidity did not support floating number
    uint256 private constant ODDS_SCALE_FACTOR = 100;

    // odss for straight up
    uint256 private constant ODDS_STRAIGHT_UP = 3700;

    // odds for low or high
    uint256 private constant ODDS_LOW_OR_HIGH = 111;

    // odds for red or black
    uint256 private constant ODDS_RED_OR_BLACK = 111;

    // odds for even or odd
    uint256 private constant ODDS_EVEN_OR_ODD = 111;

    // odds for columns
    uint256 private constant ODDS_COLUMNS = 217;

    // odds for dozen
    uint256 private constant ODDS_DOZEN = 217;

    // Status
    uint8 private constant STATUS_PENDING_HOST_DEPOSIT = 0;
    uint8 private constant STATUS_PENDING_PLAYER_BET = 1;
    uint8 private constant STATUS_NO_MORE_BETS = 2;
    uint8 private constant STATUS_RESULT_GENERATED = 3;
    uint8 private constant STATUS_RESULT_VALIDATED = 4;

    // Offset to make the result immutable
    uint8 private constant BLOCK_NUMBER_OFFSET = 12;

    // ----------------------------------
    // Events
    // ----------------------------------
    event GameCreated(
        address indexed host,
        uint256 minBet,
        address[] validators,
        uint8 valid_threshold
    );
    event DepositPlaced(address indexed host, uint256 amount);
    event BetPlaced(address indexed player, uint8 option, uint256 amount);
    event NoMoreBets(uint256 cutOffBlockNumber);
    event ResultGenerated(uint8 result);
    event ResultValidated(uint8 result);
    event BetPayout(address indexed player, uint8 option, uint256 amount);
    event GameEnded(address indexed host, uint256 amount);
    // New event to prove step-by-step hashing
    event ProofStep(uint8 stepIndex, bytes intermediateHash);

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
    uint8 public validate_threshold;
    //validator arry
    address[] public validators;
    address[] public signedValidators;
    //mini
    uint256 public minDeposite;
    //max deposite (optional?)
    uint256 public maxBet;

    // ----------------------------------
    // Constructor
    // ----------------------------------
    //**** Tempory allow input the validator address for testing purpose
    constructor(
        address _host,
        uint256 _minBet,
        address[] memory _validators,
        uint8 _valid_threshold
    ) {
        host = _host;
        minBet = _minBet;
        status = STATUS_PENDING_HOST_DEPOSIT;
        validators = _validators;
        validate_threshold = _valid_threshold;
        emit GameCreated(_host, _minBet, _validators, _valid_threshold);
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
        require(option <= 49, "Option must be between 0 and 37");
        require(msg.value >= minBet, "Bet amount is below the minimum bet");
        require(
            msg.value < (address(this).balance * ODDS_MAX) / ODDS_SCALE_FACTOR,
            "Bet amount is above the maximum bet"
        );

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
        bytes32 randomBlockHash = blockhash(cutOffBlockNumber + 1);

        // we use host address and player address to generate random hash as salt
        bytes memory packedData = abi.encodePacked(host);
        for (uint256 i = 0; i < bets.length; i++) {
            packedData = abi.encodePacked(packedData, bets[i].player);
        }

        bytes32 randomHash = keccak256(
            abi.encodePacked(randomBlockHash, packedData)
        );

        //adding RNG???

        // Naive pseudo-randomness based on the blockhash
        uint256 randomNumber = uint256(randomHash);
        result = uint8(randomNumber % RESULT_COUNT); // Random number between 0 and 37

        status = STATUS_RESULT_GENERATED;
        emit ResultGenerated(result);
    }

    // this function should be called by third party validator for mulitple signature validation
    // ----------------------------------
    // Validator Logic
    // ----------------------------------
    function isValidator(address _caller) internal view returns (bool) {
        for (uint256 i = 0; i < validators.length; i++) {
            if (validators[i] == _caller) {
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
        bytes32 randomBlockHash = blockhash(cutOffBlockNumber + 1);
        emit ProofStep(stepIndex, abi.encode(randomBlockHash));
        stepIndex++;

        // we use host address and player address to generate random hash as salt
        bytes memory packedData = abi.encodePacked(host);
        for (uint256 i = 0; i < bets.length; i++) {
            packedData = abi.encodePacked(packedData, bets[i].player);
        }
        emit ProofStep(stepIndex, packedData);
        stepIndex++;

        // Step 2: Include the host address
        bytes32 randomHash = keccak256(
            abi.encodePacked(randomBlockHash, packedData)
        );
        emit ProofStep(stepIndex, abi.encode(randomHash));
        stepIndex++;

        // Compute final random result
        uint256 randomNumber = uint256(randomHash);
        uint8 recomputedResult = uint8(randomNumber % RESULT_COUNT);

        // Compare
        require(
            recomputedResult == result,
            "Stored result != recomputed result"
        );

        signedValidators.push(msg.sender);
        if (signedValidators.length >= validate_threshold) {
            emit ResultValidated(result);
            status = STATUS_RESULT_VALIDATED;
            settleBet();
        }
    }

    //
    function settleBet() public {
        require(status == STATUS_RESULT_VALIDATED, "Result not validated yet");

        // Assume only one player versus the host, we can directly settle the bet, i.e. no need to wait for the host to call it
        // require(msg.sender == host, "Only host can settle the bet");
        for (uint256 i = 0; i < bets.length; i++) {
            if (bets[i].option >= 0 && bets[i].option <= 37) {
                // straight up
                if (bets[i].option == result) {
                    // Player wins
                    payable(bets[i].player).transfer(
                        (bets[i].amount * ODDS_STRAIGHT_UP) / ODDS_SCALE_FACTOR
                    );
                    emit BetPayout(
                        bets[i].player,
                        bets[i].option,
                        (bets[i].amount * ODDS_STRAIGHT_UP) / ODDS_SCALE_FACTOR
                    );
                }
                break;
            } else if (bets[i].option == 38) {
                // low
                if (isInLowSet(result)) {
                    // Player wins
                    payable(bets[i].player).transfer(
                        (bets[i].amount * ODDS_LOW_OR_HIGH) / ODDS_SCALE_FACTOR
                    );
                    emit BetPayout(
                        bets[i].player,
                        bets[i].option,
                        (bets[i].amount * ODDS_LOW_OR_HIGH) / ODDS_SCALE_FACTOR
                    );
                }
                break;
            } else if (bets[i].option == 39) {
                if (isInHighSet(result)) {
                    // Player wins
                    payable(bets[i].player).transfer(
                        (bets[i].amount * ODDS_LOW_OR_HIGH) / ODDS_SCALE_FACTOR
                    );
                    emit BetPayout(
                        bets[i].player,
                        bets[i].option,
                        (bets[i].amount * ODDS_LOW_OR_HIGH) / ODDS_SCALE_FACTOR
                    );
                }
                break;
            } else if (bets[i].option == 40) {
                if (isInRedSet(result)) {
                    // Player wins
                    payable(bets[i].player).transfer(
                        (bets[i].amount * ODDS_RED_OR_BLACK) / ODDS_SCALE_FACTOR
                    );
                    emit BetPayout(
                        bets[i].player,
                        bets[i].option,
                        (bets[i].amount * ODDS_RED_OR_BLACK) / ODDS_SCALE_FACTOR
                    );
                }
                break;
            } else if (bets[i].option == 41) {
                if (isInBlackSet(result)) {
                    // Player wins
                    payable(bets[i].player).transfer(
                        (bets[i].amount * ODDS_RED_OR_BLACK) / ODDS_SCALE_FACTOR
                    );
                    emit BetPayout(
                        bets[i].player,
                        bets[i].option,
                        (bets[i].amount * ODDS_RED_OR_BLACK) / ODDS_SCALE_FACTOR
                    );
                }
                break;
            } else if (bets[i].option == 42) {
                if (isInEvenSet(result)) {
                    // Player wins
                    payable(bets[i].player).transfer(
                        (bets[i].amount * ODDS_EVEN_OR_ODD) / ODDS_SCALE_FACTOR
                    );
                    emit BetPayout(
                        bets[i].player,
                        bets[i].option,
                        (bets[i].amount * ODDS_EVEN_OR_ODD) / ODDS_SCALE_FACTOR
                    );
                }
                break;
            } else if (bets[i].option == 43) {
                if (isInOddSet(result)) {
                    // Player wins
                    payable(bets[i].player).transfer(
                        (bets[i].amount * ODDS_EVEN_OR_ODD) / ODDS_SCALE_FACTOR
                    );
                    emit BetPayout(
                        bets[i].player,
                        bets[i].option,
                        (bets[i].amount * ODDS_EVEN_OR_ODD) / ODDS_SCALE_FACTOR
                    );
                }
                break;
            } else if (bets[i].option == 44) {
                if (isInFirstColumnSet(result)) {
                    // Player wins
                    payable(bets[i].player).transfer(
                        (bets[i].amount * ODDS_COLUMNS) / ODDS_SCALE_FACTOR
                    );
                    emit BetPayout(
                        bets[i].player,
                        bets[i].option,
                        (bets[i].amount * ODDS_COLUMNS) / ODDS_SCALE_FACTOR
                    );
                }
            } else if (bets[i].option == 45) {
                if (isInSecondColumnSet(result)) {
                    // Player wins
                    payable(bets[i].player).transfer(
                        (bets[i].amount * ODDS_COLUMNS) / ODDS_SCALE_FACTOR
                    );
                    emit BetPayout(
                        bets[i].player,
                        bets[i].option,
                        (bets[i].amount * ODDS_COLUMNS) / ODDS_SCALE_FACTOR
                    );
                }
            } else if (bets[i].option == 46) {
                if (isInThirdColumnSet(result)) {
                    // Player wins
                    payable(bets[i].player).transfer(
                        (bets[i].amount * ODDS_COLUMNS) / ODDS_SCALE_FACTOR
                    );
                    emit BetPayout(
                        bets[i].player,
                        bets[i].option,
                        (bets[i].amount * ODDS_COLUMNS) / ODDS_SCALE_FACTOR
                    );
                }
            } else if (bets[i].option == 47) {
                if (isInFirstDozenSet(result)) {
                    // Player wins
                    payable(bets[i].player).transfer(
                        (bets[i].amount * ODDS_DOZEN) / ODDS_SCALE_FACTOR
                    );
                    emit BetPayout(
                        bets[i].player,
                        bets[i].option,
                        (bets[i].amount * ODDS_DOZEN) / ODDS_SCALE_FACTOR
                    );
                }
            } else if (bets[i].option == 48) {
                if (isInSecondDozenSet(result)) {
                    // Player wins
                    payable(bets[i].player).transfer(
                        (bets[i].amount * ODDS_DOZEN) / ODDS_SCALE_FACTOR
                    );
                    emit BetPayout(
                        bets[i].player,
                        bets[i].option,
                        (bets[i].amount * ODDS_DOZEN) / ODDS_SCALE_FACTOR
                    );
                }
            } else if (bets[i].option == 49) {
                if (isInThirdDozenSet(result)) {
                    // Player wins
                    payable(bets[i].player).transfer(
                        (bets[i].amount * ODDS_DOZEN) / ODDS_SCALE_FACTOR
                    );
                    emit BetPayout(
                        bets[i].player,
                        bets[i].option,
                        (bets[i].amount * ODDS_DOZEN) / ODDS_SCALE_FACTOR
                    );
                }
            }
        }
        emit GameEnded(host, address(this).balance);
        payable(host).transfer(address(this).balance);
    }
}
