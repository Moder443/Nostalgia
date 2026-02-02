class Sound {
  final String id;
  final String title;
  final String description;
  final String category;
  final String audioUrl;
  final String? imageUrl;
  final Duration duration;
  final List<String> tags;
  final bool isFavorite;

  const Sound({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.audioUrl,
    this.imageUrl,
    required this.duration,
    this.tags = const [],
    this.isFavorite = false,
  });

  Sound copyWith({
    String? id,
    String? title,
    String? description,
    String? category,
    String? audioUrl,
    String? imageUrl,
    Duration? duration,
    List<String>? tags,
    bool? isFavorite,
  }) {
    return Sound(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      audioUrl: audioUrl ?? this.audioUrl,
      imageUrl: imageUrl ?? this.imageUrl,
      duration: duration ?? this.duration,
      tags: tags ?? this.tags,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class SoundCategory {
  final String id;
  final String name;
  final String icon;
  final int count;

  const SoundCategory({
    required this.id,
    required this.name,
    required this.icon,
    this.count = 0,
  });
}
