class AddItemState {
  final String? imagePath;
  final bool isLoading;
  final Map<String, dynamic>? selectCategory; // id + name
  final List<Map<String, dynamic>> categories; // lista com id e name
  final List<String> size;
  final List<String> color;
  final bool isDiscouted;
  final String? discoutedPercentage;

  AddItemState({
    this.imagePath,
    this.isLoading = false,
    this.selectCategory,
    this.categories = const [],
    this.size = const [],
    this.color = const [],
    this.isDiscouted = false,
    this.discoutedPercentage,
  });

  AddItemState copyWith({
    String? imagePath,
    bool? isLoading,
    Map<String, dynamic>? selectCategory,
    List<Map<String, dynamic>>? categories,
    List<String>? size,
    List<String>? color,
    bool? isDiscouted,
    String? discoutedPercentage,
  }) {
    return AddItemState(
      imagePath: imagePath ?? this.imagePath,
      isLoading: isLoading ?? this.isLoading,
      selectCategory: selectCategory ?? this.selectCategory,
      categories: categories ?? this.categories,
      size: size ?? this.size,
      color: color ?? this.color,
      isDiscouted: isDiscouted ?? this.isDiscouted,
      discoutedPercentage: discoutedPercentage ?? this.discoutedPercentage,
    );
  }
}
