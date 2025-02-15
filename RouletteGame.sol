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

    // Payout
    // Maximum odds is 37
    uint256 private constant PAYOUT_MAX = 360;

    // scaling factor because solidity did not support floating number
    uint256 private constant PAYOUT_SCALE_FACTOR = 10;

    // payout for straight up
    uint256 private constant PAYOUT_STRAIGHT_UP = 360;

    // payout for low or high
    uint256 private constant PAYOUT_LOW_OR_HIGH = 20;

    // payout for red or black
    uint256 private constant PAYOUT_RED_OR_BLACK = 20;

    // payout for even or odd
    uint256 private constant PAYOUT_EVEN_OR_ODD = 20;

    // payout for columns
    uint256 private constant PAYOUT_COLUMNS = 15;

    // payout for dozen
    uint256 private constant PAYOUT_DOZEN = 15;

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
    event ProofStep(
        uint8 stepIndex,
        string explanation,
        bytes intermediateHash
    );
    //event ProofStepStringified(string stepDetails);

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
    // Private / Internal Functions
    // ----------------------------------
    function _uint2str(uint256 _i) private pure returns (string memory) {
        if (_i == 0) {
            return "0"; // Ensure zero is handled correctly
        }

        uint256 j = _i;
        uint256 length = 0;

        // Calculate number of digits in _i
        while (j != 0) {
            length++;
            j /= 10;
        }

        // Create a bytes array of correct size
        bytes memory bstr = new bytes(length);

        uint256 k = length; // Initialize k with length

        j = _i;
        while (j != 0) {
            k--; // Move index before assignment to avoid underflow
            bstr[k] = bytes1(uint8(48 + (j % 10))); // Convert last digit to ASCII
            j /= 10;
        }

        return string(bstr);
    }
    function _bytes32ToHexString(
        bytes32 data
    ) private pure returns (string memory) {
        bytes memory hexChars = "0123456789abcdef";
        bytes memory str = new bytes(66); // "0x" + 64 hex chars
        str[0] = "0";
        str[1] = "x";
        for (uint256 i = 0; i < 32; i++) {
            // each byte splits into two hex characters
            str[2 + i * 2] = hexChars[uint8(data[i] >> 4)];
            str[3 + i * 2] = hexChars[uint8(data[i] & 0x0f)];
        }
        return string(str);
    }

    function _bytesToHexString(
        bytes memory data
    ) private pure returns (string memory) {
        bytes memory hexChars = "0123456789abcdef";
        bytes memory str = new bytes(data.length * 2 + 2); // "0x" + 2 chars per byte
        str[0] = "0";
        str[1] = "x";
        for (uint256 i = 0; i < data.length; i++) {
            str[2 + i * 2] = hexChars[uint8(data[i] >> 4)];
            str[3 + i * 2] = hexChars[uint8(data[i] & 0x0f)];
        }
        return string(str);
    }
    /**
     * @dev Convert a single address to a 0x-prefixed hex string.
     */
    function _addressToString(
        address _addr
    ) private pure returns (string memory) {
        bytes memory hexChars = "0123456789abcdef";
        bytes20 data = bytes20(_addr);
        bytes memory str = new bytes(42); // "0x" + 40 hex chars
        str[0] = "0";
        str[1] = "x";
        for (uint256 i = 0; i < 20; i++) {
            str[2 + i * 2] = hexChars[uint8(data[i] >> 4)];
            str[3 + i * 2] = hexChars[uint8(data[i] & 0x0f)];
        }
        return string(str);
    }

    /**
     * @dev Convert an array of addresses into a bracketed list of hex strings.
     *      Example: "[0xAb84..., 0x4B20...]"
     */
    function _addressesToString(
        address[] memory _addrs
    ) private pure returns (string memory) {
        if (_addrs.length == 0) {
            return "[]";
        }

        bytes memory add_result = "[";

        for (uint256 i = 0; i < _addrs.length; i++) {
            add_result = abi.encodePacked(
                add_result,
                _addressToString(_addrs[i])
            );
            if (i < _addrs.length - 1) {
                add_result = abi.encodePacked(add_result, ", ");
            }
        }
        add_result = abi.encodePacked(add_result, "]");
        return string(add_result);
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
        require(msg.value > 0, "Invalid deposit amount");

        status = STATUS_PENDING_PLAYER_BET;
        emit DepositPlaced(msg.sender, msg.value);
    }

    function placeBet(uint8 option) public payable {
        require(option <= 49, "Option must be between 0 and 37");
        require(msg.value >= minBet, "Bet amount is below the minimum bet");
        require(
            msg.value <
                (address(this).balance * PAYOUT_MAX) / PAYOUT_SCALE_FACTOR,
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
     *      For each step, it emits a ProofStep event with a layman-friendly message
     *      and the raw data used at that step for verification.
     *
     *      This version also:
     *       - Prints the exact block number used.
     *       - Shows the blockhash in hex form.
     *       - Shows the array of addresses (host + players) in a bracketed list.
     *       - Emits the raw data in the event logs for cryptographic verification.
     */
    function validateResult() public {
        // Ensure the result was already generated
        require(status == STATUS_RESULT_GENERATED, "Result not generated");

        // Ensure we have waited at least the required blocks
        require(
            block.number >= cutOffBlockNumber + BLOCK_NUMBER_OFFSET + 1,
            "Wait at least 12 blocks after generation"
        );

        // Only designated validators can validate
        require(isValidator(msg.sender), "Only a validator can validate");

        // ----------------------------------
        // STEP 1: Retrieve the block hash from (cutOffBlockNumber + 1)
        // ----------------------------------
        uint256 usedBlockNumber = cutOffBlockNumber + 1;
        bytes32 randomBlockHash = blockhash(usedBlockNumber);

        // Emit block number + blockhash in a readable explanation
        emit ProofStep(
            1,
            string(
                abi.encodePacked(
                    "Blockhash from block #",
                    _uint2str(usedBlockNumber),
                    ": ",
                    _bytes32ToHexString(randomBlockHash),
                    " - basis for randomness"
                )
            ),
            // The data field: both the numeric block number and the bytes32 blockhash
            abi.encode(usedBlockNumber, randomBlockHash)
        );

        // ----------------------------------
        // STEP 2: Gather addresses into an array [host, all players]
        // ----------------------------------
        address[] memory addrList = new address[](bets.length + 1);
        addrList[0] = host;
        for (uint256 i = 0; i < bets.length; i++) {
            addrList[i + 1] = bets[i].player;
        }

        // Convert the address array to a bracketed list for readability
        string memory addrListString = _addressesToString(addrList);

        // Also build the "packed" bytes as done in generateResult() for hashing
        bytes memory packedData = abi.encodePacked(host);
        for (uint256 j = 0; j < bets.length; j++) {
            packedData = abi.encodePacked(packedData, bets[j].player);
        }

        // Emit the array in bracketed string form, raw array data in the event logs
        emit ProofStep(
            2,
            string(
                abi.encodePacked(
                    "Addresses used for randomness: ",
                    addrListString
                )
            ),
            abi.encode(addrList) // raw array
        );

        // Optionally, show the packed data in hex form too
        emit ProofStep(
            3,
            string(
                abi.encodePacked(
                    "Packed data of addresses in hex: ",
                    _bytesToHexString(packedData)
                )
            ),
            packedData
        );

        // ----------------------------------
        // STEP 4: keccak256 of [blockhash + packedData]
        // ----------------------------------
        bytes32 randomHash = keccak256(
            abi.encodePacked(randomBlockHash, packedData)
        );
        emit ProofStep(
            4,
            string(
                abi.encodePacked(
                    "Keccak256 of [blockhash + packedData]: ",
                    _bytes32ToHexString(randomHash)
                )
            ),
            abi.encode(randomHash)
        );

        // ----------------------------------
        // STEP 5: Take that hash % RESULT_COUNT for final outcome
        // ----------------------------------
        uint256 randomNumber = uint256(randomHash);
        uint8 recomputedResult = uint8(randomNumber % RESULT_COUNT);

        emit ProofStep(
            5,
            string(
                abi.encodePacked(
                    "Final random outcome (mod ",
                    _uint2str(RESULT_COUNT),
                    "): ",
                    _uint2str(recomputedResult)
                )
            ),
            abi.encode(recomputedResult)
        );

        // ----------------------------------
        // STEP 6: Ensure matches the stored result
        // ----------------------------------
        require(
            recomputedResult == result,
            "Stored result != recomputed result"
        );

        // Record this validator's signature
        signedValidators.push(msg.sender);

        // If enough signatures, finalize
        if (signedValidators.length >= validate_threshold) {
            emit ResultValidated(result);
            status = STATUS_RESULT_VALIDATED;
            settleBet();
        }
    }
    /*function validateResult() public {
        require(status == STATUS_RESULT_GENERATED, "Result not generated");
        require(block.number >= cutOffBlockNumber + BLOCK_NUMBER_OFFSET + 12, "Wait at least 12 blocks");
        require(isValidator(msg.sender), "Only a validator can validate");

        uint256 usedBlockNumber = cutOffBlockNumber + 1;
        bytes32 randomBlockHash = blockhash(usedBlockNumber);

        emit ProofStepStringified(string(abi.encodePacked(
            "Step 1: Blockhash from block #", _uint2str(usedBlockNumber), " = ", _bytes32ToHexString(randomBlockHash)
        )));

        address[] memory addrList = new address[](bets.length + 1);
        addrList[0] = host;
        for (uint256 i = 0; i < bets.length; i++) {
            addrList[i + 1] = bets[i].player;
        }

        emit ProofStepStringified(string(abi.encodePacked(
            "Step 2: Addresses used in randomness = ", _addressesToString(addrList)
        )));

        bytes memory packedData = abi.encodePacked(host);
        for (uint256 j = 0; j < bets.length; j++) {
            packedData = abi.encodePacked(packedData, bets[j].player);
        }

        emit ProofStepStringified(string(abi.encodePacked(
            "Step 3: Keccak256 input: blockhash + packedData"
        )));

        bytes32 randomHash = keccak256(abi.encodePacked(randomBlockHash, packedData));

        emit ProofStepStringified(string(abi.encodePacked(
            "Step 4: Keccak256 output = ", _bytes32ToHexString(randomHash)
        )));

        uint256 randomNumber = uint256(randomHash);
        uint8 recomputedResult = uint8(randomNumber % RESULT_COUNT);

        emit ProofStepStringified(string(abi.encodePacked(
            "Step 5: Final outcome (mod ", _uint2str(RESULT_COUNT), ") = ", _uint2str(recomputedResult)
        )));

        require(recomputedResult == result, "Stored result != recomputed result");

        signedValidators.push(msg.sender);

        if (signedValidators.length >= validate_threshold) {
            emit ResultValidated(result);
            status = STATUS_RESULT_VALIDATED;
            settleBet();
        }
    }*/
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
                        (bets[i].amount * PAYOUT_STRAIGHT_UP) /
                            PAYOUT_SCALE_FACTOR
                    );
                    emit BetPayout(
                        bets[i].player,
                        bets[i].option,
                        (bets[i].amount * PAYOUT_STRAIGHT_UP) /
                            PAYOUT_SCALE_FACTOR
                    );
                }
                break;
            } else if (bets[i].option == 38) {
                // low
                if (isInLowSet(result)) {
                    // Player wins
                    payable(bets[i].player).transfer(
                        (bets[i].amount * PAYOUT_LOW_OR_HIGH) /
                            PAYOUT_SCALE_FACTOR
                    );
                    emit BetPayout(
                        bets[i].player,
                        bets[i].option,
                        (bets[i].amount * PAYOUT_LOW_OR_HIGH) /
                            PAYOUT_SCALE_FACTOR
                    );
                }
                break;
            } else if (bets[i].option == 39) {
                if (isInHighSet(result)) {
                    // Player wins
                    payable(bets[i].player).transfer(
                        (bets[i].amount * PAYOUT_LOW_OR_HIGH) /
                            PAYOUT_SCALE_FACTOR
                    );
                    emit BetPayout(
                        bets[i].player,
                        bets[i].option,
                        (bets[i].amount * PAYOUT_LOW_OR_HIGH) /
                            PAYOUT_SCALE_FACTOR
                    );
                }
                break;
            } else if (bets[i].option == 40) {
                if (isInRedSet(result)) {
                    // Player wins
                    payable(bets[i].player).transfer(
                        (bets[i].amount * PAYOUT_RED_OR_BLACK) /
                            PAYOUT_SCALE_FACTOR
                    );
                    emit BetPayout(
                        bets[i].player,
                        bets[i].option,
                        (bets[i].amount * PAYOUT_RED_OR_BLACK) /
                            PAYOUT_SCALE_FACTOR
                    );
                }
                break;
            } else if (bets[i].option == 41) {
                if (isInBlackSet(result)) {
                    // Player wins
                    payable(bets[i].player).transfer(
                        (bets[i].amount * PAYOUT_RED_OR_BLACK) /
                            PAYOUT_SCALE_FACTOR
                    );
                    emit BetPayout(
                        bets[i].player,
                        bets[i].option,
                        (bets[i].amount * PAYOUT_RED_OR_BLACK) /
                            PAYOUT_SCALE_FACTOR
                    );
                }
                break;
            } else if (bets[i].option == 42) {
                if (isInEvenSet(result)) {
                    // Player wins
                    payable(bets[i].player).transfer(
                        (bets[i].amount * PAYOUT_EVEN_OR_ODD) /
                            PAYOUT_SCALE_FACTOR
                    );
                    emit BetPayout(
                        bets[i].player,
                        bets[i].option,
                        (bets[i].amount * PAYOUT_EVEN_OR_ODD) /
                            PAYOUT_SCALE_FACTOR
                    );
                }
                break;
            } else if (bets[i].option == 43) {
                if (isInOddSet(result)) {
                    // Player wins
                    payable(bets[i].player).transfer(
                        (bets[i].amount * PAYOUT_EVEN_OR_ODD) /
                            PAYOUT_SCALE_FACTOR
                    );
                    emit BetPayout(
                        bets[i].player,
                        bets[i].option,
                        (bets[i].amount * PAYOUT_EVEN_OR_ODD) /
                            PAYOUT_SCALE_FACTOR
                    );
                }
                break;
            } else if (bets[i].option == 44) {
                if (isInFirstColumnSet(result)) {
                    // Player wins
                    payable(bets[i].player).transfer(
                        (bets[i].amount * PAYOUT_COLUMNS) / PAYOUT_SCALE_FACTOR
                    );
                    emit BetPayout(
                        bets[i].player,
                        bets[i].option,
                        (bets[i].amount * PAYOUT_COLUMNS) / PAYOUT_SCALE_FACTOR
                    );
                }
            } else if (bets[i].option == 45) {
                if (isInSecondColumnSet(result)) {
                    // Player wins
                    payable(bets[i].player).transfer(
                        (bets[i].amount * PAYOUT_COLUMNS) / PAYOUT_SCALE_FACTOR
                    );
                    emit BetPayout(
                        bets[i].player,
                        bets[i].option,
                        (bets[i].amount * PAYOUT_COLUMNS) / PAYOUT_SCALE_FACTOR
                    );
                }
            } else if (bets[i].option == 46) {
                if (isInThirdColumnSet(result)) {
                    // Player wins
                    payable(bets[i].player).transfer(
                        (bets[i].amount * PAYOUT_COLUMNS) / PAYOUT_SCALE_FACTOR
                    );
                    emit BetPayout(
                        bets[i].player,
                        bets[i].option,
                        (bets[i].amount * PAYOUT_COLUMNS) / PAYOUT_SCALE_FACTOR
                    );
                }
            } else if (bets[i].option == 47) {
                if (isInFirstDozenSet(result)) {
                    // Player wins
                    payable(bets[i].player).transfer(
                        (bets[i].amount * PAYOUT_DOZEN) / PAYOUT_SCALE_FACTOR
                    );
                    emit BetPayout(
                        bets[i].player,
                        bets[i].option,
                        (bets[i].amount * PAYOUT_DOZEN) / PAYOUT_SCALE_FACTOR
                    );
                }
            } else if (bets[i].option == 48) {
                if (isInSecondDozenSet(result)) {
                    // Player wins
                    payable(bets[i].player).transfer(
                        (bets[i].amount * PAYOUT_DOZEN) / PAYOUT_SCALE_FACTOR
                    );
                    emit BetPayout(
                        bets[i].player,
                        bets[i].option,
                        (bets[i].amount * PAYOUT_DOZEN) / PAYOUT_SCALE_FACTOR
                    );
                }
            } else if (bets[i].option == 49) {
                if (isInThirdDozenSet(result)) {
                    // Player wins
                    payable(bets[i].player).transfer(
                        (bets[i].amount * PAYOUT_DOZEN) / PAYOUT_SCALE_FACTOR
                    );
                    emit BetPayout(
                        bets[i].player,
                        bets[i].option,
                        (bets[i].amount * PAYOUT_DOZEN) / PAYOUT_SCALE_FACTOR
                    );
                }
            }
        }
        emit GameEnded(host, address(this).balance);
        payable(host).transfer(address(this).balance);
    }
}
