import 'package:flutter/material.dart';

class CarouselBanner extends StatefulWidget {
  final List<String> imageUrls;

  const CarouselBanner({Key? key, required this.imageUrls}) : super(key: key);

  @override
  State<CarouselBanner> createState() => _CarouselBannerState();
}

class _CarouselBannerState extends State<CarouselBanner> {
  late PageController _pageController;
  int _currentIndex = 0;

  List<String> imageUrls = [
    'https://image.baidu.com/search/detail?adpicid=0&b_applid=12309896238352905915&bdtype=0&commodity=&copyright=&cs=3340368743%2C2111391895&di=7607122379617075201&fr=click-pic&fromurl=http%253A%252F%252Fbaijiahao.baidu.com%252Fs%253Fid%253D1828119827109804296%2526wfr%253Dspider%2526for%253Dpc&gsm=1e&hd=&height=0&hot=&ic=&ie=utf-8&imgformat=&imgratio=&imgspn=0&is=0%2C0&isImgSet=&latest=&lid=93148c30001390d2&lm=&objurl=https%253A%252F%252Fpic.rmb.bdstatic.com%252Fbjh%252Fnews%252F228d54deb1cb6486a3d76051938ebdea.png&os=2671159052%2C8343876&pd=image_content&pi=0&pn=26&rn=1&simid=3340368743%2C2111391895&tn=baiduimagedetail&width=0&word=图片&z=',
    'https://image.baidu.com/search/detail?adpicid=0&b_applid=9551403121037131581&bdtype=0&commodity=&copyright=&cs=3390391108%2C3499469929&di=7607122379617075201&fr=click-pic&fromurl=http%253A%252F%252Fnews.qq.com%252Frain%252Fa%252F20250608A01XKD00&gsm=1e&hd=&height=0&hot=&ic=&ie=utf-8&imgformat=&imgratio=&imgspn=0&is=0%2C0&isImgSet=&latest=&lid=93148c30001390d2&lm=&objurl=https%253A%252F%252Finews.gtimg.com%252Fom_bt%252FOojfJshW933jMkcFS1etYIHNEKv9fxrDnTJvz2NUD90igAA%252F641&os=685985916%2C3969941930&pd=image_content&pi=0&pn=26&rn=1&simid=4111454%2C815428065&tn=baiduimagedetail&width=0&word=图片&z=',
    'https://image.baidu.com/search/detail?adpicid=0&b_applid=9551403121037131581&bdtype=0&commodity=&copyright=&cs=1407085667%2C2235482246&di=7607122379617075201&fr=click-pic&fromurl=http%253A%252F%252Fview.inews.qq.com%252Fa%252F20240712A04T1B00&gsm=1e&hd=&height=0&hot=&ic=&ie=utf-8&imgformat=&imgratio=&imgspn=0&is=0%2C0&isImgSet=&latest=&lid=93148c30001390d2&lm=&objurl=https%253A%252F%252Finews.gtimg.com%252Fom_bt%252FOMMYjdrtBShYNcTp0JN8N2DC2WZ5b7f58sIh1UU78BAW4AA%252F641&os=1074203596%2C1346334942&pd=image_content&pi=0&pn=27&rn=1&simid=3571706977%2C493267477&tn=baiduimagedetail&width=0&word=图片&z=',
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    imageUrls = widget.imageUrls;
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onImageTap() {
    int nextIndex = (_currentIndex + 1) % widget.imageUrls.length;
    _pageController.animateToPage(
      nextIndex,
      duration: Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  Widget _buildIndicator() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.imageUrls.length, (index) {
        return Container(
          width: 24,
          height: 4,
          margin: EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            color: _currentIndex == index ? Colors.black : Colors.grey[300],
            borderRadius: BorderRadius.circular(2),
          ),
        );
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 顶部指示器
        Padding(
          padding: const EdgeInsets.only(top: 16, bottom: 8),
          child: _buildIndicator(),
        ),
        // 轮播图
        SizedBox(
          height: 250,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.imageUrls.length,
            onPageChanged: _onPageChanged,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: _onImageTap,
                child: Image.network(
                  imageUrls[index],
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
