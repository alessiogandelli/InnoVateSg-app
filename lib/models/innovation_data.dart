class InnovationData {
  final List<String> businessModel;
  final List<String> productInnovation;
  final List<String> processInnovation;
  final List<String> customerExperience;
  final List<String> technologyAdoption;

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
      businessModel: List<String>.from(json['businessModel']),
      productInnovation: List<String>.from(json['productInnovation']),
      processInnovation: List<String>.from(json['processInnovation']),
      customerExperience: List<String>.from(json['customerExperience']),
      technologyAdoption: List<String>.from(json['technologyAdoption']),
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


}