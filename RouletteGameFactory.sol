// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;
import "./RouletteGame.sol";

contract RouletteGameFactory {
    event GameCreated(address indexed gameAddress, uint256 timestamp);

    struct GameInfo {
        address gameAddress;
        uint256 creationTime;
        bool isActive;
    }

    mapping(uint256 => GameInfo) public games; // Maps game index to GameInfo
    uint256 public gameCount;

    function createRouletteGame(
        address _host,
        uint256 _minBet,
        address[] memory _validators,
        uint8 _valid_threshold
    ) public payable returns (address) {
        RouletteGame rouletteGame = new RouletteGame(
            _host,
            _minBet,
            _validators,
            _valid_threshold
        );

        games[gameCount] = GameInfo({
            gameAddress: address(rouletteGame),
            creationTime: block.timestamp,
            isActive: true
        });

        emit GameCreated(address(rouletteGame), block.timestamp);
        gameCount++;
        return address(rouletteGame);
    }

    // Function to get all deployed games
    function getAllGames() external view returns (address[] memory) {
        address[] memory result = new address[](gameCount);
        for (uint256 i = 0; i < gameCount; i++) {
            result[i] = games[i].gameAddress;
        }
        return result;
    }

    // Function to get a specific game by index
    function getGameByIndex(
        uint256 _index
    ) external view returns (address, uint256, bool) {
        GameInfo storage game = games[_index];
        return (game.gameAddress, game.creationTime, game.isActive);
    }
}
