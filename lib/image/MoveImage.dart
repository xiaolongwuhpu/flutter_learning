

import 'package:flutter/material.dart';

///从左到右 电影运镜的效果
class MoveImage extends StatefulWidget {
  @override
  _MoveImageState createState() => _MoveImageState();
}

class _MoveImageState extends State<MoveImage> with SingleTickerProviderStateMixin {
  late ScrollController _scrollController;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();

    // 在build方法后进行初始化操作
    WidgetsBinding.instance.addPostFrameCallback((_) {
      double middlePosition = (_scrollController.position.maxScrollExtent - _scrollController.position.minScrollExtent) / 2;
      _scrollController.jumpTo(middlePosition);

      _animationController = AnimationController(
        vsync: this,
        duration: Duration(seconds: 3),
      );

      _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
      )..addListener(() {
        double maxScrollExtent = _scrollController.position.maxScrollExtent;
        double minScrollExtent = _scrollController.position.minScrollExtent;
        double middlePosition = (maxScrollExtent - minScrollExtent) / 2;
        double scrollPosition = middlePosition + (_animation.value * (maxScrollExtent - middlePosition));
        _scrollController.jumpTo(scrollPosition);
      });

      _animationController.forward().then((_) {
        _animationController.reverse();
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _animationController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        controller: _scrollController,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        child:  Image.asset('assets/images/ttt.png',  height: 600, fit: BoxFit.cover),
      ),
    );

    return Center(
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(_animation.value * 200 - 100, 0), // 200为平移范围的一半，-100为起点调整
            child: child,
          );
        },
        child: Image.asset('assets/images/ttt.png', width: double.maxFinite, height: double.maxFinite, fit: BoxFit.fill),
      ),
    );
  }
}