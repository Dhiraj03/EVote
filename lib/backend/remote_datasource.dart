import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:e_vote/backend/errors.dart';
import 'package:e_vote/models/candidate_model.dart';

class ElectionDataSource {
  var dioClient = Dio();
  String url =
      "https://mainnet-api.maticvigil.com/v1.0/contract/0xb73d0a8d7383dd9656cb9822dc639f149729f12d";
  var httpClient = HttpClient();
  String adminAddress = "0xb3eb5933e5eb4b4872142cf631a3b0c686e15216";
  // fetches the address of the admin from the blockchain
  Future<String> getAdmin() async {
    var response = await dioClient.get(url + "/admin");
    return response.data["data"][0]["address"];
  }

  Future<int> getCandidateCount() async {
    var response = await dioClient.get(url + "/candidate_count");
    return response.data["data"][0]["uint256"].toInt();
  }

  Future<String> getElectionState() async {
    var response = await dioClient.get(url + "/checkState");
    return response.data["data"][0]["state"];
  }

  Future<String> getDescription() async {
    var response = await dioClient.get(url + "/description");
    return response.data["data"][0]["string"];
  }

  Future<Candidate> getCandidate(int id) async {
    var response = await dioClient.get(url + "/displayCandidate/$id");
    return Candidate.fromJson(response.data["data"][0]);
  }

  Future<List<Candidate>> getAllCandidates() async {
    int count = await getCandidateCount();
    List<Candidate> result = [];
    for (int i = 1; i <= count; i++) {
      dioClient.get(url + "/displayCandidate/$i").then((response) =>
          result.add(Candidate.fromJson(response.data["data"][0])));
    }
    return result;
  }

  Future<Candidate> showCandidateResult(int id) async {
    var response = await dioClient.get(url + "/showResults/$id");
    return Candidate.result(response.data["data"][0]);
  }

  Future<List<Candidate>> showResults() async {
    int count = await getCandidateCount();
    List<Candidate> result = [];
    for (int i = 1; i <= count; i++) {
      dioClient.get(url + "/showResults/$i").then(
          (response) => result.add(Candidate.result(response.data["data"][0])));
    }
    return result;
  }

  Future<Candidate> getWinner() async {
    var response = await dioClient.get(url + "/showWinner");
    return Candidate.winner(response.data["data"][0]);
  }

  Future<Either<ErrorMessage, String>> addCandidate(
      String name, String proposal) async {
    Map<String, dynamic> map = {
      "_name": name,
      "_proposal": proposal,
      "owner": adminAddress
    };
    var response = await dioClient.post(url + "/addCandidate", data: map);
    if (response.statusCode == 200) {
      return Right(response.data["data"][0]["txHash"]);
    } else {
      return Left(ErrorMessage(message: response.data["error"]["message"]));
    }
  }

  Future<void> addVoter(String voter) async {
    Map<String, dynamic> map = {"_voter": voter, "owner": adminAddress};

    return await dioClient.post(url + "/addVoter", data: map);
  }

  Future<void> delegateVoter(String delegate, String owner) async {
    Map<String, dynamic> map = {"_delegate": delegate, "owner": owner};
    return await dioClient.post(url + "/delegateVoter", data: map);
  }

  Future<void> endElection() async {
    Map<String, dynamic> map = {"onwer": adminAddress};
    return await dioClient.post(url + "/endElection", data: map);
  }

  Future<void> startElection() async {
    Map<String, dynamic> map = {"onwer": adminAddress};
    return await dioClient.post(url + "/startElection", data: map);
  }

  Future<Either<String, ErrorMessage>> vote(int id, String owner) async {
    Map<String, dynamic> map = {"owner": owner, "_ID": id};
    try {
      await dioClient.post(url + "/vote", data: map);
    } catch (e) {}
  }
}
