class AddItemState {
  final String? imagePath;
  final bool isLoading;
  final String? selectCategory;
  final List<String> categories;
  final List<String> size;
  final List<String> color;
  final bool isDiscouted;
  final String? discoutedPercentage;

  AddItemState({
    this.imagePath,
    this.isLoading = false,
    this.selectCategory,
    this.categories = const [],
    this.size = const [], // Valor padrão vazio
    this.color = const [],
    this.isDiscouted = false,
    this.discoutedPercentage,
  });

  AddItemState copyWith({
    String? imagePath,
    bool? isLoading,
    String? selectCategory,
    List<String>? categories,
    List<String>? size, // Corrigido para List<String>?
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
