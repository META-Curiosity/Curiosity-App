class NightlyEvaluation {
  bool isSuccessful;
  String id;
  String reflection;
  String imageProof; // stored as base64 encoding
  int hashedDate; // comparison purpose

  NightlyEvaluation.fromData(Map<String, dynamic> data) {
    isSuccessful = data["isSuccessful"];
    id = data["id"];
    reflection = data["reflection"];
    imageProof = data["imageProof"];
    hashedDate = data["hashedDate"];
  }

  // Default constructor for a nightly evaluation
  NightlyEvaluation() {
    isSuccessful = false;
    id = '';
    reflection = '';
    imageProof = '';
    hashedDate = null;
  }

  NightlyEvaluation.fromInput(String dateInput, String reflectionInput,
      String imageProofInput, bool isSuccessfulInput, int hashedDateInput) {
    isSuccessful = isSuccessfulInput;
    id = dateInput;
    reflection = reflectionInput;
    imageProof = imageProofInput;
    hashedDate = hashedDateInput;
  }

  Map<String, dynamic> toJson() {
    return {
      'isSuccessful': isSuccessful,
      'id': id,
      'reflection': reflection,
      'imageProof': imageProof,
      'hashedDate': hashedDate
    };
  }

  @override
  String toString() {
    return "{'isSuccessful': ${isSuccessful}, 'id': ${id}, 'reflection': ${reflection}, 'imageProof': ${imageProof}}";
  }
}
