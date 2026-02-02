class Country {
  final String code;
  final String nameEn;
  final String nameRu;

  const Country({
    required this.code,
    required this.nameEn,
    required this.nameRu,
  });

  String getName(String locale) => locale == 'ru' ? nameRu : nameEn;
}

class Countries {
  static const List<Country> all = [
    // CIS countries first (most relevant)
    Country(code: 'ru', nameEn: 'Russia', nameRu: 'Россия'),
    Country(code: 'ua', nameEn: 'Ukraine', nameRu: 'Украина'),
    Country(code: 'by', nameEn: 'Belarus', nameRu: 'Беларусь'),
    Country(code: 'kz', nameEn: 'Kazakhstan', nameRu: 'Казахстан'),
    Country(code: 'uz', nameEn: 'Uzbekistan', nameRu: 'Узбекистан'),
    Country(code: 'az', nameEn: 'Azerbaijan', nameRu: 'Азербайджан'),
    Country(code: 'ge', nameEn: 'Georgia', nameRu: 'Грузия'),
    Country(code: 'am', nameEn: 'Armenia', nameRu: 'Армения'),
    Country(code: 'md', nameEn: 'Moldova', nameRu: 'Молдова'),
    Country(code: 'kg', nameEn: 'Kyrgyzstan', nameRu: 'Киргизия'),
    Country(code: 'tj', nameEn: 'Tajikistan', nameRu: 'Таджикистан'),
    Country(code: 'tm', nameEn: 'Turkmenistan', nameRu: 'Туркменистан'),
    Country(code: 'lv', nameEn: 'Latvia', nameRu: 'Латвия'),
    Country(code: 'lt', nameEn: 'Lithuania', nameRu: 'Литва'),
    Country(code: 'ee', nameEn: 'Estonia', nameRu: 'Эстония'),

    // Europe
    Country(code: 'de', nameEn: 'Germany', nameRu: 'Германия'),
    Country(code: 'fr', nameEn: 'France', nameRu: 'Франция'),
    Country(code: 'gb', nameEn: 'United Kingdom', nameRu: 'Великобритания'),
    Country(code: 'it', nameEn: 'Italy', nameRu: 'Италия'),
    Country(code: 'es', nameEn: 'Spain', nameRu: 'Испания'),
    Country(code: 'pt', nameEn: 'Portugal', nameRu: 'Португалия'),
    Country(code: 'nl', nameEn: 'Netherlands', nameRu: 'Нидерланды'),
    Country(code: 'be', nameEn: 'Belgium', nameRu: 'Бельгия'),
    Country(code: 'ch', nameEn: 'Switzerland', nameRu: 'Швейцария'),
    Country(code: 'at', nameEn: 'Austria', nameRu: 'Австрия'),
    Country(code: 'pl', nameEn: 'Poland', nameRu: 'Польша'),
    Country(code: 'cz', nameEn: 'Czech Republic', nameRu: 'Чехия'),
    Country(code: 'sk', nameEn: 'Slovakia', nameRu: 'Словакия'),
    Country(code: 'hu', nameEn: 'Hungary', nameRu: 'Венгрия'),
    Country(code: 'ro', nameEn: 'Romania', nameRu: 'Румыния'),
    Country(code: 'bg', nameEn: 'Bulgaria', nameRu: 'Болгария'),
    Country(code: 'rs', nameEn: 'Serbia', nameRu: 'Сербия'),
    Country(code: 'hr', nameEn: 'Croatia', nameRu: 'Хорватия'),
    Country(code: 'si', nameEn: 'Slovenia', nameRu: 'Словения'),
    Country(code: 'ba', nameEn: 'Bosnia and Herzegovina', nameRu: 'Босния и Герцеговина'),
    Country(code: 'me', nameEn: 'Montenegro', nameRu: 'Черногория'),
    Country(code: 'mk', nameEn: 'North Macedonia', nameRu: 'Северная Македония'),
    Country(code: 'al', nameEn: 'Albania', nameRu: 'Албания'),
    Country(code: 'gr', nameEn: 'Greece', nameRu: 'Греция'),
    Country(code: 'cy', nameEn: 'Cyprus', nameRu: 'Кипр'),
    Country(code: 'tr', nameEn: 'Turkey', nameRu: 'Турция'),
    Country(code: 'se', nameEn: 'Sweden', nameRu: 'Швеция'),
    Country(code: 'no', nameEn: 'Norway', nameRu: 'Норвегия'),
    Country(code: 'dk', nameEn: 'Denmark', nameRu: 'Дания'),
    Country(code: 'fi', nameEn: 'Finland', nameRu: 'Финляндия'),
    Country(code: 'is', nameEn: 'Iceland', nameRu: 'Исландия'),
    Country(code: 'ie', nameEn: 'Ireland', nameRu: 'Ирландия'),
    Country(code: 'lu', nameEn: 'Luxembourg', nameRu: 'Люксембург'),
    Country(code: 'mt', nameEn: 'Malta', nameRu: 'Мальта'),
    Country(code: 'mc', nameEn: 'Monaco', nameRu: 'Монако'),
    Country(code: 'ad', nameEn: 'Andorra', nameRu: 'Андорра'),
    Country(code: 'li', nameEn: 'Liechtenstein', nameRu: 'Лихтенштейн'),
    Country(code: 'sm', nameEn: 'San Marino', nameRu: 'Сан-Марино'),
    Country(code: 'va', nameEn: 'Vatican City', nameRu: 'Ватикан'),

    // North America
    Country(code: 'us', nameEn: 'United States', nameRu: 'США'),
    Country(code: 'ca', nameEn: 'Canada', nameRu: 'Канада'),
    Country(code: 'mx', nameEn: 'Mexico', nameRu: 'Мексика'),

    // Central America & Caribbean
    Country(code: 'cu', nameEn: 'Cuba', nameRu: 'Куба'),
    Country(code: 'jm', nameEn: 'Jamaica', nameRu: 'Ямайка'),
    Country(code: 'ht', nameEn: 'Haiti', nameRu: 'Гаити'),
    Country(code: 'do', nameEn: 'Dominican Republic', nameRu: 'Доминиканская Республика'),
    Country(code: 'pr', nameEn: 'Puerto Rico', nameRu: 'Пуэрто-Рико'),
    Country(code: 'gt', nameEn: 'Guatemala', nameRu: 'Гватемала'),
    Country(code: 'hn', nameEn: 'Honduras', nameRu: 'Гондурас'),
    Country(code: 'sv', nameEn: 'El Salvador', nameRu: 'Сальвадор'),
    Country(code: 'ni', nameEn: 'Nicaragua', nameRu: 'Никарагуа'),
    Country(code: 'cr', nameEn: 'Costa Rica', nameRu: 'Коста-Рика'),
    Country(code: 'pa', nameEn: 'Panama', nameRu: 'Панама'),
    Country(code: 'bz', nameEn: 'Belize', nameRu: 'Белиз'),

    // South America
    Country(code: 'br', nameEn: 'Brazil', nameRu: 'Бразилия'),
    Country(code: 'ar', nameEn: 'Argentina', nameRu: 'Аргентина'),
    Country(code: 'cl', nameEn: 'Chile', nameRu: 'Чили'),
    Country(code: 'co', nameEn: 'Colombia', nameRu: 'Колумбия'),
    Country(code: 'pe', nameEn: 'Peru', nameRu: 'Перу'),
    Country(code: 've', nameEn: 'Venezuela', nameRu: 'Венесуэла'),
    Country(code: 'ec', nameEn: 'Ecuador', nameRu: 'Эквадор'),
    Country(code: 'bo', nameEn: 'Bolivia', nameRu: 'Боливия'),
    Country(code: 'py', nameEn: 'Paraguay', nameRu: 'Парагвай'),
    Country(code: 'uy', nameEn: 'Uruguay', nameRu: 'Уругвай'),
    Country(code: 'gy', nameEn: 'Guyana', nameRu: 'Гайана'),
    Country(code: 'sr', nameEn: 'Suriname', nameRu: 'Суринам'),

    // Asia
    Country(code: 'cn', nameEn: 'China', nameRu: 'Китай'),
    Country(code: 'jp', nameEn: 'Japan', nameRu: 'Япония'),
    Country(code: 'kr', nameEn: 'South Korea', nameRu: 'Южная Корея'),
    Country(code: 'kp', nameEn: 'North Korea', nameRu: 'Северная Корея'),
    Country(code: 'in', nameEn: 'India', nameRu: 'Индия'),
    Country(code: 'pk', nameEn: 'Pakistan', nameRu: 'Пакистан'),
    Country(code: 'bd', nameEn: 'Bangladesh', nameRu: 'Бангладеш'),
    Country(code: 'id', nameEn: 'Indonesia', nameRu: 'Индонезия'),
    Country(code: 'my', nameEn: 'Malaysia', nameRu: 'Малайзия'),
    Country(code: 'th', nameEn: 'Thailand', nameRu: 'Таиланд'),
    Country(code: 'vn', nameEn: 'Vietnam', nameRu: 'Вьетнам'),
    Country(code: 'ph', nameEn: 'Philippines', nameRu: 'Филиппины'),
    Country(code: 'sg', nameEn: 'Singapore', nameRu: 'Сингапур'),
    Country(code: 'mm', nameEn: 'Myanmar', nameRu: 'Мьянма'),
    Country(code: 'kh', nameEn: 'Cambodia', nameRu: 'Камбоджа'),
    Country(code: 'la', nameEn: 'Laos', nameRu: 'Лаос'),
    Country(code: 'np', nameEn: 'Nepal', nameRu: 'Непал'),
    Country(code: 'bt', nameEn: 'Bhutan', nameRu: 'Бутан'),
    Country(code: 'lk', nameEn: 'Sri Lanka', nameRu: 'Шри-Ланка'),
    Country(code: 'mv', nameEn: 'Maldives', nameRu: 'Мальдивы'),
    Country(code: 'mn', nameEn: 'Mongolia', nameRu: 'Монголия'),
    Country(code: 'tw', nameEn: 'Taiwan', nameRu: 'Тайвань'),
    Country(code: 'hk', nameEn: 'Hong Kong', nameRu: 'Гонконг'),
    Country(code: 'mo', nameEn: 'Macau', nameRu: 'Макао'),
    Country(code: 'bn', nameEn: 'Brunei', nameRu: 'Бруней'),
    Country(code: 'tl', nameEn: 'Timor-Leste', nameRu: 'Восточный Тимор'),

    // Middle East
    Country(code: 'ae', nameEn: 'United Arab Emirates', nameRu: 'ОАЭ'),
    Country(code: 'sa', nameEn: 'Saudi Arabia', nameRu: 'Саудовская Аравия'),
    Country(code: 'ir', nameEn: 'Iran', nameRu: 'Иран'),
    Country(code: 'iq', nameEn: 'Iraq', nameRu: 'Ирак'),
    Country(code: 'il', nameEn: 'Israel', nameRu: 'Израиль'),
    Country(code: 'jo', nameEn: 'Jordan', nameRu: 'Иордания'),
    Country(code: 'lb', nameEn: 'Lebanon', nameRu: 'Ливан'),
    Country(code: 'sy', nameEn: 'Syria', nameRu: 'Сирия'),
    Country(code: 'kw', nameEn: 'Kuwait', nameRu: 'Кувейт'),
    Country(code: 'qa', nameEn: 'Qatar', nameRu: 'Катар'),
    Country(code: 'bh', nameEn: 'Bahrain', nameRu: 'Бахрейн'),
    Country(code: 'om', nameEn: 'Oman', nameRu: 'Оман'),
    Country(code: 'ye', nameEn: 'Yemen', nameRu: 'Йемен'),
    Country(code: 'af', nameEn: 'Afghanistan', nameRu: 'Афганистан'),
    Country(code: 'ps', nameEn: 'Palestine', nameRu: 'Палестина'),

    // Africa
    Country(code: 'eg', nameEn: 'Egypt', nameRu: 'Египет'),
    Country(code: 'ma', nameEn: 'Morocco', nameRu: 'Марокко'),
    Country(code: 'dz', nameEn: 'Algeria', nameRu: 'Алжир'),
    Country(code: 'tn', nameEn: 'Tunisia', nameRu: 'Тунис'),
    Country(code: 'ly', nameEn: 'Libya', nameRu: 'Ливия'),
    Country(code: 'za', nameEn: 'South Africa', nameRu: 'ЮАР'),
    Country(code: 'ng', nameEn: 'Nigeria', nameRu: 'Нигерия'),
    Country(code: 'ke', nameEn: 'Kenya', nameRu: 'Кения'),
    Country(code: 'et', nameEn: 'Ethiopia', nameRu: 'Эфиопия'),
    Country(code: 'gh', nameEn: 'Ghana', nameRu: 'Гана'),
    Country(code: 'tz', nameEn: 'Tanzania', nameRu: 'Танзания'),
    Country(code: 'ug', nameEn: 'Uganda', nameRu: 'Уганда'),
    Country(code: 'sd', nameEn: 'Sudan', nameRu: 'Судан'),
    Country(code: 'ao', nameEn: 'Angola', nameRu: 'Ангола'),
    Country(code: 'mz', nameEn: 'Mozambique', nameRu: 'Мозамбик'),
    Country(code: 'mg', nameEn: 'Madagascar', nameRu: 'Мадагаскар'),
    Country(code: 'cm', nameEn: 'Cameroon', nameRu: 'Камерун'),
    Country(code: 'ci', nameEn: 'Ivory Coast', nameRu: 'Кот-д\'Ивуар'),
    Country(code: 'sn', nameEn: 'Senegal', nameRu: 'Сенегал'),
    Country(code: 'zm', nameEn: 'Zambia', nameRu: 'Замбия'),
    Country(code: 'zw', nameEn: 'Zimbabwe', nameRu: 'Зимбабве'),
    Country(code: 'rw', nameEn: 'Rwanda', nameRu: 'Руанда'),
    Country(code: 'ml', nameEn: 'Mali', nameRu: 'Мали'),
    Country(code: 'bf', nameEn: 'Burkina Faso', nameRu: 'Буркина-Фасо'),
    Country(code: 'ne', nameEn: 'Niger', nameRu: 'Нигер'),
    Country(code: 'td', nameEn: 'Chad', nameRu: 'Чад'),
    Country(code: 'so', nameEn: 'Somalia', nameRu: 'Сомали'),
    Country(code: 'cg', nameEn: 'Congo', nameRu: 'Конго'),
    Country(code: 'cd', nameEn: 'DR Congo', nameRu: 'ДР Конго'),
    Country(code: 'bw', nameEn: 'Botswana', nameRu: 'Ботсвана'),
    Country(code: 'na', nameEn: 'Namibia', nameRu: 'Намибия'),
    Country(code: 'mu', nameEn: 'Mauritius', nameRu: 'Маврикий'),

    // Oceania
    Country(code: 'au', nameEn: 'Australia', nameRu: 'Австралия'),
    Country(code: 'nz', nameEn: 'New Zealand', nameRu: 'Новая Зеландия'),
    Country(code: 'fj', nameEn: 'Fiji', nameRu: 'Фиджи'),
    Country(code: 'pg', nameEn: 'Papua New Guinea', nameRu: 'Папуа-Новая Гвинея'),
    Country(code: 'ws', nameEn: 'Samoa', nameRu: 'Самоа'),
    Country(code: 'to', nameEn: 'Tonga', nameRu: 'Тонга'),
    Country(code: 'vu', nameEn: 'Vanuatu', nameRu: 'Вануату'),
  ];

  static Country? findByCode(String code) {
    try {
      return all.firstWhere((c) => c.code == code);
    } catch (_) {
      return null;
    }
  }

  static List<Country> search(String query, String locale) {
    if (query.isEmpty) return all;
    final lowerQuery = query.toLowerCase();
    return all.where((c) =>
      c.getName(locale).toLowerCase().contains(lowerQuery) ||
      c.code.toLowerCase().contains(lowerQuery)
    ).toList();
  }
}
