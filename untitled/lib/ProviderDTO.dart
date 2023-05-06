class ProviderDTO {
  String? logoPath;
  int? providerId;
  String? providerName;
  int? displayPriority;

  ProviderDTO(
      {this.logoPath,
        this.providerId,
        this.providerName,
        this.displayPriority});

  ProviderDTO.fromJson(Map<String, dynamic> json) {
    logoPath = json['logo_path'];
    providerId = json['provider_id'];
    providerName = json['provider_name'];
    displayPriority = json['display_priority'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['logo_path'] = logoPath;
    data['provider_id'] = providerId;
    data['provider_name'] = providerName;
    data['display_priority'] = displayPriority;
    return data;
  }
}