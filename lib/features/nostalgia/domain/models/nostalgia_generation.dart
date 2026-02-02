class NostalgiaGeneration {
  final String id;
  final String date;
  final NostalgiaContent content;
  final NostalgiaContext context;
  final NostalgiaMedia? media;
  final bool cached;
  final DateTime generatedAt;

  const NostalgiaGeneration({
    required this.id,
    required this.date,
    required this.content,
    required this.context,
    this.media,
    this.cached = false,
    required this.generatedAt,
  });

  factory NostalgiaGeneration.fromJson(Map<String, dynamic> json) {
    return NostalgiaGeneration(
      id: json['id'] ?? '',
      date: json['date'] ?? '',
      content: NostalgiaContent.fromJson(json['content'] ?? {}),
      context: NostalgiaContext.fromJson(json['context'] ?? {}),
      media: json['media'] != null ? NostalgiaMedia.fromJson(json['media']) : null,
      cached: json['cached'] ?? false,
      generatedAt: DateTime.tryParse(json['generated_at'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'date': date,
      'content': content.toJson(),
      'context': context.toJson(),
      'media': media?.toJson(),
      'cached': cached,
      'generated_at': generatedAt.toIso8601String(),
    };
  }
}

class NostalgiaContent {
  final String title;
  final String body;
  final String memoryQuestion;
  final String closing;

  const NostalgiaContent({
    required this.title,
    required this.body,
    required this.memoryQuestion,
    required this.closing,
  });

  factory NostalgiaContent.fromJson(Map<String, dynamic> json) {
    return NostalgiaContent(
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      memoryQuestion: json['memory_question'] ?? '',
      closing: json['closing'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'memory_question': memoryQuestion,
      'closing': closing,
    };
  }
}

class NostalgiaContext {
  final int era;
  final String country;
  final int childhoodYear;

  const NostalgiaContext({
    required this.era,
    required this.country,
    required this.childhoodYear,
  });

  factory NostalgiaContext.fromJson(Map<String, dynamic> json) {
    return NostalgiaContext(
      era: json['era'] ?? 1990,
      country: json['country'] ?? 'ru',
      childhoodYear: json['childhood_year'] ?? 1995,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'era': era,
      'country': country,
      'childhood_year': childhoodYear,
    };
  }
}

class NostalgiaMedia {
  final String? ambientAudioUrl;
  final String? backgroundImageUrl;

  const NostalgiaMedia({
    this.ambientAudioUrl,
    this.backgroundImageUrl,
  });

  factory NostalgiaMedia.fromJson(Map<String, dynamic> json) {
    return NostalgiaMedia(
      ambientAudioUrl: json['ambient_audio_url'],
      backgroundImageUrl: json['background_image_url'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ambient_audio_url': ambientAudioUrl,
      'background_image_url': backgroundImageUrl,
    };
  }
}

/// Simplified model for history list items
class NostalgiaHistoryItem {
  final String id;
  final String date;
  final String title;
  final String preview;
  final String? imageUrl;

  const NostalgiaHistoryItem({
    required this.id,
    required this.date,
    required this.title,
    required this.preview,
    this.imageUrl,
  });

  factory NostalgiaHistoryItem.fromJson(Map<String, dynamic> json) {
    return NostalgiaHistoryItem(
      id: json['id'] ?? '',
      date: json['date'] ?? '',
      title: json['title'] ?? '',
      preview: json['preview'] ?? '',
      imageUrl: json['image_url'] ?? json['background_image_url'],
    );
  }
}
