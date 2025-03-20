class InnovationData {
  final List<Map<String, String>> businessModel;
  final List<Map<String, String>> productInnovation;
  final List<Map<String, String>> processInnovation;
  final List<Map<String, String>> customerExperience;
  final List<Map<String, String>> technologyAdoption;

  InnovationData({
    required this.businessModel,
    required this.productInnovation,
    required this.processInnovation,
    required this.customerExperience,
    required this.technologyAdoption,
  });

  Map<String, dynamic> toJson() => {
        'businessModel': businessModel,
        'productInnovation': productInnovation,
        'processInnovation': processInnovation,
        'customerExperience': customerExperience,
        'technologyAdoption': technologyAdoption,
      };

  factory InnovationData.fromJson(Map<String, dynamic> json) {
    return InnovationData(
      businessModel: List<Map<String, String>>.from(
          json['businessModel'].map((item) => Map<String, String>.from(item))),
      productInnovation: List<Map<String, String>>.from(
          json['productInnovation'].map((item) => Map<String, String>.from(item))),
      processInnovation: List<Map<String, String>>.from(
          json['processInnovation'].map((item) => Map<String, String>.from(item))),
      customerExperience: List<Map<String, String>>.from(
          json['customerExperience'].map((item) => Map<String, String>.from(item))),
      technologyAdoption: List<Map<String, String>>.from(
          json['technologyAdoption'].map((item) => Map<String, String>.from(item))),
    );
  }

  factory InnovationData.empty() {
    return InnovationData(
      businessModel: [],
      productInnovation: [],
      processInnovation: [],
      customerExperience: [],
      technologyAdoption: [],
    );
  }

  @override
  String toString() {
    return 'InnovationData{businessModel: $businessModel, productInnovation: $productInnovation, processInnovation: $processInnovation, customerExperience: $customerExperience, technologyAdoption: $technologyAdoption}';
  }
}