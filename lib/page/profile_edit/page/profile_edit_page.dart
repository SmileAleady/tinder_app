import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({Key? key}) : super(key: key);

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<String?> photos = [null, null, null, null, null, null, null, null, null];
  bool smartPhotoEnabled = true;
  String? selectedPrompt;
  String? selectedInterest;
  String? relationshipGoal = '寻找长期的伴侣';
  String? height;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
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
          const SizedBox(height: 16),
          // Photo options link
          GestureDetector(
            onTap: () {},
            child: const Text(
              '照片选项',
              style: TextStyle(fontSize: 13, color: Colors.grey),
            ),
          ),
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
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!, width: 1),
                ),
                child: photos[index] != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.file(
                          File(photos[index]!),
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.error),
                            );
                          },
                        ),
                      )
                    : Center(
                        child: Icon(
                          Icons.add,
                          size: 32,
                          color: Colors.grey[400],
                        ),
                      ),
              ),
              if (photos[index] != null)
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        photos[index] = null;
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
    if (photos[index] != null) {
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
          photos[index] = localPath;
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
          photos[index] = localPath;
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

  Widget _buildPhotoOptionsSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '照片选项',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '智能照片',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

          const SizedBox(height: 4),
          const Text(
            '智能照片会一直测试你的所有个人资料照片，以找到最棒的一张。',
            style: TextStyle(fontSize: 12, color: Colors.grey),
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
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: TextField(
              decoration: const InputDecoration(
                hintText: '输入关于自己的内容',
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              maxLines: 4,
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Text(
                '选择一条提示',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              const Text(
                '+10%',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          const Text(
            '"关于我"的快速提示',
            style: TextStyle(fontSize: 12, color: Color(0xFF1E90FF)),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey[300]!),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '选择一条提示',
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
          const SizedBox(height: 12),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    selectedPrompt = null;
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text('回答提示', style: TextStyle(fontSize: 12)),
                ),
              ),
            ],
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '添加兴趣',
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
        ],
      ),
    );
  }

  Widget _buildRelationshipGoalSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '交往目标',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          // Looking for goal
          GestureDetector(
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  '我想要',
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
          const SizedBox(height: 12),
          // Goal description
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              const Icon(Icons.favorite, color: Colors.red, size: 16),
              const SizedBox(width: 8),
              const Text(
                '寻找长期的伴侣',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
              const Spacer(),
              GestureDetector(
                onTap: () {},
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeightSection() {
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
            onTap: () {},
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  height ?? '添加身高',
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
        ],
      ),
    );
  }

  Widget _buildPreviewTab() {
    return const Center(child: Text('预览内容'));
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
