// 第二步：轮播页面实现
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tinder_app/model/user_profile_model.dart';
import 'package:tinder_app/widget/user_page.dart';

class ProfilePreviewWidget extends StatefulWidget {
  final UserProfileModel userProfile;
  const ProfilePreviewWidget({super.key, required this.userProfile});

  @override
  State<ProfilePreviewWidget> createState() => _ProfilePreviewWidgetState();
}

class _ProfilePreviewWidgetState extends State<ProfilePreviewWidget> {
  late UserProfileModel _userProfile;
  late PageController _pageController;
  int _currentPage = 0; // 当前显示的图片索引

  @override
  void initState() {
    super.initState();
    // 初始化数据模型
    _userProfile = widget.userProfile;
    // 初始化PageController，用于控制页面切换
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    // 释放资源
    _pageController.dispose();
    super.dispose();
  }

  // 点击切换图片（核心逻辑：循环切换）
  void _onImageTap() {
    setState(() {
      // 计算下一页索引：最后一页则回到第一页，否则+1
      _currentPage = (_currentPage + 1) % (_userProfile.mediaUrls?.length ?? 0);
      // 平滑切换到下一页
      _pageController.animateToPage(
        _currentPage,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // 图片轮播主体（占满剩余空间）
            Positioned.fill(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _userProfile.mediaUrls?.length ?? 0,
                onPageChanged: (index) {
                  // 页面切换时更新指示器状态
                  setState(() => _currentPage = index);
                },
                itemBuilder: (context, index) {
                  String? imageUrl = _userProfile.mediaUrls?[index] ?? "";
                  return GestureDetector(
                    // 点击图片触发切换
                    onTap: _onImageTap,
                    child:
                        // Container(
                        //   width: double.infinity,
                        //   height: double.infinity,
                        //   decoration: BoxDecoration(
                        //     image: DecorationImage(
                        //       image: NetworkImage(imageUrl),
                        //       fit: BoxFit.cover, // 适配屏幕
                        //     ),
                        //   ),
                        //   // 底部文字叠加层（可选，根据设计调整）
                        //   child: Align(
                        //     alignment: Alignment.bottomLeft,
                        //     child: Padding(
                        //       padding: const EdgeInsets.all(20),
                        //       child: Column(
                        //         mainAxisSize: MainAxisSize.min,
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Text(
                        //             _userProfile.nikeName,
                        //             style: const TextStyle(
                        //               color: Colors.white,
                        //               fontSize: 28,
                        //               fontWeight: FontWeight.bold,
                        //             ),
                        //           ),
                        //           const SizedBox(height: 8),
                        //           _buildIndexView(index), // 根据当前页索引显示不同内容
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(
                              File(imageUrl),
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
                            // 底部文字叠加层
                            Align(
                              alignment: Alignment.bottomLeft,
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          _userProfile.nikeName,
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        InkWell(
                                          onTap: () {
                                            ///跳转 UserPage
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                     UserPage(userProfile: _userProfile,),
                                              ),
                                            );
                                          },
                                          child: Icon(
                                            Icons.arrow_circle_up,
                                            color: Colors.white70,
                                            size: 18,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    _buildIndexView(index), // 根据当前页索引显示不同内容
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                  );
                },
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: // 顶部Page指示器
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _userProfile.mediaUrls!.length,
                    (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: _currentPage == index
                              ? Colors.white
                              : Colors.grey,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIndexView(int index) {
    switch (index) {
      case 0:
        // 第一张图：关于我的两个真相和一个谎言...
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.format_quote,
                    color: Color(0xFFFF4757), // 红色引号图标
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _userProfile.aboutMe,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // const Text(
              //   "是的多多",
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontSize: 16,
              //   ),
              // ),
            ],
          ),
        );

      case 1:
        // 第二张图：基础和生活方式
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: const [
                  Icon(Icons.info_outline, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    "基础和生活方式",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  if (_userProfile.lifestyle.petPreference.isNotEmpty)
                    _buildTag(
                      icon: Icons.pets,
                      text: _userProfile.lifestyle.petPreference,
                    ),
                  if (_userProfile.lifestyle.drinking.isNotEmpty)
                    _buildTag(
                      icon: Icons.local_drink,
                      text: _userProfile.lifestyle.drinking,
                    ),
                  if (_userProfile.lifestyle.smoking.isNotEmpty)
                    _buildTag(
                      icon: Icons.smoking_rooms,
                      text: _userProfile.lifestyle.smoking,
                    ),
                  if (_userProfile.lifestyle.fitness.isNotEmpty)
                    _buildTag(
                      icon: Icons.fitness_center,
                      text: _userProfile.lifestyle.fitness,
                    ),
                  if (_userProfile.lifestyle.socialMediaActivity != null &&
                      _userProfile.lifestyle.socialMediaActivity!.isNotEmpty)
                    _buildTag(
                      icon: Icons.social_distance,
                      text: _userProfile.lifestyle.socialMediaActivity ?? "",
                    ),
                ],
              ),
            ],
          ),
        );

      case 2:
        // 第三张图：Spotify 最爱歌曲
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.music_note,
                    color: Color(0xFF1DB954), // Spotify绿
                    size: 20,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "Spotify 最爱歌曲",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  // 歌曲封面
                  Container(
                    width: 60,
                    height: 60,
                    color: Colors.grey[800],
                    child: const Center(
                      child: Icon(
                        Icons.music_note,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // 歌曲信息
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _userProfile.favoriteSong?.title ?? "未知歌曲",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        _userProfile.favoriteSong?.artist ?? "未知艺术家",
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      // Spotify播放按钮
                      Row(
                        children: [
                          Icon(
                            Icons.circle,
                            color: Color(0xFF1DB954),
                            size: 12,
                          ),
                          SizedBox(width: 4),
                          Text(
                            "在 Spotify 上播放",
                            style: TextStyle(
                              color: Color(0xFF1DB954),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );

      default:
        return const SizedBox.shrink();
    }
  }

  // 辅助方法：构建生活方式标签
  Widget _buildTag({required IconData icon, required String text}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(color: Colors.white, fontSize: 14)),
        ],
      ),
    );
  }
}
