class Visit {
  final int id;
  final int customerId;
  final DateTime visitDate;
  final String status;
  final String location;
  final String notes;
  final List<int> activitiesDone;
  final DateTime createdAt;

  Visit({
    required this.id,
    required this.customerId,
    required this.visitDate,
    required this.status,
    required this.location,
    required this.notes,
    required this.activitiesDone,
    required this.createdAt,
  });

  factory Visit.fromJson(Map<String, dynamic> json) {
    // Safely handle activities_done field
    List<int> parseActivities() {
      try {
        if (json['activities_done'] == null) return [];
        
        final activities = json['activities_done'] as List;
        return activities.map<int>((item) {
          if (item == null) return 0;
          if (item is int) return item;
          // Convert string to int
          return int.tryParse(item.toString()) ?? 0;
        }).toList();
      } catch (e) {
        // print('Error parsing activities_done: $e');
        return [];
      }
    }
    
    // Safely parse DateTime fields
    DateTime parseDateTimeField(String fieldName) {
      try {
        return json[fieldName] != null 
            ? DateTime.parse(json[fieldName]) 
            : DateTime.now();
      } catch (e) {
        // print('Error parsing $fieldName: $e');
        return DateTime.now();
      }
    }
    
    return Visit(
      id: json['id'] ?? 0,
      customerId: json['customer_id'] ?? 0,
      visitDate: parseDateTimeField('visit_date'),
      status: json['status']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      notes: json['notes']?.toString() ?? '',
      activitiesDone: parseActivities(),
      createdAt: parseDateTimeField('created_at'),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'visit_date': visitDate.toIso8601String(),
      'status': status,
      'location': location,
      'notes': notes,
      'activities_done': activitiesDone,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
