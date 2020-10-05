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

    address public admin; // The address of the official/authority conducting the election

    enum State {CREATED, ONGOING, STOP}
    /*This enum represents the state of the election -
    CREATED - The election contract has been created, voting has not begun yet
    ONGOING - The voting has begun and is currently active
    STOP - The voting period has ended and it is time for counting
    */

    State  electionState; // A variable of the type enum State to represent the election state
    string public description;
    uint256 public candidate_count; // Keeps a count of the registered candidates

    //modifier to check if the address is of the admin's as several functions can only be accessed by the admin
    modifier checkAdmin(address owner) {
        require(
            owner == admin,
            "Only the owner has access to this function"
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
    modifier checkIfVoterValid(address owner) {
        require(
            !voters[owner].hasVoted && voters[owner].weight > 0,
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
    modifier checkNotAdmin(address owner) {
        require(
            owner != admin,
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
    constructor(address owner, string memory description) public {
        admin = owner;
        electionState = State.CREATED; // Setting Eection state to CREATED
        description = description;
    }
 
    function checkState() public view returns (string memory state)
    {
        if(electionState == State.CREATED)
        return "CREATED";
        else if(electionState == State.ONGOING)
        return "ONGOING";
        else if(electionState == State.STOP)
        return "STOP";
    }
    // To Add a candidate
    // Only admin can add and
    // candidate can be added only before election starts
    function addCandidate(string memory _name, string memory _proposal, address owner)
        public
        checkAdmin(owner)
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
    function addVoter(address _voter, address owner)
        public
        checkAdmin(owner)
        checkIfCreated
        checkNotRegistered(_voter)
    {
        voters[_voter].weight = 1;
        emit AddedAVoter(_voter);
    }

    // setting Election state to ONGOING
    // by admin
    function startElection(address owner) public checkAdmin(owner) checkIfCreated {
        electionState = State.ONGOING;
        emit ElectionStart(electionState);
    }

    // To display candidates
    function displayCandidate(uint256 _ID)
        public
        view
        returns (
            uint256 id,
            string memory name,
            string memory proposal
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
        returns (string memory name, uint256 id, uint256 votes)
    {
        uint256 max;
        uint256 maxIndex;
        string memory winner;
        for (uint256 i = 1; i <= candidate_count; i++) {
            if (voteCount[i] > max) {
                winner = candidates[i].name;
                maxIndex = i;
                max = voteCount[i];
            }
        }
        return (winner,i, max) ;
    }

    // to delegate the vote
    // only during election is going on
    // and by a voter who has not yet voted
    function delegateVote(address _delegate, address owner)
        public
        checkNotComplete
        checkIfVoterValid(owner)
        checkNotAdmin(owner)
    {
        require(_delegate != owner, "self delegation is not allowed");
        address to = _delegate;
        while (voters[to].delegate != address(0)) {
            to = voters[to].delegate;

            // To prevent infinite loop
            if (to == owner) {
                revert();
            }
        }
        voters[owner].delegate = to;
        emit DelegatedSuccessfully(_delegate);
        voters[owner].hasVoted = true;

        if (voters[to].hasVoted) {
            // if delegate has already voted
            // voters vote is directly added to candidates vote count
            voteCount[voters[to].voteTowards] += voters[owner].weight;
        } else {
            voters[to].weight += voters[owner].weight;
        }
    }

    // to cast the vote
    function vote(uint256 _ID, address owner)
        public
        checkIfOngoing
        checkIfVoterValid(owner)
        checkIfCandidateValid(_ID)
    {
        voters[owner].hasVoted = true;
        voters[owner].voteTowards = _ID;
        voteCount[_ID] += voters[owner].weight;
        emit VotedSuccessfully(_ID);
    }

    // Setting Election state to STOP
    // by admin
    function endElection(address owner) public checkAdmin(owner) {
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
            uint256 id,
            string memory name,
            uint256 count,
        )
    {
        return (_ID, candidates[_ID].name, voteCount[_ID]);
    }
}
