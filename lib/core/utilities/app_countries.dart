class AppCountry {
  const AppCountry({
    required this.name,
    required this.code,
    required this.flagEmoji,
  });

  final String name;
  final String code;
  final String flagEmoji;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AppCountry && other.code == code;
  }

  @override
  int get hashCode => code.hashCode;
}

abstract final class AppCountries {
  static const List<AppCountry> all = [
    AppCountry(name: 'Afghanistan', code: 'AF', flagEmoji: '🇦🇫'),
    AppCountry(name: 'Albania', code: 'AL', flagEmoji: '🇦🇱'),
    AppCountry(name: 'Algeria', code: 'DZ', flagEmoji: '🇩🇿'),
    AppCountry(name: 'Andorra', code: 'AD', flagEmoji: '🇦🇩'),
    AppCountry(name: 'Angola', code: 'AO', flagEmoji: '🇦🇴'),
    AppCountry(name: 'Antigua and Barbuda', code: 'AG', flagEmoji: '🇦🇬'),
    AppCountry(name: 'Argentina', code: 'AR', flagEmoji: '🇦🇷'),
    AppCountry(name: 'Armenia', code: 'AM', flagEmoji: '🇦🇲'),
    AppCountry(name: 'Australia', code: 'AU', flagEmoji: '🇦🇺'),
    AppCountry(name: 'Austria', code: 'AT', flagEmoji: '🇦🇹'),
    AppCountry(name: 'Azerbaijan', code: 'AZ', flagEmoji: '🇦🇿'),

    AppCountry(name: 'Bahamas', code: 'BS', flagEmoji: '🇧🇸'),
    AppCountry(name: 'Bahrain', code: 'BH', flagEmoji: '🇧🇭'),
    AppCountry(name: 'Bangladesh', code: 'BD', flagEmoji: '🇧🇩'),
    AppCountry(name: 'Barbados', code: 'BB', flagEmoji: '🇧🇧'),
    AppCountry(name: 'Belarus', code: 'BY', flagEmoji: '🇧🇾'),
    AppCountry(name: 'Belgium', code: 'BE', flagEmoji: '🇧🇪'),
    AppCountry(name: 'Belize', code: 'BZ', flagEmoji: '🇧🇿'),
    AppCountry(name: 'Benin', code: 'BJ', flagEmoji: '🇧🇯'),
    AppCountry(name: 'Bhutan', code: 'BT', flagEmoji: '🇧🇹'),
    AppCountry(name: 'Bolivia', code: 'BO', flagEmoji: '🇧🇴'),
    AppCountry(name: 'Bosnia and Herzegovina', code: 'BA', flagEmoji: '🇧🇦'),
    AppCountry(name: 'Botswana', code: 'BW', flagEmoji: '🇧🇼'),
    AppCountry(name: 'Brazil', code: 'BR', flagEmoji: '🇧🇷'),
    AppCountry(name: 'Brunei', code: 'BN', flagEmoji: '🇧🇳'),
    AppCountry(name: 'Bulgaria', code: 'BG', flagEmoji: '🇧🇬'),
    AppCountry(name: 'Burkina Faso', code: 'BF', flagEmoji: '🇧🇫'),
    AppCountry(name: 'Burundi', code: 'BI', flagEmoji: '🇧🇮'),

    AppCountry(name: 'Cabo Verde', code: 'CV', flagEmoji: '🇨🇻'),
    AppCountry(name: 'Cambodia', code: 'KH', flagEmoji: '🇰🇭'),
    AppCountry(name: 'Cameroon', code: 'CM', flagEmoji: '🇨🇲'),
    AppCountry(name: 'Canada', code: 'CA', flagEmoji: '🇨🇦'),
    AppCountry(name: 'Central African Republic', code: 'CF', flagEmoji: '🇨🇫'),
    AppCountry(name: 'Chad', code: 'TD', flagEmoji: '🇹🇩'),
    AppCountry(name: 'Chile', code: 'CL', flagEmoji: '🇨🇱'),
    AppCountry(name: 'China', code: 'CN', flagEmoji: '🇨🇳'),
    AppCountry(name: 'Colombia', code: 'CO', flagEmoji: '🇨🇴'),
    AppCountry(name: 'Comoros', code: 'KM', flagEmoji: '🇰🇲'),
    AppCountry(name: 'Congo', code: 'CG', flagEmoji: '🇨🇬'),
    AppCountry(name: 'Costa Rica', code: 'CR', flagEmoji: '🇨🇷'),
    AppCountry(name: 'Côte d\'Ivoire', code: 'CI', flagEmoji: '🇨🇮'),
    AppCountry(name: 'Croatia', code: 'HR', flagEmoji: '🇭🇷'),
    AppCountry(name: 'Cuba', code: 'CU', flagEmoji: '🇨🇺'),
    AppCountry(name: 'Cyprus', code: 'CY', flagEmoji: '🇨🇾'),
    AppCountry(name: 'Czechia', code: 'CZ', flagEmoji: '🇨🇿'),

    AppCountry(
      name: 'Democratic Republic of the Congo',
      code: 'CD',
      flagEmoji: '🇨🇩',
    ),
    AppCountry(name: 'Denmark', code: 'DK', flagEmoji: '🇩🇰'),
    AppCountry(name: 'Djibouti', code: 'DJ', flagEmoji: '🇩🇯'),
    AppCountry(name: 'Dominica', code: 'DM', flagEmoji: '🇩🇲'),
    AppCountry(name: 'Dominican Republic', code: 'DO', flagEmoji: '🇩🇴'),

    AppCountry(name: 'Ecuador', code: 'EC', flagEmoji: '🇪🇨'),
    AppCountry(name: 'Egypt', code: 'EG', flagEmoji: '🇪🇬'),
    AppCountry(name: 'El Salvador', code: 'SV', flagEmoji: '🇸🇻'),
    AppCountry(name: 'Equatorial Guinea', code: 'GQ', flagEmoji: '🇬🇶'),
    AppCountry(name: 'Eritrea', code: 'ER', flagEmoji: '🇪🇷'),
    AppCountry(name: 'Estonia', code: 'EE', flagEmoji: '🇪🇪'),
    AppCountry(name: 'Eswatini', code: 'SZ', flagEmoji: '🇸🇿'),
    AppCountry(name: 'Ethiopia', code: 'ET', flagEmoji: '🇪🇹'),

    AppCountry(name: 'Fiji', code: 'FJ', flagEmoji: '🇫🇯'),
    AppCountry(name: 'Finland', code: 'FI', flagEmoji: '🇫🇮'),
    AppCountry(name: 'France', code: 'FR', flagEmoji: '🇫🇷'),

    AppCountry(name: 'Gabon', code: 'GA', flagEmoji: '🇬🇦'),
    AppCountry(name: 'Gambia', code: 'GM', flagEmoji: '🇬🇲'),
    AppCountry(name: 'Georgia', code: 'GE', flagEmoji: '🇬🇪'),
    AppCountry(name: 'Germany', code: 'DE', flagEmoji: '🇩🇪'),
    AppCountry(name: 'Ghana', code: 'GH', flagEmoji: '🇬🇭'),
    AppCountry(name: 'Greece', code: 'GR', flagEmoji: '🇬🇷'),
    AppCountry(name: 'Grenada', code: 'GD', flagEmoji: '🇬🇩'),
    AppCountry(name: 'Guatemala', code: 'GT', flagEmoji: '🇬🇹'),
    AppCountry(name: 'Guinea', code: 'GN', flagEmoji: '🇬🇳'),
    AppCountry(name: 'Guinea-Bissau', code: 'GW', flagEmoji: '🇬🇼'),
    AppCountry(name: 'Guyana', code: 'GY', flagEmoji: '🇬🇾'),

    AppCountry(name: 'Haiti', code: 'HT', flagEmoji: '🇭🇹'),
    AppCountry(name: 'Honduras', code: 'HN', flagEmoji: '🇭🇳'),
    AppCountry(name: 'Hungary', code: 'HU', flagEmoji: '🇭🇺'),

    AppCountry(name: 'Iceland', code: 'IS', flagEmoji: '🇮🇸'),
    AppCountry(name: 'India', code: 'IN', flagEmoji: '🇮🇳'),
    AppCountry(name: 'Indonesia', code: 'ID', flagEmoji: '🇮🇩'),
    AppCountry(name: 'Iran', code: 'IR', flagEmoji: '🇮🇷'),
    AppCountry(name: 'Iraq', code: 'IQ', flagEmoji: '🇮🇶'),
    AppCountry(name: 'Ireland', code: 'IE', flagEmoji: '🇮🇪'),
    AppCountry(name: 'Israel', code: 'IL', flagEmoji: '🇮🇱'),
    AppCountry(name: 'Italy', code: 'IT', flagEmoji: '🇮🇹'),

    AppCountry(name: 'Jamaica', code: 'JM', flagEmoji: '🇯🇲'),
    AppCountry(name: 'Japan', code: 'JP', flagEmoji: '🇯🇵'),
    AppCountry(name: 'Jordan', code: 'JO', flagEmoji: '🇯🇴'),

    AppCountry(name: 'Kazakhstan', code: 'KZ', flagEmoji: '🇰🇿'),
    AppCountry(name: 'Kenya', code: 'KE', flagEmoji: '🇰🇪'),
    AppCountry(name: 'Kiribati', code: 'KI', flagEmoji: '🇰🇮'),
    AppCountry(name: 'Kuwait', code: 'KW', flagEmoji: '🇰🇼'),
    AppCountry(name: 'Kyrgyzstan', code: 'KG', flagEmoji: '🇰🇬'),

    AppCountry(name: 'Laos', code: 'LA', flagEmoji: '🇱🇦'),
    AppCountry(name: 'Latvia', code: 'LV', flagEmoji: '🇱🇻'),
    AppCountry(name: 'Lebanon', code: 'LB', flagEmoji: '🇱🇧'),
    AppCountry(name: 'Lesotho', code: 'LS', flagEmoji: '🇱🇸'),
    AppCountry(name: 'Liberia', code: 'LR', flagEmoji: '🇱🇷'),
    AppCountry(name: 'Libya', code: 'LY', flagEmoji: '🇱🇾'),
    AppCountry(name: 'Liechtenstein', code: 'LI', flagEmoji: '🇱🇮'),
    AppCountry(name: 'Lithuania', code: 'LT', flagEmoji: '🇱🇹'),
    AppCountry(name: 'Luxembourg', code: 'LU', flagEmoji: '🇱🇺'),

    AppCountry(name: 'Madagascar', code: 'MG', flagEmoji: '🇲🇬'),
    AppCountry(name: 'Malawi', code: 'MW', flagEmoji: '🇲🇼'),
    AppCountry(name: 'Malaysia', code: 'MY', flagEmoji: '🇲🇾'),
    AppCountry(name: 'Maldives', code: 'MV', flagEmoji: '🇲🇻'),
    AppCountry(name: 'Mali', code: 'ML', flagEmoji: '🇲🇱'),
    AppCountry(name: 'Malta', code: 'MT', flagEmoji: '🇲🇹'),
    AppCountry(name: 'Marshall Islands', code: 'MH', flagEmoji: '🇲🇭'),
    AppCountry(name: 'Mauritania', code: 'MR', flagEmoji: '🇲🇷'),
    AppCountry(name: 'Mauritius', code: 'MU', flagEmoji: '🇲🇺'),
    AppCountry(name: 'Mexico', code: 'MX', flagEmoji: '🇲🇽'),
    AppCountry(name: 'Micronesia', code: 'FM', flagEmoji: '🇫🇲'),
    AppCountry(name: 'Moldova', code: 'MD', flagEmoji: '🇲🇩'),
    AppCountry(name: 'Monaco', code: 'MC', flagEmoji: '🇲🇨'),
    AppCountry(name: 'Mongolia', code: 'MN', flagEmoji: '🇲🇳'),
    AppCountry(name: 'Montenegro', code: 'ME', flagEmoji: '🇲🇪'),
    AppCountry(name: 'Morocco', code: 'MA', flagEmoji: '🇲🇦'),
    AppCountry(name: 'Mozambique', code: 'MZ', flagEmoji: '🇲🇿'),
    AppCountry(name: 'Myanmar', code: 'MM', flagEmoji: '🇲🇲'),

    AppCountry(name: 'Namibia', code: 'NA', flagEmoji: '🇳🇦'),
    AppCountry(name: 'Nauru', code: 'NR', flagEmoji: '🇳🇷'),
    AppCountry(name: 'Nepal', code: 'NP', flagEmoji: '🇳🇵'),
    AppCountry(name: 'Netherlands', code: 'NL', flagEmoji: '🇳🇱'),
    AppCountry(name: 'New Zealand', code: 'NZ', flagEmoji: '🇳🇿'),
    AppCountry(name: 'Nicaragua', code: 'NI', flagEmoji: '🇳🇮'),
    AppCountry(name: 'Niger', code: 'NE', flagEmoji: '🇳🇪'),
    AppCountry(name: 'Nigeria', code: 'NG', flagEmoji: '🇳🇬'),
    AppCountry(name: 'North Korea', code: 'KP', flagEmoji: '🇰🇵'),
    AppCountry(name: 'North Macedonia', code: 'MK', flagEmoji: '🇲🇰'),
    AppCountry(name: 'Norway', code: 'NO', flagEmoji: '🇳🇴'),

    AppCountry(name: 'Oman', code: 'OM', flagEmoji: '🇴🇲'),

    AppCountry(name: 'Pakistan', code: 'PK', flagEmoji: '🇵🇰'),
    AppCountry(name: 'Palau', code: 'PW', flagEmoji: '🇵🇼'),
    AppCountry(name: 'Palestine', code: 'PS', flagEmoji: '🇵🇸'),
    AppCountry(name: 'Panama', code: 'PA', flagEmoji: '🇵🇦'),
    AppCountry(name: 'Papua New Guinea', code: 'PG', flagEmoji: '🇵🇬'),
    AppCountry(name: 'Paraguay', code: 'PY', flagEmoji: '🇵🇾'),
    AppCountry(name: 'Peru', code: 'PE', flagEmoji: '🇵🇪'),
    AppCountry(name: 'Philippines', code: 'PH', flagEmoji: '🇵🇭'),
    AppCountry(name: 'Poland', code: 'PL', flagEmoji: '🇵🇱'),
    AppCountry(name: 'Portugal', code: 'PT', flagEmoji: '🇵🇹'),

    AppCountry(name: 'Qatar', code: 'QA', flagEmoji: '🇶🇦'),

    AppCountry(name: 'Romania', code: 'RO', flagEmoji: '🇷🇴'),
    AppCountry(name: 'Russia', code: 'RU', flagEmoji: '🇷🇺'),
    AppCountry(name: 'Rwanda', code: 'RW', flagEmoji: '🇷🇼'),

    AppCountry(name: 'Saint Kitts and Nevis', code: 'KN', flagEmoji: '🇰🇳'),
    AppCountry(name: 'Saint Lucia', code: 'LC', flagEmoji: '🇱🇨'),
    AppCountry(
      name: 'Saint Vincent and the Grenadines',
      code: 'VC',
      flagEmoji: '🇻🇨',
    ),
    AppCountry(name: 'Samoa', code: 'WS', flagEmoji: '🇼🇸'),
    AppCountry(name: 'San Marino', code: 'SM', flagEmoji: '🇸🇲'),
    AppCountry(name: 'Sao Tome and Principe', code: 'ST', flagEmoji: '🇸🇹'),
    AppCountry(name: 'Saudi Arabia', code: 'SA', flagEmoji: '🇸🇦'),
    AppCountry(name: 'Senegal', code: 'SN', flagEmoji: '🇸🇳'),
    AppCountry(name: 'Serbia', code: 'RS', flagEmoji: '🇷🇸'),
    AppCountry(name: 'Seychelles', code: 'SC', flagEmoji: '🇸🇨'),
    AppCountry(name: 'Sierra Leone', code: 'SL', flagEmoji: '🇸🇱'),
    AppCountry(name: 'Singapore', code: 'SG', flagEmoji: '🇸🇬'),
    AppCountry(name: 'Slovakia', code: 'SK', flagEmoji: '🇸🇰'),
    AppCountry(name: 'Slovenia', code: 'SI', flagEmoji: '🇸🇮'),
    AppCountry(name: 'Solomon Islands', code: 'SB', flagEmoji: '🇸🇧'),
    AppCountry(name: 'Somalia', code: 'SO', flagEmoji: '🇸🇴'),
    AppCountry(name: 'South Africa', code: 'ZA', flagEmoji: '🇿🇦'),
    AppCountry(name: 'South Korea', code: 'KR', flagEmoji: '🇰🇷'),
    AppCountry(name: 'South Sudan', code: 'SS', flagEmoji: '🇸🇸'),
    AppCountry(name: 'Spain', code: 'ES', flagEmoji: '🇪🇸'),
    AppCountry(name: 'Sri Lanka', code: 'LK', flagEmoji: '🇱🇰'),
    AppCountry(name: 'Sudan', code: 'SD', flagEmoji: '🇸🇩'),
    AppCountry(name: 'Suriname', code: 'SR', flagEmoji: '🇸🇷'),
    AppCountry(name: 'Sweden', code: 'SE', flagEmoji: '🇸🇪'),
    AppCountry(name: 'Switzerland', code: 'CH', flagEmoji: '🇨🇭'),
    AppCountry(name: 'Syria', code: 'SY', flagEmoji: '🇸🇾'),

    AppCountry(name: 'Tajikistan', code: 'TJ', flagEmoji: '🇹🇯'),
    AppCountry(name: 'Tanzania', code: 'TZ', flagEmoji: '🇹🇿'),
    AppCountry(name: 'Thailand', code: 'TH', flagEmoji: '🇹🇭'),
    AppCountry(name: 'Timor-Leste', code: 'TL', flagEmoji: '🇹🇱'),
    AppCountry(name: 'Togo', code: 'TG', flagEmoji: '🇹🇬'),
    AppCountry(name: 'Tonga', code: 'TO', flagEmoji: '🇹🇴'),
    AppCountry(name: 'Trinidad and Tobago', code: 'TT', flagEmoji: '🇹🇹'),
    AppCountry(name: 'Tunisia', code: 'TN', flagEmoji: '🇹🇳'),
    AppCountry(name: 'Türkiye', code: 'TR', flagEmoji: '🇹🇷'),
    AppCountry(name: 'Turkmenistan', code: 'TM', flagEmoji: '🇹🇲'),
    AppCountry(name: 'Tuvalu', code: 'TV', flagEmoji: '🇹🇻'),

    AppCountry(name: 'Uganda', code: 'UG', flagEmoji: '🇺🇬'),
    AppCountry(name: 'Ukraine', code: 'UA', flagEmoji: '🇺🇦'),
    AppCountry(name: 'United Arab Emirates', code: 'AE', flagEmoji: '🇦🇪'),
    AppCountry(name: 'United Kingdom', code: 'GB', flagEmoji: '🇬🇧'),
    AppCountry(name: 'United States', code: 'US', flagEmoji: '🇺🇸'),
    AppCountry(name: 'Uruguay', code: 'UY', flagEmoji: '🇺🇾'),
    AppCountry(name: 'Uzbekistan', code: 'UZ', flagEmoji: '🇺🇿'),

    AppCountry(name: 'Vanuatu', code: 'VU', flagEmoji: '🇻🇺'),
    AppCountry(name: 'Vatican City', code: 'VA', flagEmoji: '🇻🇦'),
    AppCountry(name: 'Venezuela', code: 'VE', flagEmoji: '🇻🇪'),
    AppCountry(name: 'Vietnam', code: 'VN', flagEmoji: '🇻🇳'),

    AppCountry(name: 'Yemen', code: 'YE', flagEmoji: '🇾🇪'),

    AppCountry(name: 'Zambia', code: 'ZM', flagEmoji: '🇿🇲'),
    AppCountry(name: 'Zimbabwe', code: 'ZW', flagEmoji: '🇿🇼'),
  ];

  static AppCountry? findByName(String? name) {
    if (name == null || name.trim().isEmpty) return null;
    final normalized = name.trim().toLowerCase();
    if (normalized == 'uk' || normalized == 'great britain' || normalized == 'england' || normalized == 'scotland' || normalized == 'wales' || normalized == 'northern ireland') {
      return findByCode('GB');
    }
    if (normalized == 'usa' || normalized == 'america') {
      return findByCode('US');
    }
    try {
      return all.firstWhere(
        (country) => country.name.toLowerCase() == normalized,
      );
    } catch (_) {
      return null;
    }
  }

  static AppCountry? findByCode(String? code) {
    if (code == null || code.trim().isEmpty) return null;
    final normalized = code.trim().toUpperCase();
    if (normalized == 'UK') return findByCode('GB');
    try {
      return all.firstWhere(
        (country) => country.code.toUpperCase() == normalized,
      );
    } catch (_) {
      return null;
    }
  }

  static AppCountry? findByNameOrCode(String? query) {
    if (query == null || query.trim().isEmpty) return null;
    return findByName(query) ?? findByCode(query);
  }

  static const List<AppCountry> popular = [
    AppCountry(name: 'United Kingdom', code: 'GB', flagEmoji: '🇬🇧'),
    AppCountry(name: 'Ireland', code: 'IE', flagEmoji: '🇮🇪'),
    AppCountry(name: 'United States', code: 'US', flagEmoji: '🇺🇸'),
    AppCountry(name: 'Canada', code: 'CA', flagEmoji: '🇨🇦'),
    AppCountry(name: 'Australia', code: 'AU', flagEmoji: '🇦🇺'),
    AppCountry(name: 'Bangladesh', code: 'BD', flagEmoji: '🇧🇩'),
    AppCountry(name: 'India', code: 'IN', flagEmoji: '🇮🇳'),
    AppCountry(name: 'Pakistan', code: 'PK', flagEmoji: '🇵🇰'),
  ];

  static List<AppCountry> search(String query) {
    if (query.trim().isEmpty) return all;
    final q = query.trim().toLowerCase();
    final isUkSearch = q == 'uk' || q == 'great britain' || q == 'england' || q == 'britain';
    return all.where((c) {
      if (isUkSearch && c.code == 'GB') return true;
      return c.name.toLowerCase().contains(q) ||
          c.code.toLowerCase().contains(q);
    }).toList();
  }
}

