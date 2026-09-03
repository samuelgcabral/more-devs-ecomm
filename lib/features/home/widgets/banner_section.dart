import 'dart:async';

import 'package:flutter/material.dart';

class BannerSection extends StatefulWidget {
  const BannerSection({super.key});

  @override
  State<BannerSection> createState() => _BannerSectionState();
}

class _BannerSectionState extends State<BannerSection> {
  final PageController _pageController = PageController();
  late final Timer _timer;
  int _selectedPage = 0;

  static const List<_BannerItem> _items = [
    _BannerItem(
      title: 'Aproveite as\nofertas',
      imageUrl: 'https://i.postimg.cc/8Pt82Qmf/Image-1.png',
    ),
    _BannerItem(
      title: 'Experimente\nagora!',
      imageUrl: 'https://i.postimg.cc/RVP8P1vw/Image-2.png',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!_pageController.hasClients) return;

      final nextPage = (_selectedPage + 1) % _items.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 142,
            child: PageView.builder(
              controller: _pageController,
              itemCount: _items.length,
              onPageChanged: (page) {
                setState(() => _selectedPage = page);
              },
              itemBuilder: (context, index) {
                return _BannerCard(item: _items[index]);
              },
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_items.length, (index) {
              final selected = index == _selectedPage;

              return Container(
                width: selected ? 6 : 4,
                height: selected ? 6 : 4,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: selected ? Colors.black54 : Colors.black26,
                  shape: BoxShape.circle,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _BannerCard extends StatelessWidget {
  const _BannerCard({required this.item});

  final _BannerItem item;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.centerLeft,
              color: const Color(0xFFE4E9EC),
              child: Text(
                item.title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                ),
              ),
            ),
          ),
          Expanded(
            child: Image.network(
              item.imageUrl,
              width: double.infinity,
              height: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => const ColoredBox(
                color: Color(0xFFF2F2F2),
                child: Center(child: Icon(Icons.image_not_supported_outlined)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BannerItem {
  const _BannerItem({required this.title, required this.imageUrl});

  final String title;
  final String imageUrl;
}
