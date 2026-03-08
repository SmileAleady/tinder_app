import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:tinder_app/data/auth/user_auth_local_db.dart';
import 'package:tinder_app/data/home/home_swipe_local_db.dart';
import 'package:tinder_app/model/user_profile_model.dart';

/// English(EN11EN)
enum SheetOptionType {
  constellation, // English
  education, // English
  petPreference, // English
  smoking, // English
  drinking, // English
  jobStatus, // English
  income, // English
  residence, // English
  car, // English
  relationshipStatus, // English
  socialMediaActivity, // English
  fitness, // English
  wantChildren, // English
  communicationStyle, // English
  loveLanguage, // English
  //
  goOut,
  weekend,
  phoneUsage,
}

/// English
class OptionItem {
  final String id;
  final String title;

  const OptionItem({required this.id, required this.title});
}

/// English
class OptionConfig {
  final String title;
  final String hintText;
  final String question;
  final List<OptionItem> options;

  const OptionConfig({
    required this.title,
    required this.hintText,
    required this.question,
    required this.options,
  });
}

/// English
class OptionDataManager {
  static final List<SexualOrientationModel> sexualOrientations = [
    const SexualOrientationModel(
      id: 'heterosexual',
      name: 'Heterosexual',
      desc: 'Text 2',
    ),
    const SexualOrientationModel(
      id: 'gay',
      name: 'Gay',
      desc: 'Text 3, Text 4',
    ),
    const SexualOrientationModel(
      id: 'lesbian',
      name: 'Lesbian',
      desc: 'Text 5, Text 6YesText 7',
    ),
    const SexualOrientationModel(
      id: 'bisexual',
      name: 'Bisexual',
      desc: 'Text 8YesText 9, Text 10YesText 11',
    ),
    const SexualOrientationModel(
      id: 'asexual',
      name: 'Asexual',
      desc: 'Text 12',
    ),
    const SexualOrientationModel(
      id: 'demisexual',
      name: 'Demisexual',
      desc: 'Text 13YesText 14',
    ),
    const SexualOrientationModel(
      id: 'pansexual',
      name: 'Pansexual',
      desc: 'Text 15YesText 9, Text 16YesText 11',
    ),
    const SexualOrientationModel(
      id: 'queer',
      name: 'Queer',
      desc: 'Text 17, Text 18',
    ),
    const SexualOrientationModel(
      id: 'questioning',
      name: 'Questioning',
      desc: 'Text 19/Text 20',
    ),
    const SexualOrientationModel(
      id: 'other',
      name: 'Not listed',
      desc: 'Text 21.',
    ),
  ];

  // English(English)
  static final List<GenderModel> genders = [
    const GenderModel(id: 'male', name: 'Male'),
    const GenderModel(id: 'female', name: 'Female'),
    const GenderModel(
      id: 'non_binary',
      name: 'Text 22',
      desc: 'Text 23, Text 24',
    ),
  ];

  static final List<MusicModel> songs = [
    MusicModel(
      title: "Risk It All",
      artist: "Bruno Mars",
      coverImageUrl: "https://example.com/cover1.jpg",
    ),
    MusicModel(
      title: "Stateside + Zara Larsson",
      artist: "PinkPantheress",
      coverImageUrl: "https://example.com/cover2.jpg",
    ),
    MusicModel(
      title: "Choosin' Texas",
      artist: "Ella Langley",
      coverImageUrl: "https://example.com/cover3.jpg",
    ),
    MusicModel(
      title: "I Just Might",
      artist: "Bruno Mars",
      coverImageUrl: "https://example.com/cover4.jpg",
    ),
    MusicModel(
      title: "DtMF",
      artist: "Bad Bunny",
      coverImageUrl: "https://example.com/cover5.jpg",
    ),
    MusicModel(
      title: "Man I Need",
      artist: "Olivia Dean",
      coverImageUrl: "https://example.com/cover6.jpg",
    ),
    MusicModel(
      title: "Babydoll",
      artist: "Dominic Fike",
      coverImageUrl: "https://example.com/cover7.jpg",
    ),
    MusicModel(
      title: "E85",
      artist: "Don Toliver",
      coverImageUrl: "https://example.com/cover8.jpg",
    ),
    MusicModel(
      title: "So Easy (To Fall In Love)",
      artist: "Olivia Dean",
      coverImageUrl: "https://example.com/cover9.jpg",
    ),
  ];

  // English -> English
  static const Map<SheetOptionType, OptionConfig> _optionConfigs = {
    // 1. English
    SheetOptionType.constellation: OptionConfig(
      title: 'More About Me',
      hintText: 'Add more details to show your best self.',
      question: 'What is your zodiac sign?',
      options: [
        OptionItem(id: 'capricorn', title: 'capricorn'),
        OptionItem(id: 'aquarius', title: 'aquarius'),
        OptionItem(id: 'pisces', title: 'pisces'),
        OptionItem(id: 'aries', title: 'aries'),
        OptionItem(id: 'taurus', title: 'taurus'),
        OptionItem(id: 'gemini', title: 'gemini'),
        OptionItem(id: 'cancer', title: 'cancer'),
        OptionItem(id: 'leo', title: 'leo'),
        OptionItem(id: 'virgo', title: 'virgo'),
        OptionItem(id: 'libra', title: 'libra'),
        OptionItem(id: 'scorpio', title: 'scorpio'),
        OptionItem(id: 'sagittarius', title: 'sagittarius'),
      ],
    ),

    // 2. English
    SheetOptionType.education: OptionConfig(
      title: 'More About Me',
      hintText: 'Add more details to show your best self.',
      question: 'What is your education level?',
      options: [
        OptionItem(id: 'high_school', title: 'high school'),
        OptionItem(id: 'college', title: 'college'),
        OptionItem(id: 'bachelor', title: 'bachelor'),
        OptionItem(id: 'master', title: 'master'),
        OptionItem(id: 'doctor', title: 'doctor'),
        OptionItem(id: 'prefer_not_say', title: 'Prefer not to say'),
      ],
    ),

    // 3. English
    SheetOptionType.petPreference: OptionConfig(
      title: 'More About Me',
      hintText: 'Add more details to show your best self.',
      question: 'What is your pet preference?',
      options: [
        OptionItem(id: 'love_pets', title: 'love pets'),
        OptionItem(id: 'like_pets_no_keep', title: 'like pets no keep'),
        OptionItem(id: 'neutral_pets', title: 'neutral pets'),
        OptionItem(id: 'dislike_pets', title: 'dislike pets'),
        OptionItem(id: 'allergic_pets', title: 'allergic pets'),
      ],
    ),

    // 4. English
    SheetOptionType.smoking: OptionConfig(
      title: 'More About Me',
      hintText: 'Add more details to show your best self.',
      question: 'Do you smoke?',
      options: [
        OptionItem(id: 'smoke_often', title: 'Often'),
        OptionItem(id: 'smoke_sometimes', title: 'Sometimes'),
        OptionItem(id: 'smoke_never', title: 'Never'),
        OptionItem(id: 'smoke_quit', title: 'Quit smoking'),
        OptionItem(id: 'smoke_prefer_not_say', title: 'Prefer not to say'),
      ],
    ),

    // 5. English
    SheetOptionType.drinking: OptionConfig(
      title: 'More About Me',
      hintText: 'Add more details to show your best self.',
      question: 'Do you drink?',
      options: [
        OptionItem(id: 'drink_often', title: 'Often'),
        OptionItem(id: 'drink_sometimes', title: 'Socially sometimes'),
        OptionItem(id: 'drink_rarely', title: 'Rarely'),
        OptionItem(id: 'drink_never', title: 'Never'),
        OptionItem(id: 'drink_prefer_not_say', title: 'Prefer not to say'),
      ],
    ),

    // 6. English
    SheetOptionType.jobStatus: OptionConfig(
      title: 'More About Me',
      hintText: 'Add more details to show your best self.',
      question: 'What is your employment status?',
      options: [
        OptionItem(id: 'job_full_time', title: 'Full-time'),
        OptionItem(id: 'job_part_time', title: 'Part-time'),
        OptionItem(id: 'job_self_employed', title: 'Self-employed'),
        OptionItem(id: 'job_student', title: 'Student'),
        OptionItem(id: 'job_unemployed', title: 'Unemployed'),
        OptionItem(id: 'job_retired', title: 'Retired'),
        OptionItem(id: 'job_prefer_not_say', title: 'Prefer not to say'),
      ],
    ),

    // 7. English
    SheetOptionType.income: OptionConfig(
      title: 'More About Me',
      hintText: 'Add more details to show your best self.',
      question: 'What is your income level?',
      options: [
        OptionItem(id: 'income_10k_below', title: '10kText 49'),
        OptionItem(id: 'income_10k_20k', title: '10k-20k'),
        OptionItem(id: 'income_20k_30k', title: '20k-30k'),
        OptionItem(id: 'income_30k_50k', title: '30k-50k'),
        OptionItem(id: 'income_50k_100k', title: '50k-100k'),
        OptionItem(id: 'income_100k_above', title: '100kText 50'),
        OptionItem(id: 'income_prefer_not_say', title: 'Prefer not to say'),
      ],
    ),

    // 8. English
    SheetOptionType.residence: OptionConfig(
      title: 'More About Me',
      hintText: 'Add more details to show your best self.',
      question: 'What is your living situation?',
      options: [
        OptionItem(id: 'residence_own', title: 'Text 51YesText 52'),
        OptionItem(id: 'residence_rent', title: 'Text 53'),
        OptionItem(id: 'residence_with_parents', title: 'Text 54'),
        OptionItem(id: 'residence_other', title: 'Text 55'),
        OptionItem(id: 'residence_prefer_not_say', title: 'Prefer not to say'),
      ],
    ),

    // 9. English
    SheetOptionType.car: OptionConfig(
      title: 'More About Me',
      hintText: 'Add more details to show your best self.',
      question: 'Do you have a car?',
      options: [
        OptionItem(id: 'car_yes', title: 'Yes'),
        OptionItem(id: 'car_no', title: 'No'),
        OptionItem(id: 'car_planning', title: 'Planning to buy'),
        OptionItem(id: 'car_prefer_not_say', title: 'Prefer not to say'),
      ],
    ),

    // 10. English
    SheetOptionType.relationshipStatus: OptionConfig(
      title: 'More About Me',
      hintText: 'Add more details to show your best self.',
      question: 'What is your relationship status?',
      options: [
        OptionItem(id: 'relationship_single', title: 'Single'),
        OptionItem(id: 'relationship_casual', title: 'Text 56'),
        OptionItem(id: 'relationship_dating', title: 'In a relationship'),
        OptionItem(id: 'relationship_engaged', title: 'Engaged'),
        OptionItem(id: 'relationship_married', title: 'Married'),
        OptionItem(id: 'relationship_divorced', title: 'Divorced'),
        OptionItem(id: 'relationship_widowed', title: 'Widowed'),
        OptionItem(
          id: 'relationship_prefer_not_say',
          title: 'Prefer not to say',
        ),
      ],
    ),

    // 11. English
    SheetOptionType.socialMediaActivity: OptionConfig(
      title: 'Lifestyle',
      hintText: 'Add your lifestyle details to show your best self.',
      question: 'How active are you on social media?',
      options: [
        OptionItem(id: 'social_status', title: 'Social mode'),
        OptionItem(id: 'social_active', title: 'Socially active'),
        OptionItem(id: 'not_online_often', title: 'Not often online'),
        OptionItem(id: 'lurk', title: 'Lurker'),
      ],
    ),

    // 5. English (English?)
    SheetOptionType.fitness: OptionConfig(
      title: 'Lifestyle',
      hintText: 'Add your lifestyle details to show your best self.',
      question: 'Do you exercise?',
      options: [
        OptionItem(id: 'every_day', title: 'Every day'),
        OptionItem(id: 'often', title: 'Text 57'),
        OptionItem(id: 'occasionally', title: 'Sometimes'),
        OptionItem(id: 'never', title: 'Never'),
      ],
    ),

    // 6. English (English?)
    SheetOptionType.wantChildren: OptionConfig(
      title: 'More About Me',
      hintText: 'Add more details to show your best self.',
      question: 'Do you want children?',
      options: [
        OptionItem(id: 'want', title: 'Want children'),
        OptionItem(id: 'dont_want', title: 'Do not want children'),
        OptionItem(id: 'have_and_more', title: 'Have children, want more'),
        OptionItem(id: 'have_and_stop', title: 'Have children, no more'),
        OptionItem(id: 'unsure', title: 'Not sure yet'),
      ],
    ),

    // 7. English (English?)
    SheetOptionType.communicationStyle: OptionConfig(
      title: 'More About Me',
      hintText: 'Add more details to show your best self.',
      question: 'What is your communication style?',
      options: [
        OptionItem(id: 'active_msg', title: 'Active texter'),
        OptionItem(id: 'call', title: 'Prefer calls'),
        OptionItem(id: 'video_call', title: 'Prefer video chat'),
        OptionItem(id: 'not_active_msg', title: 'Not into texting'),
        OptionItem(id: 'in_person', title: 'Prefer in person'),
      ],
    ),

    // 8. English (English?)
    SheetOptionType.loveLanguage: OptionConfig(
      title: 'More About Me',
      hintText: 'Add more details to show your best self.',
      question: 'How do you feel loved?',
      options: [
        OptionItem(id: 'caring', title: 'Acts of care'),
        OptionItem(id: 'gifts', title: 'Gifts'),
        OptionItem(id: 'touch', title: 'Physical touch'),
        OptionItem(id: 'praise', title: 'Words of affirmation'),
        OptionItem(id: 'time', title: 'Quality time'),
      ],
    ),
  };

  /// English
  static OptionConfig getConfig(SheetOptionType type) {
    return _optionConfigs[type]!;
  }

  //English
  // English
  static final List<ProfileItem> moreItems = [
    ProfileItem(
      icon: Icons.nights_stay,
      label: 'Zodiac',
      value: 'Empty',
      optionType: SheetOptionType.constellation,
    ),
    ProfileItem(
      icon: Icons.school,
      label: 'Education',
      value: 'Empty',
      optionType: SheetOptionType.education,
    ),
    ProfileItem(
      icon: Icons.family_restroom,
      label: 'family restroom',
      value: 'Empty',
      optionType: SheetOptionType.wantChildren,
    ),
    ProfileItem(
      icon: Icons.chat,
      label: 'communication style',
      value: 'Empty',
      optionType: SheetOptionType.communicationStyle,
    ),
    ProfileItem(
      icon: Icons.favorite,
      label: 'Love Language',
      value: 'Empty',
      optionType: SheetOptionType.loveLanguage,
    ),
  ];

  // English
  static final List<ProfileItem> lifestyleItems = [
    ProfileItem(
      icon: Icons.pets,
      label: 'Pet Preference',
      value: 'Fish',
      optionType: SheetOptionType.petPreference,
    ),
    ProfileItem(
      icon: Icons.local_bar,
      label: 'Drinking',
      value: 'Rarely or never',
      optionType: SheetOptionType.drinking,
    ),
    ProfileItem(
      icon: Icons.smoke_free,
      label: 'How often do you smoke',
      value: 'Non-smoker',
      optionType: SheetOptionType.smoking,
    ),
    ProfileItem(
      icon: Icons.fitness_center,
      label: 'fitness status',
      value: 'Every day',
      optionType: SheetOptionType.fitness,
    ),
    ProfileItem(
      icon: Icons.alternate_email,
      label: 'Social Media Activity',
      value: 'Empty',
      optionType: SheetOptionType.socialMediaActivity,
    ),
  ];
  // English
  static final List<ProfileItem> welcomeChatItems = [
    ProfileItem(
      icon: Icons.nights_stay,
      label: 'Going Out',
      value: 'Dancing, dressing up, ...',
      optionType: SheetOptionType.goOut,
    ),
    ProfileItem(
      icon: Icons.weekend,
      label: 'My Weekend',
      value: 'Add Prompt',
      optionType: SheetOptionType.weekend,
    ),
    ProfileItem(
      icon: Icons.phone_iphone,
      label: 'Me and My Phone',
      value: 'Add Prompt',
      optionType: SheetOptionType.phoneUsage,
    ),
  ];

  /// English
  static List<UserProfileModel> getUserList() {
    var json = [
      {
        "age": 25,
        "distance": 10.0,
        "isActive": true,
        "userId": "user_001",
        "email": "alice@example.com",
        "phone": "13800138000",
        "password": "encrypted_123",
        "nikeName": "AliceText 62",
        "mediaUrls": [
          "https://example.com/photo1.jpg",
          "https://example.com/photo2.jpg",
        ],
        "smartPhotosEnabled": true,
        "aboutMe": "Text 63, Text 64",
        "chatPreference": {
          "title": "Text 65",
          "goingOut": ["Text 66", "Text 67", "Text 68"],
          "myWeekend": ["Text 69", "Text 70", "Text 71"],
          "myPhone": ["Text 72", "Text 73", "Text 74"],
        },
        "prompts": [
          {"title": "Going Out", "content": "Text 75, Text 76"},
          {"title": "Text 77", "content": "Text 78"},
        ],
        "interests": [
          {"id": "interest_001", "name": "Travel"},
          {"id": "interest_002", "name": "Food"},
          {"id": "interest_003", "name": "Photography"},
        ],
        "relationshipGoal": {"id": 1, "title": "Text 79", "emoji": "❤️"},
        "height": {
          "unit": "HeightUnit.cm",
          "cm": 165.5,
          "feet": null,
          "inch": null,
        },
        "languages": [
          {"id": "lang_001", "name": "Chinese"},
          {"id": "lang_002", "name": "English"},
        ],
        "moreInfo": {
          "zodiac": "Text 34",
          "education": "Text 40",
          "familyPlan": "3Text 80",
          "communicationStyle": "Text 81",
          "loveLanguage": "Text 82Gifts",
        },
        "lifestyle": {
          "petPreference": "Text 83",
          "drinking": "SometimesText 84",
          "smoking": "Non-smoker",
          "fitness": "Text 853Text 86",
          "socialMediaActivity": "Text 8730Text 88",
        },
        "jobTitle": "Text 89",
        "company": "Text 90",
        "school": "Text 91",
        "city": "Text 92",
        "favoriteSong": {
          "title": "Text 93",
          "artist": "Text 94",
          "coverImageUrl": "https://example.com/song1.jpg",
        },
        "spotifyArtist": "Taylor Swift",
        "gender": [
          {
            "id": "gender_001",
            "name": "Text 95",
            "desc": "Female",
            "isVisible": true,
          },
        ],
        "sexualOrientation": [
          {
            "id": "so_001",
            "name": "Heterosexual",
            "desc": "Text 96",
            "isVisible": false,
          },
        ],
        "privacySettings": {"hideAge": false, "hideDistance": true},
      },
      {
        "age": 25,
        "distance": 10.0,
        "isActive": true,
        "userId": "user_002",
        "email": "bob@example.com",
        "phone": "13900139000",
        "password": "encrypted_456",
        "nikeName": "BobText 97",
        "mediaUrls": ["https://example.com/photo3.jpg"],
        "smartPhotosEnabled": false,
        "aboutMe": "Text 98, Text 99, Text 100",
        "chatPreference": {
          "title": "Text 101",
          "goingOut": ["Text 102", "Text 103", "Text 104"],
          "myWeekend": ["Text 105", "Text 106", "Text 107"],
          "myPhone": ["Text 108", "Text 109", "Text 110"],
        },
        "prompts": [
          {"title": "Fitness", "content": "Text 1115Text 112, Text 113"},
        ],
        "interests": [
          {"id": "interest_004", "name": "Fitness"},
          {"id": "interest_005", "name": "Text 114"},
          {"id": "interest_006", "name": "Text 115"},
        ],
        "relationshipGoal": {"id": 2, "title": "Text 116", "emoji": "🏋️"},
        "height": {
          "unit": "HeightUnit.feetInch",
          "cm": null,
          "feet": 6,
          "inch": 1,
        },
        "languages": [
          {"id": "lang_001", "name": "Chinese"},
          {"id": "lang_003", "name": "Text 117"},
        ],
        "moreInfo": {
          "zodiac": "Text 28",
          "education": "Text 39",
          "familyPlan": "Text 118",
          "communicationStyle": "Text 119",
          "loveLanguage": "Text 120",
        },
        "lifestyle": {
          "petPreference": "Text 121",
          "drinking": "NeverText 122",
          "smoking": "SometimesText 123",
          "fitness": "Text 124",
          "socialMediaActivity": "Text 871Text 125",
        },
        "jobTitle": "Text 98",
        "company": "Text 126",
        "school": "Text 127",
        "city": "Text 128",
        "favoriteSong": {
          "title": "Stronger",
          "artist": "Kanye West",
          "coverImageUrl": "https://example.com/song2.jpg",
        },
        "spotifyArtist": "Eminem",
        "gender": [
          {
            "id": "gender_002",
            "name": "Text 129",
            "desc": "Male",
            "isVisible": true,
          },
        ],
        "sexualOrientation": [
          {
            "id": "so_001",
            "name": "Heterosexual",
            "desc": "Text 96",
            "isVisible": false,
          },
        ],
        "privacySettings": {"hideAge": true, "hideDistance": false},
      },
      {
        "age": 25,
        "distance": 10.0,
        "isActive": true,
        "userId": "user_003",
        "email": "charlie@example.com",
        "phone": "13700137000",
        "password": "encrypted_789",
        "nikeName": "CharlieText 130",
        "mediaUrls": [
          "https://example.com/photo4.jpg",
          "https://example.com/photo5.jpg",
          "https://example.com/photo6.jpg",
        ],
        "smartPhotosEnabled": true,
        "aboutMe": "Text 131, Part-timeText 132, Text 133",
        "chatPreference": {
          "title": "Text 134",
          "goingOut": ["Text 135", "Text 136", "Text 137"],
          "myWeekend": ["Text 138", "Text 139", "Text 140"],
          "myPhone": ["Text 141", "Text 142", "Text 143YesText 144"],
        },
        "prompts": [
          {"title": "Text 77", "content": "Text 145, Text 146"},
        ],
        "interests": [
          {"id": "interest_007", "name": "Text 139"},
          {"id": "interest_008", "name": "Text 138"},
          {"id": "interest_009", "name": "Text 147"},
        ],
        "relationshipGoal": {"id": 3, "title": "Text 148", "emoji": "📚"},
        "height": {
          "unit": "HeightUnit.cm",
          "cm": 178.0,
          "feet": null,
          "inch": null,
        },
        "languages": [
          {"id": "lang_001", "name": "Chinese"},
          {"id": "lang_004", "name": "Japanese"},
          {"id": "lang_005", "name": "Text 149"},
        ],
        "moreInfo": {
          "zodiac": "Text 33",
          "education": "Text 41",
          "familyPlan": "5Text 150",
          "communicationStyle": "Text 151",
          "loveLanguage": "Text 152",
        },
        "lifestyle": {
          "petPreference": "Text 153",
          "drinking": "SometimesText 154",
          "smoking": "Non-smoker",
          "fitness": "Text 1552Text 86",
          "socialMediaActivity": "Text 8715Text 88",
        },
        "jobTitle": "Text 156",
        "company": null,
        "school": "Text 157",
        "city": "Text 158",
        "favoriteSong": {
          "title": "Text 159",
          "artist": "Text 160",
          "coverImageUrl": "https://example.com/song3.jpg",
        },
        "spotifyArtist": "Text 161",
        "gender": [
          {
            "id": "gender_002",
            "name": "Text 129",
            "desc": "Male",
            "isVisible": true,
          },
        ],
        "sexualOrientation": [
          {
            "id": "so_002",
            "name": "Bisexual",
            "desc": "Text 162",
            "isVisible": true,
          },
        ],
        "privacySettings": {"hideAge": false, "hideDistance": false},
      },
      {
        "age": 25,
        "distance": 10.0,
        "isActive": true,
        "userId": "user_004",
        "email": "diana@example.com",
        "phone": "13600136000",
        "password": "encrypted_000",
        "nikeName": "DianaText 163",
        "mediaUrls": ["https://example.com/photo7.jpg"],
        "smartPhotosEnabled": false,
        "aboutMe": "Text 164, Text 165Yes3Text 166, Text 167",
        "chatPreference": {
          "title": "Text 168",
          "goingOut": ["Text 169", "Text 170", "Text 171"],
          "myWeekend": ["Text 172", "Text 173", "Text 174"],
          "myPhone": ["Text 175", "Text 176", "Text 177"],
        },
        "prompts": [
          {
            "title": "Pets",
            "content": "Text 178, Text 179, Text 180, Text 181",
          },
        ],
        "interests": [
          {"id": "interest_010", "name": "Text 182"},
          {"id": "interest_011", "name": "Text 183"},
          {"id": "interest_012", "name": "Text 184"},
        ],
        "relationshipGoal": {"id": 4, "title": "Text 185", "emoji": "🐱"},
        "height": {
          "unit": "HeightUnit.cm",
          "cm": 162.0,
          "feet": null,
          "inch": null,
        },
        "languages": [
          {"id": "lang_001", "name": "Chinese"},
        ],
        "moreInfo": {
          "zodiac": "Text 31",
          "education": "Text 40",
          "familyPlan": "Text 186",
          "communicationStyle": "Text 187",
          "loveLanguage": "Text 188",
        },
        "lifestyle": {
          "petPreference": "Text 189",
          "drinking": "NeverText 122",
          "smoking": "Non-smoker",
          "fitness": "SometimesText 190",
          "socialMediaActivity": "Text 872Text 125",
        },
        "jobTitle": "Text 164",
        "company": "Text 191",
        "school": "Text 192",
        "city": "Text 193",
        "favoriteSong": {
          "title": "Text 194",
          "artist": "Text 195",
          "coverImageUrl": null,
        },
        "spotifyArtist": "Text 196",
        "gender": [
          {
            "id": "gender_001",
            "name": "Text 95",
            "desc": "Female",
            "isVisible": true,
          },
        ],
        "sexualOrientation": [
          {
            "id": "so_001",
            "name": "Heterosexual",
            "desc": "Text 96",
            "isVisible": false,
          },
        ],
        "privacySettings": {"hideAge": true, "hideDistance": true},
      },
      {
        "age": 25,
        "distance": 10.0,
        "isActive": true,
        "userId": "user_005",
        "email": "eric@example.com",
        "phone": "13500135000",
        "password": "encrypted_111",
        "nikeName": "EricText 197",
        "mediaUrls": [
          "https://example.com/photo8.jpg",
          "https://example.com/photo9.jpg",
        ],
        "smartPhotosEnabled": true,
        "aboutMe": "Text 198, Text 199",
        "chatPreference": {
          "title": "Text 200",
          "goingOut": ["Text 201", "Text 202", "Text 203"],
          "myWeekend": ["Text 204", "Text 205", "Text 206"],
          "myPhone": ["Text 207", "Text 208", "Text 209"],
        },
        "prompts": [
          {"title": "Text 210", "content": "Text 211, Text 212"},
        ],
        "interests": [
          {"id": "interest_013", "name": "Coffee"},
          {"id": "interest_014", "name": "Text 213"},
          {"id": "interest_015", "name": "Text 214"},
        ],
        "relationshipGoal": {"id": 5, "title": "Text 215", "emoji": "☕"},
        "height": {
          "unit": "HeightUnit.feetInch",
          "cm": null,
          "feet": 5,
          "inch": 11,
        },
        "languages": [
          {"id": "lang_001", "name": "Chinese"},
          {"id": "lang_002", "name": "English"},
          {"id": "lang_006", "name": "Italian"},
        ],
        "moreInfo": {
          "zodiac": "Text 29",
          "education": "Text 39",
          "familyPlan": "4Text 80",
          "communicationStyle": "Text 216",
          "loveLanguage": "Text 217",
        },
        "lifestyle": {
          "petPreference": "Text 121",
          "drinking": "SometimesText 218",
          "smoking": "Non-smoker",
          "fitness": "Text 851Text 86",
          "socialMediaActivity": "Text 8740Text 88",
        },
        "jobTitle": "Text 219",
        "company": "Text 220",
        "school": "Text 221",
        "city": "Text 222",
        "favoriteSong": {
          "title": "Coffee",
          "artist": "Text 223",
          "coverImageUrl": "https://example.com/song4.jpg",
        },
        "spotifyArtist": "Text 224",
        "gender": [
          {
            "id": "gender_002",
            "name": "Text 129",
            "desc": "Male",
            "isVisible": true,
          },
        ],
        "sexualOrientation": [
          {
            "id": "so_001",
            "name": "Heterosexual",
            "desc": "Text 96",
            "isVisible": false,
          },
        ],
        "privacySettings": {"hideAge": false, "hideDistance": true},
      },
      {
        "age": 25,
        "distance": 10.0,
        "isActive": true,
        "userId": "user_006",
        "email": "fiona@example.com",
        "phone": "13400134000",
        "password": "encrypted_222",
        "nikeName": "FionaText 225",
        "mediaUrls": [
          "https://example.com/photo10.jpg",
          "https://example.com/photo11.jpg",
          "https://example.com/photo12.jpg",
        ],
        "smartPhotosEnabled": true,
        "aboutMe": "Text 226, Text 227, Text 228",
        "chatPreference": {
          "title": "Text 229",
          "goingOut": ["Text 230", "Text 231", "Text 232"],
          "myWeekend": ["Text 233", "Text 234", "Text 235"],
          "myPhone": ["Text 236", "Text 237", "Text 238"],
        },
        "prompts": [
          {"title": "Text 239", "content": "Text 240, Text 241"},
        ],
        "interests": [
          {"id": "interest_016", "name": "Oil Painting"},
          {"id": "interest_017", "name": "Text 235"},
          {"id": "interest_018", "name": "Text 242"},
        ],
        "relationshipGoal": {"id": 6, "title": "Text 243", "emoji": "🎨"},
        "height": {
          "unit": "HeightUnit.cm",
          "cm": 168.5,
          "feet": null,
          "inch": null,
        },
        "languages": [
          {"id": "lang_001", "name": "Chinese"},
          {"id": "lang_002", "name": "English"},
          {"id": "lang_007", "name": "Italian"},
        ],
        "moreInfo": {
          "zodiac": "Text 27",
          "education": "Text 40",
          "familyPlan": "Text 186",
          "communicationStyle": "Text 244",
          "loveLanguage": "Text 245Words of affirmation",
        },
        "lifestyle": {
          "petPreference": "Text 246",
          "drinking": "SometimesText 247",
          "smoking": "Non-smoker",
          "fitness": "Text 2482Text 86",
          "socialMediaActivity": "Text 8750Text 88",
        },
        "jobTitle": "Text 249",
        "company": null,
        "school": "Text 250",
        "city": "Text 251",
        "favoriteSong": {
          "title": "Text 252",
          "artist": "Text 253",
          "coverImageUrl": "https://example.com/song5.jpg",
        },
        "spotifyArtist": "Text 254",
        "gender": [
          {
            "id": "gender_001",
            "name": "Text 95",
            "desc": "Female",
            "isVisible": true,
          },
        ],
        "sexualOrientation": [
          {
            "id": "so_003",
            "name": "Text 255",
            "desc": "Text 256",
            "isVisible": true,
          },
        ],
        "privacySettings": {"hideAge": true, "hideDistance": false},
      },
      {
        "age": 25,
        "distance": 10.0,
        "isActive": true,
        "userId": "user_007",
        "email": "george@example.com",
        "phone": "13300133000",
        "password": "encrypted_333",
        "nikeName": "GeorgeText 257",
        "mediaUrls": ["https://example.com/photo13.jpg"],
        "smartPhotosEnabled": false,
        "aboutMe": "Text 258, Text 259, Text 260",
        "chatPreference": {
          "title": "Text 261",
          "goingOut": ["Text 262", "Text 263", "Text 264"],
          "myWeekend": ["Text 265", "Text 266", "Text 267"],
          "myPhone": ["Text 268", "Text 269", "Text 270"],
        },
        "prompts": [
          {"title": "Tech", "content": "Text 271, Text 272"},
        ],
        "interests": [
          {"id": "interest_019", "name": "Text 273"},
          {"id": "interest_020", "name": "Text 274"},
          {"id": "interest_021", "name": "Text 275"},
        ],
        "relationshipGoal": {"id": 7, "title": "Text 276", "emoji": "📱"},
        "height": {
          "unit": "HeightUnit.feetInch",
          "cm": null,
          "feet": 6,
          "inch": 2,
        },
        "languages": [
          {"id": "lang_001", "name": "Chinese"},
          {"id": "lang_002", "name": "English"},
          {"id": "lang_008", "name": "Text 277"},
        ],
        "moreInfo": {
          "zodiac": "Text 26",
          "education": "Text 40",
          "familyPlan": "6Text 150",
          "communicationStyle": "Text 278",
          "loveLanguage": "Text 279",
        },
        "lifestyle": {
          "petPreference": "Text 280",
          "drinking": "SometimesText 281",
          "smoking": "SometimesText 123",
          "fitness": "Text 2821Text 86",
          "socialMediaActivity": "Text 871.5Text 125",
        },
        "jobTitle": "Text 258",
        "company": "Text 191",
        "school": "Text 283",
        "city": "Text 284",
        "favoriteSong": {
          "title": "Text 285",
          "artist": "Text 286",
          "coverImageUrl": "https://example.com/song6.jpg",
        },
        "spotifyArtist": "Text 224",
        "gender": [
          {
            "id": "gender_002",
            "name": "Text 129",
            "desc": "Male",
            "isVisible": true,
          },
        ],
        "sexualOrientation": [
          {
            "id": "so_001",
            "name": "Heterosexual",
            "desc": "Text 96",
            "isVisible": false,
          },
        ],
        "privacySettings": {"hideAge": false, "hideDistance": false},
      },
      {
        "age": 25,
        "distance": 10.0,
        "isActive": true,
        "userId": "user_008",
        "email": "hannah@example.com",
        "phone": "13200132000",
        "password": "encrypted_444",
        "nikeName": "HannahText 287",
        "mediaUrls": [
          "https://example.com/photo14.jpg",
          "https://example.com/photo15.jpg",
        ],
        "smartPhotosEnabled": true,
        "aboutMe": "Text 288, Text 289, Text 290",
        "chatPreference": {
          "title": "Text 291",
          "goingOut": ["Text 292", "Text 293", "Text 294"],
          "myWeekend": ["Text 295", "Text 296", "Text 297"],
          "myPhone": ["Text 298", "Text 208", "Text 299"],
        },
        "prompts": [
          {"title": "Text 213", "content": "Text 300, Text 30190%Text 50"},
        ],
        "interests": [
          {"id": "interest_022", "name": "Text 213"},
          {"id": "interest_023", "name": "Text 302"},
          {"id": "interest_024", "name": "Text 303"},
        ],
        "relationshipGoal": {"id": 8, "title": "Text 304", "emoji": "🍰"},
        "height": {
          "unit": "HeightUnit.cm",
          "cm": 158.0,
          "feet": null,
          "inch": null,
        },
        "languages": [
          {"id": "lang_001", "name": "Chinese"},
          {"id": "lang_009", "name": "German"},
        ],
        "moreInfo": {
          "zodiac": "Text 25",
          "education": "Text 40",
          "familyPlan": "2Text 80",
          "communicationStyle": "Text 305",
          "loveLanguage": "Text 217",
        },
        "lifestyle": {
          "petPreference": "Text 306",
          "drinking": "SometimesText 307",
          "smoking": "Non-smoker",
          "fitness": "Text 3081Text 86",
          "socialMediaActivity": "Text 871Text 125",
        },
        "jobTitle": "Text 309",
        "company": "Text 310",
        "school": "Text 311",
        "city": "Text 312",
        "favoriteSong": {
          "title": "Text 313",
          "artist": "Text 224",
          "coverImageUrl": "https://example.com/song7.jpg",
        },
        "spotifyArtist": "Text 314",
        "gender": [
          {
            "id": "gender_001",
            "name": "Text 95",
            "desc": "Female",
            "isVisible": true,
          },
        ],
        "sexualOrientation": [
          {
            "id": "so_001",
            "name": "Heterosexual",
            "desc": "Text 96",
            "isVisible": false,
          },
        ],
        "privacySettings": {"hideAge": true, "hideDistance": true},
      },
      {
        "age": 25,
        "distance": 10.0,
        "isActive": true,
        "userId": "user_009",
        "email": "ian@example.com",
        "phone": "13100131000",
        "password": "encrypted_555",
        "nikeName": "IanText 315",
        "mediaUrls": [
          "https://example.com/photo16.jpg",
          "https://example.com/photo17.jpg",
          "https://example.com/photo18.jpg",
        ],
        "smartPhotosEnabled": false,
        "aboutMe": "Text 316, Text 317, Lurker, Text 318",
        "chatPreference": {
          "title": "Text 319",
          "goingOut": ["Text 320", "Lurker", "Text 321"],
          "myWeekend": ["Text 106", "Text 322", "Text 323"],
          "myPhone": ["Text 324", "Text 325", "Text 326"],
        },
        "prompts": [
          {
            "title": "Text 327",
            "content":
                "Text 3285Text 3295000Text 330, LurkerText 331AOWText 332",
          },
        ],
        "interests": [
          {"id": "interest_025", "name": "Text 320"},
          {"id": "interest_026", "name": "Lurker"},
          {"id": "interest_027", "name": "Text 321"},
        ],
        "relationshipGoal": {"id": 9, "title": "Text 333", "emoji": "⛰️"},
        "height": {
          "unit": "HeightUnit.feetInch",
          "cm": null,
          "feet": 6,
          "inch": 3,
        },
        "languages": [
          {"id": "lang_001", "name": "Chinese"},
          {"id": "lang_002", "name": "English"},
          {"id": "lang_010", "name": "Text 334"},
        ],
        "moreInfo": {
          "zodiac": "Text 36",
          "education": "Text 40",
          "familyPlan": "Text 118",
          "communicationStyle": "Text 335",
          "loveLanguage": "Text 336",
        },
        "lifestyle": {
          "petPreference": "Text 337",
          "drinking": "SometimesText 338",
          "smoking": "SometimesText 123",
          "fitness": "Text 339",
          "socialMediaActivity": "Text 8730Text 88",
        },
        "jobTitle": "Text 340",
        "company": "Text 341",
        "school": "Text 342",
        "city": "Text 343",
        "favoriteSong": {
          "title": "Text 344",
          "artist": "Text 345",
          "coverImageUrl": "https://example.com/song8.jpg",
        },
        "spotifyArtist": "Text 345",
        "gender": [
          {
            "id": "gender_002",
            "name": "Text 129",
            "desc": "Male",
            "isVisible": true,
          },
        ],
        "sexualOrientation": [
          {
            "id": "so_002",
            "name": "Bisexual",
            "desc": "Text 162",
            "isVisible": true,
          },
        ],
        "privacySettings": {"hideAge": false, "hideDistance": true},
      },
      {
        "age": 25,
        "distance": 10.0,
        "isActive": true,
        "userId": "user_010",
        "email": "julia@example.com",
        "phone": "13000130000",
        "password": "encrypted_666",
        "nikeName": "JuliaText 346",
        "mediaUrls": ["https://example.com/photo19.jpg"],
        "smartPhotosEnabled": true,
        "aboutMe": "Text 347, Text 348, Text 349",
        "chatPreference": {
          "title": "Text 350",
          "goingOut": ["Text 351", "Text 352", "Text 353"],
          "myWeekend": ["Text 354", "Meditation", "Text 355"],
          "myPhone": ["Text 356", "Text 357", "Text 358"],
        },
        "prompts": [
          {"title": "Yoga", "content": "Text 359YesRYT500Text 360, Text 361"},
        ],
        "interests": [
          {"id": "interest_028", "name": "Yoga"},
          {"id": "interest_029", "name": "Meditation"},
          {"id": "interest_030", "name": "Text 362"},
        ],
        "relationshipGoal": {"id": 10, "title": "Text 363", "emoji": "🧘"},
        "height": {
          "unit": "HeightUnit.cm",
          "cm": 170.0,
          "feet": null,
          "inch": null,
        },
        "languages": [
          {"id": "lang_001", "name": "Chinese"},
          {"id": "lang_002", "name": "English"},
          {"id": "lang_011", "name": "Hindi"},
        ],
        "moreInfo": {
          "zodiac": "Text 35",
          "education": "Text 41",
          "familyPlan": "3Text 150",
          "communicationStyle": "Text 364YesText 365",
          "loveLanguage": "Text 366",
        },
        "lifestyle": {
          "petPreference": "Text 367",
          "drinking": "NeverText 122",
          "smoking": "Non-smoker",
          "fitness": "Text 368",
          "socialMediaActivity": "Text 8720Text 88",
        },
        "jobTitle": "Text 369",
        "company": "lululemonText 370",
        "school": "Text 371",
        "city": "Text 372",
        "favoriteSong": {
          "title": "Text 373",
          "artist": "Text 374",
          "coverImageUrl": "https://example.com/song9.jpg",
        },
        "spotifyArtist": "Text 375",
        "gender": [
          {
            "id": "gender_001",
            "name": "Text 95",
            "desc": "Female",
            "isVisible": true,
          },
        ],
        "sexualOrientation": [
          {
            "id": "so_001",
            "name": "Heterosexual",
            "desc": "Text 96",
            "isVisible": false,
          },
        ],
        "privacySettings": {"hideAge": true, "hideDistance": false},
      },
    ];

    final random = math.Random();
    final imagePool = List<String>.generate(19, (i) => 'assets/user/$i.png');

    List<UserProfileModel> userList = json.map((userData) {
      return UserProfileModel.fromJson(userData);
    }).toList();
    for (final user in userList) {
      final perUserPool = List<String>.from(imagePool)..shuffle(random);
      final count = 3 + random.nextInt(3);
      user.mediaUrls
        ..clear()
        ..addAll(perUserPool.take(count));
    }
    return userList;
  }

  /// English
  static List<UserProfileModel> getUserListBySearchType(
    String searchType, {
    int count = 12,
  }) {
    final random = math.Random();
    final all = getUserList();
    final filtered = all.where((user) {
      final type = searchType.toLowerCase();
      final relationship = (user.relationshipGoal?.title ?? '').toLowerCase();
      final about = user.aboutMe.toLowerCase();
      final interests = user.interests
          .map((e) => e.name.toLowerCase())
          .join(' ');
      final lifestyle =
          '${user.lifestyle.fitness} ${user.lifestyle.drinking} ${user.lifestyle.petPreference}'
              .toLowerCase();

      if (type.contains('Long-term')) {
        return relationship.contains('Partner') ||
            relationship.contains('Soul') ||
            about.contains('Long-term');
      }
      if (type.contains('Short-term')) {
        return relationship.contains('New friends') ||
            relationship.contains('Companion') ||
            about.contains('Text 376');
      }
      if (type.contains('Friends')) {
        return relationship.contains('Friends') || about.contains('Friends');
      }
      if (type.contains('Travel') || type.contains('Nature')) {
        return interests.contains('Travel') ||
            interests.contains('Text 327') ||
            about.contains('Travel');
      }
      if (type.contains('Sports') || type.contains('Fitness')) {
        return interests.contains('Fitness') ||
            interests.contains('Text 114') ||
            lifestyle.contains('Fitness');
      }
      if (type.contains('Music')) {
        return interests.contains('Music') ||
            (user.favoriteSong?.title.isNotEmpty ?? false);
      }
      if (type.contains('Food') || type.contains('Coffee')) {
        return interests.contains('Food') ||
            about.contains('Coffee') ||
            about.contains('Text 213');
      }
      if (type.contains('Gaming')) {
        return interests.contains('Gaming') || interests.contains('Tech');
      }
      if (type.contains('Pets')) {
        return lifestyle.contains('Cat') ||
            lifestyle.contains('Dog') ||
            lifestyle.contains('Text 377');
      }
      if (type.contains('Creative')) {
        return interests.contains('Photography') ||
            about.contains('Oil Painting') ||
            about.contains('Writer');
      }
      if (type.contains('Self-care')) {
        return interests.contains('Meditation') ||
            interests.contains('Yoga') ||
            about.contains('Love life');
      }
      return true;
    }).toList();

    final base = filtered.isEmpty ? all : filtered;
    base.shuffle(random);
    final selected = <UserProfileModel>[];
    for (var i = 0; i < count; i++) {
      final source = base[i % base.length];
      final raw = Map<String, dynamic>.from(source.toJson());
      raw['userId'] = '${source.userId}_${searchType}_$i';
      raw['distance'] = (1 + random.nextInt(30)).toDouble();
      raw['age'] = 18 + random.nextInt(14);
      selected.add(UserProfileModel.fromJson(raw));
    }
    return selected;
  }

  /// English(English)
  static Future<List<UserProfileModel>> getUserlike() async {
    final activeUser = await UserAuthLocalDb.instance.getActiveUser();
    final activeUserId = activeUser?.userId ?? 'guest';
    return HomeSwipeLocalDb.instance.getLikedUsers(activeUserId);
  }
}

class ProfileItem {
  /// English
  final IconData icon;

  /// English
  final String label;

  /// English
  final String value;

  /// English(English, English)
  final SheetOptionType optionType;

  const ProfileItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.optionType,
  });
}
