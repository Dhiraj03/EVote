// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.5.0;

contract Election {
    //Structure that represents a registered voter in the election
    struct Voter {
        bool hasVoted; //Whether or not the voter has voted yet
        address delegate; // The address of the delegate that the voter has chosen (default to the voter itself)
        uint256 weight; // Weight of the Voter
        uint256 voteTowards; //States the candidate's ID to which the voter has voted
    }
    //Structure that represents a registered candidate in the election
    struct Candidate {
        uint256 ID; // The unique ID of the candidate
        string name; // Name of the candidate
        string proposal; // The proposal/promises of the candidate
    }

    mapping(address => Voter) private voters; //address of voter mapped to the voter struct - To view all registered voters
    mapping(uint256 => Candidate) private candidates; // ID of candidate mapped to the candidate struct - To view details of all registered candidates
    mapping(uint256 => uint256) private voteCount; // ID of the candidate mapped to the votes of the candidate privately

    address  admin; // The address of the official/authority conducting the election

    enum State {CREATED, ONGOING, STOP}
    /*This enum represents the state of the election -
    CREATED - The election contract has been created, voting has not begun yet
    ONGOING - The voting has begun and is currently active
    STOP - The voting period has ended and it is time for counting
    */

    State electionState; // A variable of the type enum State to represent the election state

    uint256 public candidate_count; // Keeps a count of the registered candidates

    //modifier to check if the address is of the admin's as several functions can only be accessed by the admin
    modifier checkAdmin() {
        require(
            msg.sender == admin,
            "only the owner has access to this function"
        );
        _;
    }

    //modifiers to check for the states of the election
    modifier checkIfCreated() {
        require(
            electionState == State.CREATED,
            "election is yet to be created"
        );
        _;
    }

    modifier checkIfOngoing() {
        require(
            electionState == State.ONGOING,
            "election is not in ongoing phase"
        );
        _;
    }

    modifier checkIfComplete() {
        require(electionState == State.STOP, "election is not yet completed");
        _;
    }

    modifier checkNotComplete() {
        require(electionState != State.STOP, "election is not yet completed");
        _;
    }

    //modifier to check if a voter is a valid voter
    modifier checkIfVoterValid() {
        require(
            !voters[msg.sender].hasVoted && voters[msg.sender].weight > 0,
            "voter has already voted"
        );
        _;
    }

    //modifier to check if the candidate being voted for is a valid candidate
    modifier checkIfCandidateValid(uint256 _candidateId) {
        require(
            _candidateId > 0 && _candidateId <= candidate_count,
            "invalid candidate"
        );
        _;
    }

    //modifier to check if the person is not an admin
    modifier checkNotAdmin() {
        require(
            msg.sender != admin,
            "owner is not allowed to access this function"
        );
        _;
    }

    //modifier to check if the voter is not yet registered for the addVoter function
    modifier checkNotRegistered(address voter) {
        require(
            !voters[voter].hasVoted && voters[voter].weight == 0,
            "voter is already registered"
        );
        _;
    }

    //events to be logged into the blockchain
    event AddedAVoter(address voter);
    event VotedSuccessfully(uint256 candidateId);
    event DelegatedSuccessfully(address delegate);
    event ElectionStart(State election_state);
    event ElectionEnd(State election_state);
    event AddedACandidate(uint candidateID, string candidateName, string candidateProposal);

    // Initialization
    constructor() public {
        electionState = State.CREATED; // Setting Eection state to CREATED
    }

    function getAdmin() public view returns (address)
    {
        return admin;
    }

    function setManager(address manager) public
    {
        admin = msg.sender;
    }
    // To Add a candidate
    // Only admin can add and
    // candidate can be added only before election starts
    function addCandidate(string memory _name, string memory _proposal)
        public
        checkAdmin
        checkIfCreated
    {
        candidate_count++;
        candidates[candidate_count].ID = candidate_count;
        candidates[candidate_count].name = _name;
        candidates[candidate_count].proposal = _proposal;
        voteCount[candidate_count] = 0;
        emit AddedACandidate(candidate_count, _name, _proposal);
    }

    // To add a voter
    // only admin can add
    // can add only before election starts
    // can add a voter only one time
    function addVoter(address _voter)
        public
        checkAdmin
        checkIfCreated
        checkNotRegistered(_voter)
    {
        voters[_voter].weight = 1;
        emit AddedAVoter(_voter);
    }

    // setting Election state to ONGOING
    // by admin
    function startElection() public checkAdmin checkIfCreated {
        electionState = State.ONGOING;
        emit ElectionStart(electionState);
    }

    // To display candidates
    function displayCandidate(uint256 _ID)
        public
        view
        returns (
            uint256,
            string memory,
            string memory
        )
    {
        return (
            candidates[_ID].ID,
            candidates[_ID].name,
            candidates[_ID].proposal
        );
    }

    //Show winner of election
    function showWinner()
        public
        view
        checkIfComplete
        returns (string memory)
    {
        uint256 max;
        string memory winner;
        for (uint256 i = 1; i <= candidate_count; i++) {
            if (voteCount[i] > max) {
                winner = candidates[i].name;
                max = voteCount[i];
            }
        }
        return winner;
    }

    // to delegate the vote
    // only during election is going on
    // and by a voter who has not yet voted
    function delegateVote(address _delegate)
        public
        checkNotComplete
        checkIfVoterValid
        checkNotAdmin
    {
        require(_delegate != msg.sender, "self delegation is not allowed");
        address to = _delegate;
        while (voters[to].delegate != address(0)) {
            to = voters[to].delegate;

            // To prevent infinite loop
            if (to == msg.sender) {
                revert();
            }
        }
        voters[msg.sender].delegate = to;
        emit DelegatedSuccessfully(_delegate);
        voters[msg.sender].hasVoted = true;

        if (voters[to].hasVoted) {
            // if delegate has already voted
            // voters vote is directly added to candidates vote count
            voteCount[voters[to].voteTowards] += voters[msg.sender].weight;
        } else {
            voters[to].weight += voters[msg.sender].weight;
        }
    }

    // to cast the vote
    function vote(uint256 _ID)
        public
        checkIfOngoing
        checkIfVoterValid
        checkIfCandidateValid(_ID)
    {
        voters[msg.sender].hasVoted = true;
        voters[msg.sender].voteTowards = _ID;
        voteCount[_ID] += voters[msg.sender].weight;
        emit VotedSuccessfully(_ID);
    }

    // Setting Election state to STOP
    // by admin
    function endElection() public checkAdmin {
        electionState = State.STOP;
        emit ElectionEnd(electionState);
    }

    // to display result
    function showResults(uint256 _ID)
        public
        view
        checkIfComplete
        checkIfCandidateValid(_ID)
        returns (
            uint256,
            string memory,
            uint256
        )
    {
        return (_ID, candidates[_ID].name, voteCount[_ID]);
    }
}
