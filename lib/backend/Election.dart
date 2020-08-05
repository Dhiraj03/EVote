import 'dart:convert';

import 'package:e_vote/backend/Candidate.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart';
import 'package:web3dart/contracts.dart';
import 'package:web3dart/credentials.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';

/*
The class Election is a helper class that is used to interact with the
Blockchain.
1. Web3Client - This is a client for sending requests over a HTTP 
JSON-RPC API endpoint to Ethereum Clients (Truffle and Ganache).
This client WILL NOT provide accounts itself - we will need to use accounts
that are provided by Ganache.
2. rpcUrl and wsUrl - The JSON RPC API needs to be available at the specified URL.
The socketConnector argument is the signature for a function that opens a socket -
event channel, on which json-rpc operations can be performed.
3.Credentials - Unique ID - anything that can sign payloads with a private key.
4. The web3client takes the private key of the account as input and creates credentials.
5. masterAddress stores the address of the account specified by the credentials

6. rootBundle.loadString is used to get the ABI (Application Binary interface) code 
of the contract from the src/abis folder - The ABI is a .json file that describes
the deployed contract and its functions - allows us to contextualize the contract
and call its functions.
7. To get the address at which the contract is currently deployed, ['abi']['networks']['5777']['address'] 
is used.

8. This (the address of the deployed contract), along with the abi (string format) and name of the contract
is used to call the constructor of DeployedContract()

*/

class Election extends ChangeNotifier {
  final String rpcUrl = 'http://192.168.0.12:7545';
  final String wsUrl = 'ws://://192.168.0.12:7545';
  final String privateKey =
      '7dbaa1e35f179bdba19d2f1e61bbaeb4e38154e51e4af4ab477ba2e849bee98a';
  
  EthereumAddress masterAddress;
  EthereumAddress electionAddress;
  DeployedContract electionContract;
  Web3Client web3client;
  Credentials masterCredentials;
  dynamic jsonAbi;
  String abiCode;

  // ignore: sort_constructors_first
  Election() {
    setUp();
  }

  // Steps 1-5
  Future<void> setUp() async {
    web3client = Web3Client(rpcUrl, Client(),
        socketConnector: () =>
            IOWebSocketChannel.connect(wsUrl).cast<String>());
    masterCredentials = await web3client.credentialsFromPrivateKey(privateKey);
    masterAddress = await masterCredentials.extractAddress();
    await getAbi();
    await getDeployedContract();
    await electionContractConstructor(masterAddress.toString());
    await getState();
  }

  // Steps 6-7
  Future<void> getAbi() async {
    final String abiString =
        await rootBundle.loadString('src/abis/Election.json');
    jsonAbi = json.decode(abiString);
    abiCode = json.encode(jsonAbi['abi']);
    electionAddress =
        EthereumAddress.fromHex(jsonAbi['networks']['5777']['address']);
  }

  //Step 8
  Future<void> getDeployedContract() async {
    electionContract = DeployedContract(
        ContractAbi.fromJson(abiCode, 'Election'), electionAddress);
  }

  Future<void> electionContractConstructor(String adminAddress) async {
    print('lol');
    ContractFunction getAdmin = electionContract.function('getAdmin');
    ContractFunction setAdmin = electionContract.function('setManager');
    EthereumAddress address = EthereumAddress.fromHex(adminAddress);
    print(address.toString());
    final String res1 = await web3client.sendTransaction(
        masterCredentials,
        Transaction.callContract(
            from: address,
            contract: electionContract,
            function: setAdmin,
            parameters: <dynamic>[]));
    final List<dynamic> res = await web3client.call(
        contract: electionContract, function: getAdmin, params: <dynamic>[]);
    print(res.toString());
  }

  Future<void> addCandidate(
      String name, String proposal, String adminPrivateKey) async {
    ContractFunction addCandidate = electionContract.function('addCandidate');
    final Credentials adminCredentials =
        await web3client.credentialsFromPrivateKey(adminPrivateKey);
    final EthereumAddress adminAddress =
        await adminCredentials.extractAddress();
    final String response = await web3client.sendTransaction(
        adminCredentials,
        Transaction.callContract(
            from: adminAddress,
            maxGas: 1000000,
            contract: electionContract,
            function: addCandidate,
            parameters: <dynamic>[name, proposal]));
    print(response.toString());
  }

  Future<void> addVoter(String address, String adminPrivateKey) async {
    ContractFunction addVoter = electionContract.function('addVoter');
    final Credentials adminCredentials =
        await web3client.credentialsFromPrivateKey(adminPrivateKey);
    final EthereumAddress adminAddress =
        await adminCredentials.extractAddress();
    final EthereumAddress voterAddress = EthereumAddress.fromHex(address);
    final String response = await web3client.sendTransaction(
        adminCredentials,
        Transaction.callContract(
            from: adminAddress,
            maxGas: 1000000,
            contract: electionContract,
            function: addVoter,
            parameters: <dynamic>[voterAddress]));

    print(response.toString());
  }

  Future<String> getState() async {
    ContractFunction getState = electionContract.function('checkState');
    final response = await web3client.call(
        contract: electionContract, function: getState, params: <dynamic>[]);
    print(response[0]);
    return response[0];

    //* CREATED ONGOING STOPPED
  }

  Future<void> startElection(String adminPrivateKey) async {
    ContractFunction startElection = electionContract.function('startElection');
    final Credentials adminCredentials =
        await web3client.credentialsFromPrivateKey(adminPrivateKey);
    final EthereumAddress adminAddress =
        await adminCredentials.extractAddress();
    final String response = await web3client.sendTransaction(
        adminCredentials,
        Transaction.callContract(
            from: adminAddress,
            maxGas: 1000000,
            contract: electionContract,
            function: startElection,
            parameters: <dynamic>[]));
    print(response.toString());
  }

  Future<void> endElection(String adminPrivateKey) async {
    ContractFunction endElection = electionContract.function('endElection');
    final Credentials adminCredentials =
        await web3client.credentialsFromPrivateKey(adminPrivateKey);
    final EthereumAddress adminAddress =
        await adminCredentials.extractAddress();
    final String response = await web3client.sendTransaction(
        adminCredentials,
        Transaction.callContract(
            from: adminAddress,
            maxGas: 1000000,
            contract: electionContract,
            function: endElection,
            parameters: <dynamic>[]));
    print(response.toString());
  }

  Future<List<Candidate>> displayCandidates(String adminPrivateKey) async {
    ContractFunction displayCandidates =
        electionContract.function('displayCandidate');
    final Credentials adminCredentials =
        await web3client.credentialsFromPrivateKey(adminPrivateKey);
    final EthereumAddress adminAddress =
        await adminCredentials.extractAddress();

    ContractFunction candidateCount =
        electionContract.function('candidate_count');
    final candidate_Count = await web3client.call(
        contract: electionContract,
        function: candidateCount,
        params: <dynamic>[]);
    List<dynamic> candidate;
    List<Candidate> listOfCandididates = [];
    int total = candidate_Count[0].toInt();
    for (int i = 0; i < total; i++) {
      candidate = await web3client.call(
          contract: electionContract,
          function: displayCandidates,
          params: <dynamic>[BigInt.from(i)]);
      listOfCandididates.add(Candidate(
          id: candidate[0].toInt(),
          name: candidate[0].toString(),
          proposal: candidate[0].toString()));
    }
    return listOfCandididates;
  }

  Future<String> showWinner(String adminPrivateKey) async {
    ContractFunction showWinner = electionContract.function('showWinner');
    final Credentials adminCredentials =
        await web3client.credentialsFromPrivateKey(adminPrivateKey);
    final EthereumAddress adminAddress =
        await adminCredentials.extractAddress();
    final response = await web3client.call(
        contract: electionContract, function: showWinner, params: <dynamic>[]);
    final String winnerName = response[0];
    return winnerName;
  }

  Future<void> delegateVote(
      String voterPrivateKey, String delegateAddress) async {
    ContractFunction delegateVote = electionContract.function('delegateVote');
    final Credentials voterCredentials =
        await web3client.credentialsFromPrivateKey(voterPrivateKey);
    final EthereumAddress voterAddress =
        await voterCredentials.extractAddress();
    final String response = await web3client.sendTransaction(
        voterCredentials,
        Transaction.callContract(
            from: voterAddress,
            maxGas: 1000000,
            contract: electionContract,
            function: delegateVote,
            parameters: <dynamic>[delegateAddress]));
  }

  Future<void> vote(String voterPrivateKey, int candidateID) async {
    ContractFunction vote = electionContract.function('vote');
    final Credentials voterCredentials =
        await web3client.credentialsFromPrivateKey(voterPrivateKey);
    final EthereumAddress voterAddress =
        await voterCredentials.extractAddress();
    final String response = await web3client.sendTransaction(
        voterCredentials,
        Transaction.callContract(
            from: voterAddress,
            maxGas: 1000000,
            contract: electionContract,
            function: vote,
            parameters: <dynamic>[BigInt.from(candidateID)]));
  }

  Future<List<Candidate>> showResults() async {
    ContractFunction showResults = electionContract.function('showResults');
    ContractFunction candidateCount =
        electionContract.function('candidate_count');
    final candidate_Count = await web3client.call(
        contract: electionContract,
        function: candidateCount,
        params: <dynamic>[]);
    List<dynamic> candidate;
    List<Candidate> listOfCandididates = [];
    int total = candidate_Count[0].toInt();
    for (int i = 1; i <= total; i++) {
      candidate = await web3client.call(
          contract: electionContract,
          function: showResults,
          params: <dynamic>[BigInt.from(i)]);
      listOfCandididates.add(Candidate(
          id: candidate[0].toInt(),
          name: candidate[0].toString(),
          proposal: candidate[0].toString()));
    }
    return listOfCandididates;
  }
}
