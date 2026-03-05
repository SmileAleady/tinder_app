import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tinder_app/model/user_profile_model.dart';
import 'package:tinder_app/page/profile_edit/widget/profile_about_me_list_page.dart';
import 'dart:io';

import 'package:tinder_app/page/profile_edit/widget/profile_about_me_sheet.dart';
import 'package:tinder_app/page/profile_edit/widget/profile_dashed_border_container.dart';
import 'package:tinder_app/page/profile_edit/widget/profile_height_edit_sheet.dart';

import 'package:tinder_app/page/profile_edit/widget/profile_relationship_goal_sheet.dart';
import 'package:tinder_app/tool/event_bus.dart';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({Key? key}) : super(key: key);

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  // List<String?> photos = [];
  bool smartPhotoEnabled = true;
  String? selectedPrompt;
  String? selectedInterest;
  String? relationshipGoal = '寻找长期的伴侣';
  String? height;
  List<String> languages = ['English', '中文', '日本語'];
  UserProfileModel? userProfileModel;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    userProfileModel = getUserProfileModel();

    // 监听事件
    eventBus.on<PromptAnswerEvent>().listen((event) {
      print('选择的提示: ${event.model.title}');
      print('回答内容: ${event.model.content}');
      setState(() {
        // 根据需要处理文本，这里示例放到 aboutMe
        userProfileModel?.prompts.add(event.model);
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Container(
            color: const Color.fromARGB(255, 150, 150, 150).withOpacity(0.1),
            child: Column(
              children: [
                // Header with back button and tabs
                _buildHeader(),
                // Tab content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [_buildEditTab(), _buildPreviewTab()],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        // Title and back button
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back,
                  color: Colors.red,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                '编辑个人资料',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ],
          ),
        ),
        // Tab bar
        UnderlineTabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: '编辑'),
            Tab(text: '预览'),
          ],
        ),
      ],
    );
  }

  Widget _buildEditTab() {
    final moreItems = [
      {'icon': Icons.nights_stay, 'label': '星座', 'value': '空'},
      {'icon': Icons.school, 'label': '教育情况', 'value': '空'},
      {'icon': Icons.family_restroom, 'label': '家庭计划', 'value': '空'},
      {'icon': Icons.chat, 'label': '沟通风格', 'value': '空'},
      {'icon': Icons.favorite, 'label': '爱的方式', 'value': '空'},
    ];

    final lifestyleItems = [
      {'icon': Icons.pets, 'label': '宠物喜好', 'value': '鱼类'},
      {'icon': Icons.local_bar, 'label': '饮酒', 'value': '少喝或不喝'},
      {'icon': Icons.smoke_free, 'label': '你多久抽一次烟?', 'value': '不吸烟'},
      {'icon': Icons.fitness_center, 'label': '健身情况', 'value': '每天'},
      {'icon': Icons.alternate_email, 'label': '社交媒体活跃度', 'value': '空'},
    ];

    final welcomeChatItems = [
      {'icon': Icons.nights_stay, 'label': '外出', 'value': '正在跳舞, 盛装打扮, ...'},
      {'icon': Icons.weekend, 'label': '我的周末', 'value': '添加问答'},
      {'icon': Icons.phone_iphone, 'label': '我和我的手机', 'value': '添加问答'},
    ];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Media Section
          _buildMediaSection(),
          const SizedBox(height: 24),
          // Photo Options Section
          _buildPhotoOptionsSection(),
          const SizedBox(height: 24),
          // About Me Section
          _buildAboutMeSection(),
          const SizedBox(height: 24),

          // Prompt Section
          _buildPromptSection(),
          if (userProfileModel != null)
            ...userProfileModel!.prompts.map((prompt) {
              int index = userProfileModel!.prompts.indexOf(prompt);
              return _buildPromptSelected(index);
            }),

          if (userProfileModel != null &&
              (userProfileModel?.prompts.isEmpty == true ||
                  userProfileModel!.prompts.length < 3))
            _buildPromptNone(),
          const SizedBox(height: 24),
          // Interests Section
          _buildInterestsSection(),
          const SizedBox(height: 24),
          // Relationship Goal Section
          _buildRelationshipGoalSection(),
          const SizedBox(height: 24),
          // Height Section
          _buildHeightSection(),
          const SizedBox(height: 32),
          _buildLanguageSection(),
          const SizedBox(height: 32),
          // 新增的“我的更多信息”和“生活方式”
          _buildListInfoSection(title: '我的更多信息', items: moreItems),
          const SizedBox(height: 24),
          _buildListInfoSection(title: '生活方式', items: lifestyleItems),
          const SizedBox(height: 32),
          _buildListInfoSection(title: '欢迎跟我聊天', items: welcomeChatItems),
          const SizedBox(height: 32),
          _buildWorkEducationSection(),
          const SizedBox(height: 32),
          _buildMusicSection(),
          const SizedBox(height: 32),
          _buildSpotifySection(),
          const SizedBox(height: 32),
          _buildGenderSection(),
          const SizedBox(height: 32),
          _buildOrientationSection(),
          const SizedBox(height: 32),
          _buildManageProfileSection(),
          const SizedBox(height: 32),
          _buildPrivacySection(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildMediaSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with badge and percentage
          SizedBox(height: 12),
          Row(
            children: [
              const Text(
                '媒体',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 4),
              Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                child: const Text(
                  '立即添加',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              const Text(
                '+21%',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Media label and description
          const SizedBox(height: 8),
          const Text(
            '最多上传9张照片。添加照片配文，彰显你的个性。',
            style: TextStyle(fontSize: 13, color: Colors.grey),
          ),
          const SizedBox(height: 8),
          const Text(
            '查看如何选择照片，助你脱颖而出',
            style: TextStyle(fontSize: 13, color: Color(0xFF1E90FF)),
          ),
          const SizedBox(height: 16),
          // Photo grid
          _buildPhotoGrid(),
        ],
      ),
    );
  }

  Widget _buildPhotoGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.85,
      ),
      itemCount: 9,
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: () => _handlePhotoTap(index),
          child: Stack(
            children: [
              if (userProfileModel == null ||
                  (userProfileModel != null &&
                      userProfileModel!.mediaUrls.length <= index))
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 4, 4, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey[300]!, width: 1),
                    ),
                    child: Center(
                      child: Icon(Icons.add, size: 32, color: Colors.grey[400]),
                    ),
                  ),
                ),

              if (userProfileModel != null &&
                  userProfileModel!.mediaUrls.length > index &&
                  userProfileModel!.mediaUrls[index] != null)
                Container(
                  padding: EdgeInsets.fromLTRB(0, 4, 4, 0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    // clipBehavior: Clip.hardEdge, // 显式指定裁切行为（关键）
                    child: Image.file(
                      File(userProfileModel!.mediaUrls[index]!),
                      width: double.infinity,
                      height: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: const Icon(Icons.error),
                        );
                      },
                    ),
                  ),
                ),

              if (userProfileModel != null &&
                  userProfileModel!.mediaUrls.length > index &&
                  userProfileModel!.mediaUrls[index] != null)
                Positioned(
                  top: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        userProfileModel!.mediaUrls.removeAt(index);
                      });
                    },
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _handlePhotoTap(int index) {
    // 如果已有图片，则不处理点击
    if (userProfileModel != null &&
        userProfileModel!.mediaUrls.length > index &&
        userProfileModel!.mediaUrls[index] != null) {
      return;
    }
    // 弹出底部选择框
    _showPhotoPickerBottomSheet(index);
  }

  void _showPhotoPickerBottomSheet(int index) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
              margin: const EdgeInsets.only(bottom: 20),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.red),
              title: const Text('从相册中选择'),
              onTap: () {
                Navigator.pop(context);
                _pickPhotoFromGallery(index);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt, color: Colors.red),
              title: const Text('拍摄图片'),
              onTap: () {
                Navigator.pop(context);
                _pickPhotoFromCamera(index);
              },
            ),
            const SizedBox(height: 8),
            ListTile(
              title: const Text(
                '取消',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickPhotoFromGallery(int index) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final String localPath = await _saveImageLocally(image.path);
        setState(() {
          userProfileModel!.mediaUrls.add(localPath);
        });
      }
    } catch (e) {
      debugPrint('相册选择失败: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('选择图片失败，请重试')));
      }
    }
  }

  Future<void> _pickPhotoFromCamera(int index) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.camera);
      if (image != null) {
        final String localPath = await _saveImageLocally(image.path);
        setState(() {
          userProfileModel!.mediaUrls.add(localPath);
        });
      }
    } catch (e) {
      debugPrint('拍摄图片失败: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('拍摄图片失败，请重试')));
      }
    }
  }

  Future<String> _saveImageLocally(String imagePath) async {
    try {
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String photoDir = '${appDir.path}/photos';
      final Directory photoDirectory = Directory(photoDir);

      // 创建 photos 目录（如果不存在）
      if (!await photoDirectory.exists()) {
        await photoDirectory.create(recursive: true);
      }

      // 生成唯一的文件名
      final String fileName =
          'photo_${DateTime.now().millisecondsSinceEpoch}.jpg';
      final String newPath = '$photoDir/$fileName';

      // 复制文件到本地目录
      final File sourceFile = File(imagePath);
      await sourceFile.copy(newPath);

      return newPath;
    } catch (e) {
      debugPrint('保存图片失败: $e');
      rethrow;
    }
  }

  Widget _buildListInfoSection({
    required String title,
    required List<dynamic> items,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          ...items.map((item) {
            int index = items.indexOf(item);
            return Column(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Container(
                    height: 60,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white, // 浅灰色背景
                      borderRadius: index == 0
                          ? BorderRadius.only(
                              topLeft: Radius.circular(8),
                              topRight: Radius.circular(8),
                              bottomLeft: Radius.circular(4),
                              bottomRight: Radius.circular(4),
                            )
                          : index == items.length - 1
                          ? BorderRadius.only(
                              topLeft: Radius.circular(4),
                              topRight: Radius.circular(4),
                              bottomLeft: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            )
                          : BorderRadius.circular(4), // 圆角
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          item['icon'] as IconData,
                          color: Colors.grey,
                          size: 20,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          item['label'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          item['value'] as String,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 14,
                          color: Colors.grey[400],
                        ),
                      ],
                    ),
                  ),
                ),
                if (index < items.length - 1)
                  Divider(height: 2, color: Colors.transparent),
              ],
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildWorkEducationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSingleFieldSection('职位', '添加职位', important: true, percent: '+4%'),
        const SizedBox(height: 24),
        _buildSingleFieldSection('公司', '添加公司', percent: '+2%'),
        const SizedBox(height: 24),
        _buildSingleFieldSection('学校', '添加学校', percent: '+4%'),
        const SizedBox(height: 24),
        _buildSingleFieldSection('居住地', '添加城市'),
      ],
    );
  }

  Widget _buildPhotoOptionsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '照片选项',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white, // 浅灰色背景
              borderRadius: BorderRadius.circular(8), // 圆角
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '智能照片',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey,
                  ),
                ),
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: smartPhotoEnabled,
                    onChanged: (value) {
                      setState(() {
                        smartPhotoEnabled = value;
                      });
                    },
                    activeColor: Colors.red,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 4),
          const Text(
            '智能照片会一直测试你的所有个人资料\n照片，以找到最棒的一张。',
            style: TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleFieldSection(
    String title,
    String placeholder, {
    bool important = false,
    String percent = '',
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              if (important)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  child: const Text(
                    '重要',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              const Spacer(),
              if (percent.isNotEmpty)
                Text(
                  percent,
                  style: const TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white, // 浅灰色背景
              borderRadius: BorderRadius.circular(8), // 圆角
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: placeholder,
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAboutMeSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                '关于我',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: const Text(
                  '重要',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Spacer(),
              const Text(
                '+20%',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white, // 浅灰色背景
              borderRadius: BorderRadius.circular(8), // 圆角
            ),
            child: TextField(
              decoration: const InputDecoration(
                hintText: '输入关于自己的内容',
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              onChanged: (value) {
                setState(() {
                  userProfileModel?.aboutMe = value;
                });
              },
              // maxLines: 4,
              maxLength: 500,
              buildCounter:
                  (
                    context, {
                    required currentLength,
                    required isFocused,
                    maxLength,
                  }) {
                    return Text(
                      '$currentLength/$maxLength',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    );
                  },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromptSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 0, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 顶部标题
          InkWell(
            onTap: () {
              // 处理点击事件
              _buildAboutSheet();
            },
            child: const Text(
              '“关于我”的快速提示',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // 第一行：关于我 + +10%
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Text(
                      '• ',
                      style: TextStyle(fontSize: 18, color: Colors.red),
                    ),
                    Text(
                      '关于我',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Text(
                  '+10%',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromptNone() {
    return // 列表项容器（带虚线边框）
    Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 20, 0),
      child: Stack(
        children: [
          // _buildPromptNone(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(0, 16, 10, 16),
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1,
                style: BorderStyle.none,
              ),
            ),
            child: Stack(
              children: [
                // 虚线边框
                Positioned.fill(
                  child: ProfileDashedBorderContainer(
                    width: double.infinity,
                    borderRadius: 8, // 自定义圆角
                    borderColor: Colors.grey, // 虚线颜色
                    borderWidth: 1, // 虚线粗细
                    dashWidth: 5, // 虚线段长度
                    dashSpace: 3, // 虚线间隔
                  ),
                ),
                // 列表内容
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // 第二行：选择一条提示
                      const Text(
                        '选择一条提示',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),

                      // 第三行：回答提示
                      const Text(
                        '回答提示',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 右侧红色加号按钮
          Positioned(
            top: 0,
            right: 0,
            child: InkWell(
              onTap: () async {
                // Handle tap event
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileAboutMeListPage(),
                  ),
                );
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromptSelected(int index) {
    final prompt = userProfileModel!.prompts[index];
    return // 列表项容器（带虚线边框）
    Container(
      padding: const EdgeInsets.fromLTRB(16, 10, 20, 0),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(0, 16, 10, 16),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white, // 浅灰色背景
                borderRadius: BorderRadius.circular(8), // 圆角
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 标题行：红色双引号 + 标题文字
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        '“',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          height: 1.2, // 调整行高，让引号和文字对齐
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          prompt.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // 副标题
                  Text(
                    prompt.content ?? "暂无回答",
                    style: const TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),

          // 右侧红色加号按钮
          Positioned(
            top: 0,
            right: 0,
            child: InkWell(
              onTap: () {
                setState(() {
                  // 删除已选择的提示
                  if (userProfileModel!.prompts.isNotEmpty &&
                      index < userProfileModel!.prompts.length) {
                    userProfileModel!.prompts.removeAt(index);
                  }
                });
              },
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  // shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey, width: 1.5),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(Icons.close, color: Colors.grey, size: 24),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInterestsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                '兴趣',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              const Text(
                '+5%',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white, // 浅灰色背景
                borderRadius: BorderRadius.circular(8), // 圆角
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    (userProfileModel != null &&
                            userProfileModel!.interests.isNotEmpty)
                        ? userProfileModel!.interests.join(', ')
                        : '添加兴趣',
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRelationshipGoalSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            '交往目标',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          // Looking for goal
          GestureDetector(
            onTap: () {
              ProfileRelationshipGoalSheet.show(
                context,
                selectedItem: userProfileModel?.relationshipGoal, // 回显已选中的项
                onItemSelected: (item) {
                  // 选中回调，更新状态
                  setState(() {
                    if (userProfileModel != null) {
                      userProfileModel!.relationshipGoal = item;
                    }
                  });
                  // 选中后关闭弹窗（可根据需求移除，保留弹窗）
                  Navigator.pop(context);
                },
              );
            },
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white, // 浅灰色背景
                borderRadius: BorderRadius.circular(8), // 圆角
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    '我想要',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Expanded(child: SizedBox()),

                  Text(
                    textAlign: TextAlign.right,
                    (userProfileModel != null &&
                            userProfileModel!.relationshipGoal != null)
                        ? '${userProfileModel!.relationshipGoal!.emoji} ${userProfileModel!.relationshipGoal!.title}'
                        : '寻找长期的伴侣',
                    style: const TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(width: 8),

                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeightSection() {
    // 拼接展示文案
    String showHeightText = '';
    if (userProfileModel?.height?.unit == HeightUnit.cm) {
      showHeightText =
          (userProfileModel?.height?.cm != null &&
              userProfileModel?.height?.cm != 0)
          ? '${userProfileModel?.height?.cm ?? 0} cm'
          : '未设置身高';
    } else {
      showHeightText =
          (userProfileModel?.height?.feet != null &&
              userProfileModel?.height?.inch != null)
          ? '${userProfileModel?.height?.feet} 英尺 ${userProfileModel?.height?.inch} 英寸'
          : '未设置身高';
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '身高',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {
              // 一键唤起身高编辑弹窗
              ProfileHeightEditSheet.show(
                context,
                // 回显已保存的数值
                initialUnit: userProfileModel?.height?.unit,
                initialCm: userProfileModel?.height?.cm,
                initialFeet: userProfileModel?.height?.feet,
                initialInch: userProfileModel?.height?.inch,
                // 完成按钮回调
                onCompleted: (height) {
                  setState(() {
                    userProfileModel?.height = height;
                  });
                },

                // 删除按钮回调
                onDelete: () {
                  setState(() {
                    userProfileModel?.height?.unit = HeightUnit.feetInch;
                    userProfileModel?.height?.cm = null;
                    userProfileModel?.height?.feet = null;
                    userProfileModel?.height?.inch = null;
                  });
                },
              );
            },
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white, // 浅灰色背景
                borderRadius: BorderRadius.circular(8), // 圆角
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    showHeightText,
                    style: TextStyle(
                      fontSize: 14,
                      color: height != null ? Colors.black : Colors.grey,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '我会的语言',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white, // 浅灰色背景
                borderRadius: BorderRadius.circular(8), // 圆角
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    userProfileModel != null &&
                            userProfileModel!.languages.isNotEmpty
                        ? userProfileModel!.languages.join(', ')
                        : '添加语言',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMusicSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '我的最爱歌曲',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {},
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white, // 浅灰色背景
                borderRadius: BorderRadius.circular(8), // 圆角
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1DB954),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Center(
                      child: Text(
                        'S',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'PinkPantheress',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const Text(
                          'Stateside + Zara Larsson',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSpotifySection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '我最喜欢的 Spotify 艺术家',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white, // 浅灰色背景
              borderRadius: BorderRadius.circular(8), // 圆角
            ),
            child: const TextField(
              decoration: InputDecoration(
                hintText: '添加艺术家',
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              maxLines: 1,
            ),
          ),
          const SizedBox(height: 8),
          RichText(
            text: const TextSpan(
              children: [
                TextSpan(
                  text: '将 Spotify 添加进你的个人资料',
                  style: TextStyle(fontSize: 12, color: Colors.red),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '性别',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white, // 浅灰色背景
                borderRadius: BorderRadius.circular(8), // 圆角
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '男性',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  Row(
                    children: [
                      const Text(
                        '可见',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrientationSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '性取向',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () {},
            child: Container(
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white, // 浅灰色背景
                borderRadius: BorderRadius.circular(8), // 圆角
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    '异性恫',
                    style: TextStyle(fontSize: 14, color: Colors.black),
                  ),
                  Row(
                    children: [
                      const Text(
                        '隐藏',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(width: 8),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 14,
                        color: Colors.grey[400],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildManageProfileSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                '管理您的个人资料',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              Container(
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: const Text(
                  'Tinder Plus®',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPrivacySection() {
    bool hideAge = false;
    bool hideDistance = false;

    return StatefulBuilder(
      builder: (context, setState) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white, // 浅灰色背景
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                    bottomLeft: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ), // 圆角
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '不要显示我的年龄',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: hideAge,
                        onChanged: (value) {
                          setState(() {
                            hideAge = value;
                          });
                        },
                        activeColor: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 1.5),
              Container(
                height: 60,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: Colors.white, // 浅灰色背景
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4),
                    topRight: Radius.circular(4),
                    bottomLeft: Radius.circular(8),
                    bottomRight: Radius.circular(8),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '不显示我的距离',
                      style: TextStyle(fontSize: 14, color: Colors.black),
                    ),
                    Transform.scale(
                      scale: 0.8,
                      child: Switch(
                        value: hideDistance,
                        onChanged: (value) {
                          setState(() {
                            hideDistance = value;
                          });
                        },
                        activeColor: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPreviewTab() {
    return const Center(child: Text('预览内容'));
  }

  _buildAboutSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => const ProfileAboutMeSheet(),
    );
  }
}

class UnderlineTabBar extends StatelessWidget {
  final TabController controller;
  final List<Widget> tabs;

  const UnderlineTabBar({
    Key? key,
    required this.controller,
    required this.tabs,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
      ),
      child: TabBar(
        controller: controller,
        tabs: tabs,
        indicatorColor: Colors.red,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.grey,
        indicatorWeight: 3,
      ),
    );
  }
}

// 自定义虚线边框绘制器
class DashedBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.grey
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const dashWidth = 5;
    const dashSpace = 3;
    double startX = 0;
    final path = Path();

    // 绘制顶部边框
    while (startX < size.width) {
      path.moveTo(startX, 0);
      path.lineTo(startX + dashWidth, 0);
      startX += dashWidth + dashSpace;
    }

    // 绘制右侧边框
    double startY = 0;
    while (startY < size.height) {
      path.moveTo(size.width, startY);
      path.lineTo(size.width, startY + dashWidth);
      startY += dashWidth + dashSpace;
    }

    // 绘制底部边框
    startX = 0;
    while (startX < size.width) {
      path.moveTo(startX, size.height);
      path.lineTo(startX + dashWidth, size.height);
      startX += dashWidth + dashSpace;
    }

    // 绘制左侧边框
    startY = 0;
    while (startY < size.height) {
      path.moveTo(0, startY);
      path.lineTo(0, startY + dashWidth);
      startY += dashWidth + dashSpace;
    }

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
