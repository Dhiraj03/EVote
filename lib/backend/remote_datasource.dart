import 'dart:io';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:e_vote/backend/errors.dart';
import 'package:e_vote/models/candidate_model.dart';
import 'package:e_vote/models/voter_model.dart';

class ElectionDataSource {
  var dioClient = Dio();
  String url =
      "https://mainnet-api.maticvigil.com/v1.0/contract/0xdaecff888d2c99a072a711168eeed5504e9e8fbc";
  var httpClient = HttpClient();
  String adminAddress = "0xb3eb5933e5eb4b4872142cf631a3b0c686e15216";
  // fetches the address of the admin from the blockchain
  Future<String> getAdmin() async {
    var response = await dioClient.get(url + "/admin");
    return response.data["data"][0]["address"];
  }

  //Fetches the count of registered candidates in the election
  Future<int> getCandidateCount() async {
    var response = await dioClient.get(url + "/candidate_count");
    return response.data["data"][0]["uint256"].toInt();
  }

  //Fetches the count of regsitered voters in the elction
  Future<int> getVoterCount() async {
    var response = await dioClient.get(url + "/voter_count");
    return response.data["data"][0]["uint256"].toInt();
  }

  //Fetches the current state of the election - CREATED, ONGOING or STOPPED
  Future<String> getElectionState() async {
    var response = await dioClient.get(url + "/checkState");
    return response.data["data"][0]["state"];
  }

  //Fetches a short description of the election
  Future<String> getDescription() async {
    var response = await dioClient.get(url + "/description");
    return response.data["data"][0]["string"];
  }

  //Fetches the details of a candidate - ID, Name, Proposal
  Future<Candidate> getCandidate(int id) async {
    var response = await dioClient.get(url + "/displayCandidate/$id");
    return Candidate.fromJson(response.data["data"][0]);
  }

  //Fetches the details of all the registered candidates
  Future<List<Candidate>> getAllCandidates() async {
    int count = await getCandidateCount();
    var list = List<int>.generate(count, (index) => index + 1);
    List<Candidate> result = [];
    await Future.wait(list.map((e) async {
      await dioClient.get(url + '/displayCandidate/$e').then((value) {
        result.add(Candidate.fromJson(value.data["data"][0]));
      });
    }));
    return result;
  }

  //Fetches the details of a voter - ID, Address, DelegateAddress and Weight
  Future<Voter> getVoter(int id, String owner) async {
    var response = await dioClient.get(url + "/getVoter/$id/$adminAddress");
    return Voter.fromJson(response.data["data"][0]);
  }

  //Fetches the details of all voters
  Future<List<Voter>> getAllVoters() async {
    int count = await getVoterCount();
    var list = List<int>.generate(count, (index) => index + 1);
    List<Voter> result = [];
    await Future.wait(list.map((e) async {
      await dioClient.get(url + '/getVoter/$e/$adminAddress').then((value) {
        result.add(Voter.fromJson(value.data["data"][0]));
      });
    }));
    print('hah');
    print(result.length);
    return result;
  }

  //Fetches the result of the candidate
  Future<Either<ErrorMessage, Candidate>> showCandidateResult(int id) async {
    try {
      var response = await dioClient.get(url + "/showResults/$id");
      return Right(Candidate.result(response.data["data"][0]));
    } catch (e) {
      return Left(ErrorMessage(
          message: e.response.data["error"]["details"]["message"]));
    }
  }

  //Fetches the results of all the candidates
  Future<Either<ErrorMessage, List<Candidate>>> showResults() async {
    int count = await getCandidateCount();
    if (await getElectionState() != "CONCLUDED")
      return Left(ErrorMessage(message: "The election has not concluded yet."));
    var list = List<int>.generate(count, (index) => index + 1);
    List<Candidate> result = [];
    await Future.wait(list.map((e) async {
      await dioClient.get(url + '/showResults/$e').then((value) {
        result.add(Candidate.result(value.data["data"][0]));
      });
    }));
    print(result.length);
    return Right(result);
  }

  //Returns the winner of the election
  Future<Either<ErrorMessage, Candidate>> getWinner() async {
    try {
      var response = await dioClient.get(url + "/showWinner");
      return Right(Candidate.winner(response.data["data"][0]));
    } catch (e) {
      return Left(ErrorMessage(
          message: e.response.data["error"]["details"]["message"]));
    }
  }

  //Function to register a new candidate
  Future<Either<ErrorMessage, String>> addCandidate(
      String name, String proposal) async {
    Map<String, dynamic> map = {
      "_name": name,
      "_proposal": proposal,
      "owner": adminAddress
    };
    try {
      var response = await dioClient.post(url + "/addCandidate",
          data: map,
          options: Options(headers: {
            "X-API-KEY": ["70d56934-be68-4b74-b402-f597cdbd41d9"]
          }, contentType: Headers.formUrlEncodedContentType));
      return Right(response.data["data"][0]["txHash"]);
    } catch (e) {
      return Left(ErrorMessage(
          message: e.respone.data["error"]["message"]));
    }
  }

  //Function to register a new voter
  Future<Either<ErrorMessage, String>> addVoter(String voter) async {
    Map<String, dynamic> map = {"_voter": voter, "owner": adminAddress};
    try {
      var response = await dioClient.post(url + "/addVoter",
          data: map,
          options: Options(headers: {
            "X-API-KEY": ["70d56934-be68-4b74-b402-f597cdbd41d9"]
          }, contentType: Headers.formUrlEncodedContentType));
      return Right(response.data["data"][0]["txHash"]);
    } catch (e) {
      if (e.response.data["error"]["message"] == "DataEncodingError")
        return Left(
            ErrorMessage(message: "Invalid arguments. Please try again."));
      else if (voter == adminAddress)
        return Left(ErrorMessage(message: e.response.data["error"]["message"]));
      else
        return Left(ErrorMessage(
            message: e.response.data["error"]["message"]));
    }
  }

  //Function to delegate your vote to someone else
  Future<Either<ErrorMessage, String>> delegateVoter(
      String delegate, String owner) async {
    print(delegate + "   " + owner);
    Map<String, dynamic> map = {"_delegate": delegate, "owner": owner};
    try {
      var response = await dioClient.post(url + "/delegateVote",
          data: map,
          options: Options(headers: {
            "X-API-KEY": ["70d56934-be68-4b74-b402-f597cdbd41d9"]
          }, contentType: Headers.formUrlEncodedContentType));
      return Right(response.data["data"][0]["txHash"]);
    } catch (e) {
      if (e.response.data["error"]["message"] == "DataEncodingError")
        return Left(
            ErrorMessage(message: "Invalid arguments. Please try again."));
      else
        return Left(ErrorMessage(message: e.response.data["error"]["message"]));
    }
  }

  //Function to endElection
  Future<Either<ErrorMessage, String>> endElection() async {
    Map<String, dynamic> map = {"owner": adminAddress};
    try {
      var response = await dioClient.post(url + "/endElection",
          data: map,
          options: Options(headers: {
            "X-API-KEY": ["70d56934-be68-4b74-b402-f597cdbd41d9"]
          }, contentType: Headers.formUrlEncodedContentType));
      return Right(response.data["data"][0]["txHash"]);
    } catch (e) {
      return Left(ErrorMessage(message: e.response.data["error"]["message"]));
    }
  }

  Future<Either<ErrorMessage, String>> startElection() async {
    Map<String, dynamic> map = {"owner": adminAddress};
    try {
      var response = await dioClient.post(url + "/startElection",
          data: map,
          options: Options(headers: {
            "X-API-KEY": ["70d56934-be68-4b74-b402-f597cdbd41d9"]
          }, contentType: Headers.formUrlEncodedContentType));
      return Right(response.data["data"][0]["txHash"]);
    } catch (e) {
      print(e.response.data["error"]);
      return Left(ErrorMessage(message: e.response.data["error"]["message"]));
    }
  }

  Future<Either<ErrorMessage, String>> vote(int id, String owner) async {
    Map<String, dynamic> map = {"owner": owner, "_ID": id};
    try {
      var response = await dioClient.post(url + "/vote",
          data: map,
          options: Options(headers: {
            "X-API-KEY": ["70d56934-be68-4b74-b402-f597cdbd41d9"]
          }, contentType: Headers.formUrlEncodedContentType));
      return Right(response.data["data"][0]["txHash"]);
    } catch (e) {
      if (e.response.data["error"]["message"] == "DataEncodingError")
        return Left(
            ErrorMessage(message: "Invalid arguments. Please try again."));
      else
        return Left(ErrorMessage(message: e.response.data["error"]["message"]));
    }
  }

  Future<Voter> getVoterProfile(String address) async {
    var response = await dioClient.get(url + "/voterProfile/$address");
    return Voter.profileJson(response.data["data"][0], address);
  }
}
