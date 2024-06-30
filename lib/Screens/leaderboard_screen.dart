import 'package:flutter/material.dart';
import 'package:play_dates/Utlis/Buttons/flat_btn.dart';
import 'package:play_dates/Utlis/Colors/theme_color.dart';

import '../Utlis/Paints/outlined_text.dart';

class QuestEndScreen extends StatelessWidget {
  const QuestEndScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: sandColor,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset('assets/05.png'),
              const SizedBox(
                height: 30,
              ),
              const OutlinedText(
                text: "Quest End",
                offset: Offset(-6, 6),
                textColor: Colors.white,
                fontSize: 74,
                borderColor: Colors.black,
              ),
              const SizedBox(
                height: 60,
              ),
              const Text(
                "LeaderBoards in...",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              FlatBtn(onTap: () {}, text: "3 secs"),
            ],
          ),
        ),
      ),
    );
  }
}

class LeaderBoardScreen extends StatelessWidget {
  const LeaderBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 249, 228),
      appBar: AppBar(
        backgroundColor: Colors.white,
        toolbarHeight: 80,
        shape: const Border(
          bottom: BorderSide(
            color: Colors.black,
            width: 5,
          ),
        ),
        leadingWidth: 16,
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.close_sharp,
            size: 36,
            color: Colors.black,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Status",
              style: TextStyle(
                color: Colors.black,
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
            ),
            const LeaderBoardTile(
              title: "Current Match: ",
              titleColor: Colors.black,
              trailing: "Vanshika",
              leadingColor: Color.fromARGB(255, 146, 97, 53),
              icon: Icons.dangerous,
            ),
            const LeaderBoardTile(
              title: "Players: ",
              titleColor: Colors.black,
              trailing: "15",
              leadingColor: Color.fromARGB(204, 21, 21, 21),
              icon: Icons.dangerous,
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
              "Rankings",
              style: TextStyle(
                color: Colors.black,
                fontSize: 32,
                fontWeight: FontWeight.w600,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: 20,
                itemBuilder: (context, index) => ListTile(
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 30,
                        child: Text(
                          (index + 1).toString(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5 * 2),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black,
                            width: 2.0,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black,
                              spreadRadius: 3,
                              offset: Offset(4, 4),
                            )
                          ],
                        ),
                        child: const CircleAvatar(
                          backgroundImage: NetworkImage(
                            "https://images.unsplash.com/photo-1718963892270-04300c864522?q=80&w=1887&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                          ),
                          maxRadius: 16,
                        ),
                      )
                    ],
                  ),
                  title: const Text(
                    "Vanshika",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: Text(
                    (index + 1).toString(),
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  minVerticalPadding: 10,
                  minTileHeight: 10,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class LeaderBoardTile extends StatelessWidget {
  const LeaderBoardTile({
    super.key,
    required this.icon,
    required this.title,
    required this.trailing,
    required this.titleColor,
    required this.leadingColor,
  });

  final IconData icon;
  final String title;
  final String trailing;
  final Color titleColor;
  final Color leadingColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.golf_course,
                color: Colors.black,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                title,
                style: TextStyle(
                  color: titleColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 100,
            child: Center(
              child: Text(
                trailing,
                style: TextStyle(
                  color: leadingColor,
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
