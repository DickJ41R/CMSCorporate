class ClientData {
  ClientData({ required this.clientId, required this.clientName,
   required this.branchId, required this.status});
  final int clientId;
  final String clientName;
  final int branchId;
  final String status;

  factory ClientData.fromJson(Map<String, Object?> json) {
    if (json case {'clientId': int clientId, 'clientName': String clientName,
    'branchId': int branchId, 'status': String status
    }) {
      return ClientData(clientId: clientId, clientName:clientName,
           branchId: branchId, status: status);
    } else {
      throw UnsupportedError('Could not convert $json to UserModel.');
    }
}
  Map<String, Object?> toJson() => {'clientId': clientId, 'clientName': clientName,
   'branchId': branchId, 'status': status};
}