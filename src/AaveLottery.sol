pragma solidity ^0.8.0;

contract AaveLottery {

    struct Round {
        uint256 endTime;
        uint256 totalStake;
        uint256 award;
        address winner;
    }
    struct Ticket {
        uint256 stake;
    }
    uint256 public roundDuration;
    uint256 public currentId;  // curent round

    // roundId => Round
    mapping(uint256 => Round) public rounds;


    // roundId => userAddress => Ticket 
    mapping(uint256 => mapping(address => Ticket)) public tickets;

    constructor(uint256 _roundDuration) {
        roundDuration = _roundDuration;

        // Init first round
        rounds[currentId] = Round(
            block.timestamp + _roundDuration;
            0,
            0,
            0,
            address(0)
        );
    }

    function getRound(uint256 roundId) external view returns(Round memory) {
        return rounds[roundId];
    }
    function getTicket(uint256 roundId, address user) external view returns(Ticket memory) {
        return tickets[roundId][user];
    }

    function enter(uint256 amount) external {
        // check
        require(tickets[currentId][msg.sender].stake == 0,
         'USER_ALREADY_PARTICIPANT'
         );
        // update
         _updateState();
        // User Enters
        // Transfer funds in
        // Deposit funds into Aave Pool
    }
    function exit(uint256 roundId) external {
        // Check 
        // Update
         _updateState();
        // User Exits
        // Transfer funds out
    }
    function claim(uint256 roundId) external {
        // Checks
        require(roundId < currentId, 'CURENT_LOTTERY');
        // Check winner
        // Transfer Jackpot
    }
    function _drawWinner(uint256 total) internal view returns(uint256) {
        uint256 random = uint256(
            keccak256(
                abi.ancodePacked(
                    block.timestamp,
                    rounds[currentId].totalStake,
                    currentId
                )
            ) // random's value = [0, 2^256 - 1];
        );
        return random % total;  // [0, total];
    }
    function  _updateState() internal {
        if(block.timestamp > rounds[currentId].endTime) {
            // Lotery draw
            rounds[currentId].winnerTicket = _drawWinner(
                rounds[currentId].totalStake
            );
            // create a new round
            currentId += 1;
            rounds[currentId].endTime = block.timestamp + roundDuration;
        }
    }
}