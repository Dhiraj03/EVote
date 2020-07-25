import 'dart:convert';

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

class Election {
  String rpcUrl = 'http://192.168.0.12:7545';
  String wsUrl = 'ws://://192.168.0.12:7545';
  String privateKey =
      'db9aa287b49efed1f9aa7e8c1a2905e89398961e80511a1d8b18431a115e32cd';

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
  }

  // Steps 6-7
  Future<void> getAbi() async {
    final String abiString = await rootBundle.loadString('src/abis/Election.json');
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
}
