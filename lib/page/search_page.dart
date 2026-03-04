import 'package:flutter/material.dart';
import 'package:tinder_app/page/home_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final List<SectionItem> _sections = [
    SectionItem(
      title: '目标明确的约会',
      array: [
        CardItem(
          title: '寻找长期的伴侣',
          subtitle: '',
          image: 'assets/long_term.png',
          color: Colors.red.shade700,
        ),
        CardItem(
          title: '享受短期交往的乐趣',
          subtitle: '',
          image: 'assets/short_term.png',
          color: Colors.red.shade400,
        ),
        CardItem(
          title: '结交新朋友',
          subtitle: '',
          image: 'assets/new_friend.png',
          color: Colors.amber.shade700,
        ),
        CardItem(
          title: '进行照片验证',
          subtitle: '',
          image: 'assets/photo_verify.png',
          color: Colors.red.shade400,
        ),
      ],
    ),
    SectionItem(
      title: '共同兴趣或爱好',
      array: [
        CardItem(
          title: '寻找兴趣相投的人',
          subtitle: '',
          image: 'assets/match_hobby.png',
          color: Colors.green.shade700,
        ),
      ],
    ),
  ];

  bool _isLoadingMore = false;
  bool _isRefreshing = false;

  Future<void> _onRefresh() async {
    setState(() => _isRefreshing = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => _isRefreshing = false);
  }

  Future<void> _loadMore() async {
    if (_isLoadingMore) return;
    setState(() => _isLoadingMore = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      // _items.addAll([
      //   CardItem(
      //     title: '新目标',
      //     subtitle: '',
      //     image: 'assets/new_target.png',
      //     color: Colors.purple.shade700,
      //   ),
      //   CardItem(
      //     title: '更多兴趣',
      //     subtitle: '',
      //     image: 'assets/more_interest.png',
      //     color: Colors.blue.shade700,
      //   ),
      // ]);
      _isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF101014),
      body: SafeArea(
        // child: RefreshIndicator(
        //   onRefresh: _onRefresh,
        //   child: NotificationListener<ScrollNotification>(
        //     onNotification: (ScrollNotification scrollInfo) {
        //       if (scrollInfo.metrics.pixels >=
        //               scrollInfo.metrics.maxScrollExtent - 100 &&
        //           !_isLoadingMore) {
        //         _loadMore();
        //       }
        //       return false;
        //     },
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          itemCount: _sections.length + (_isLoadingMore ? 1 : 0),
          itemBuilder: (context, index) {
            SectionItem section = _sections[index];
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  section.title,
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  '寻找相似的交往目标',
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),
                const SizedBox(height: 16),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: _sections[index].array.length,
                  itemBuilder: (context, i) {
                    CardItem row = _sections[index].array[i];
                    return _GoalCard(item: row);
                  },
                ),
              ],
            );
          },
        ),
      ),
      // ),
      // ),
    );
  }
}

class SectionItem {
  final String title;
  final List<CardItem> array;
  SectionItem({required this.title, required this.array});
}

class CardItem {
  final String title;
  final String subtitle;
  final String image;
  final Color color;
  CardItem({
    required this.title,
    required this.subtitle,
    required this.image,
    required this.color,
  });
}

class _GoalCard extends StatelessWidget {
  final CardItem item;
  const _GoalCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (context) => const HomePage()));
      },
      child: Container(
        decoration: BoxDecoration(
          color: item.color,
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: AssetImage(item.image),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              item.color.withOpacity(0.7),
              BlendMode.srcATop,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              item.title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
                shadows: [
                  Shadow(
                    color: Colors.black54,
                    offset: Offset(1, 1),
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
