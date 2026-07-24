import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:taei_gov/src/login/controller/login_controller.dart';
import 'package:taei_gov/src/responsive.dart';
import 'package:taei_gov/utils/common/common_button.dart';
import 'package:taei_gov/utils/common/title_textfield.dart';

import '../../home/views/home.dart';

class LoginPage extends StatefulWidget {
  final int? id;
  final String? name;
  final String? username;
  final String? password;

  const LoginPage(
      {super.key, this.id, this.name, this.username, this.password});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final LoginController controller = Get.put(LoginController());
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  @override
  void initState() {
    super.initState();
    _email.text = widget.username?.toString() ?? '';
    _password.text = widget.password?.toString() ?? '';
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    // Start animation after small delay
    Future.delayed(const Duration(milliseconds: 200), () {
      _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.redAccent,
              Colors.orangeAccent,
              Colors.orangeAccent,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.all(20),
                width: context.isDesktop
                    ? MediaQuery.of(context).size.width / 3.5
                    : null,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // RotationTransition(
                    //   turns: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                    //       parent: _controller, curve: Curves.easeOutBack)),
                    //   child: CircleAvatar(
                    //     radius: 50,
                    //     backgroundImage:
                    //         AssetImage(_getImageForId(widget.id ?? 1)),
                    //   ),
                    // ),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage:
                              AssetImage(_getImageForId(widget.id ?? 1)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      widget.name ?? "TAEI Login",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 50),
                    TitleTextFormField(
                      prefixIcon: Icons.person_add_alt_rounded,
                      controller: _email,
                      title: 'Username / Number',
                      hintText: 'username',
                    ),
                    const SizedBox(height: 20),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Password',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    TextFormField(
                      controller: _password,
                      obscureText: true,
                      enableInteractiveSelection: false,
                      enableSuggestions: false,
                      autocorrect: false,
                      autofillHints: const [],
                      decoration: InputDecoration(
                        hintText: 'Password',
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: const Icon(Icons.remove_red_eye),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      contextMenuBuilder: (context, editableTextState) {
                        return Container(); // no menu
                      },
                    ),
                    const SizedBox(height: 20),
                    CommonElevatedButtonM(
                      backgroundColor: Colors.white,
                      text: 'Login',
                      onPressed: () {
                        _handleLogin();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getImageForId(int id) {
    switch (id) {
      case 1:
        return 'assets/pillar/script_logo.jpg';
      case 2:
        return 'assets/pillar/stemi_logo.jpg';
      case 3:
        return 'assets/pillar/trauma_logo.jpg';
      case 4:
        return 'assets/pillar/burns_logo.jpg';
      case 5:
        return 'assets/pillar/poison_logo.jpg';
      case 6:
        return 'assets/pillar/prem_logo.jpg';
      default:
        return 'assets/pillar/trauma_logo.jpg';
    }
  }

  Future<void> _handleLogin() async {
    if (_email.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter username");
    } else if (_password.text.isEmpty) {
      Fluttertoast.showToast(msg: "Please enter password");
    } else {
      await controller
          .login(email: _email.text.trim(), password: _password.text.trim())
          .then((v) {
        if (v) Get.offAll(() => Home());
      });
    }
  }
}

class InteractiveSvgView extends StatefulWidget {
  const InteractiveSvgView({super.key});

  @override
  State<InteractiveSvgView> createState() => _InteractiveSvgViewState();
}

class _InteractiveSvgViewState extends State<InteractiveSvgView> {
  int? hoveredIndex;

  final List<Rect> clickableRects = [
    Rect.fromLTWH(360, 152, 67, 180),
    Rect.fromLTWH(290, 152, 67, 180),
    Rect.fromLTWH(220, 152, 67, 180),
    Rect.fromLTWH(150, 152, 67, 180),
    Rect.fromLTWH(80, 152, 67, 180),
    Rect.fromLTWH(11, 152, 67, 180),
    Rect.fromLTWH(61, 94, 317, 26.5),
    Rect.fromLTWH(132, 19, 175, 65),
  ];

  final List<String> navigationRoutes = [
    '/module1',
    '/module2',
    '/module3',
    '/module4',
    '/module5',
    '/module6',
    '/module7',
    '/module8',
  ];

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          SvgPicture.asset(
            'assets/logo/pillars_logo.svg',
            width: 440,
            height: 358,
          ),

          // Overlay clickable transparent buttons
          for (int i = 0; i < clickableRects.length; i++)
            Positioned(
              left: clickableRects[i].left,
              top: clickableRects[i].top,
              width: clickableRects[i].width,
              height: clickableRects[i].height,
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                onEnter: (_) => setState(() => hoveredIndex = i),
                onExit: (_) => setState(() => hoveredIndex = null),
                child: GestureDetector(
                  onTap: () {
                    print("Tapped on rect $i");
                    //    Get.toNamed(navigationRoutes[i]); // or Navigator.push()
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    decoration: BoxDecoration(
                      color: hoveredIndex == i
                          ? Colors.black.withOpacity(0.15)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(4),
                      border: hoveredIndex == i
                          ? Border.all(color: Colors.tealAccent, width: 2)
                          : null,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class SvgClickablePage extends StatelessWidget {
  const SvgClickablePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            SvgPicture.asset(
              'assets/logo/pillars_logo.svg',
              width: 440,
              height: 358,
            ),
            // Overlay clickable regions
            Positioned(
              left: 360,
              top: 152,
              child: _hoverBox(context, 'pattern0_33_143', onTap: () {
                Get.toNamed('/page1');
              }),
            ),
            Positioned(
              left: 290,
              top: 152,
              child: _hoverBox(context, 'pattern1_33_143', onTap: () {
                Get.toNamed('/page2');
              }),
            ),
            // ...repeat for other rects
          ],
        ),
      ),
    );
  }

  Widget _hoverBox(BuildContext context, String tag,
      {required VoidCallback onTap}) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => debugPrint('Hover on $tag'),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 67,
          height: 180,
          color: Colors.transparent,
          child: InkWell(
            hoverColor: Colors.teal.withOpacity(0.2),
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}
