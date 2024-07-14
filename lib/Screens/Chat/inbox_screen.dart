import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:play_dates/Screens/Chat/chat_screen.dart';
import 'package:play_dates/Utlis/Models/contact_model.dart';

class InboxScreen extends StatelessWidget {
  const InboxScreen({super.key, required this.name, required this.contacts});

  final String name;
  final List<ContactModel> contacts;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        title: Text(
          name,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: contacts.length + 1,
        itemBuilder: (builder, index) {
          if (index == 0) return searchBtn();
          return ListTile(
            onTap: () {
              Get.to(
                () => ChatScreen(
                  contact: contacts[index - 1],
                ),
              );
            },
            visualDensity: const VisualDensity(vertical: 2, horizontal: -4),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
            isThreeLine: true,
            leading: ProfileIcon(
              radius: 32,
              url: contacts[index - 1].profileUrl,
            ),
            subtitle: Text(contacts[index - 1].lastMessage ?? ""),
            subtitleTextStyle: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
            title: Text(
              contacts[index - 1].name,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
            ),
            minLeadingWidth: 1,
            trailing: const Icon(
              Icons.camera_alt_rounded,
              color: Colors.black,
              size: 36,
            ),
          );
        },
      ),
    );
  }

  Padding searchBtn() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        margin: const EdgeInsets.only(bottom: 24, top: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [
            BoxShadow(
              color: Colors.black,
              offset: Offset(-4, 4),
            ),
          ],
        ),
        child: TextField(
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color.fromARGB(255, 250, 239, 223),
            enabledBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black,
                width: 5.0,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: const BorderSide(
                color: Colors.black,
                width: 5.0,
              ),
              borderRadius: BorderRadius.circular(14),
            ),
            hintText: "Search",
            hintStyle: const TextStyle(
              color: Colors.black,
              fontSize: 18,
            ),
            prefixIcon: const Icon(
              Icons.search,
              color: Colors.black,
              size: 36,
            ),
          ),
        ),
      ),
    );
  }
}

class ProfileIcon extends StatelessWidget {
  const ProfileIcon({
    super.key,
    required this.url,
    required this.radius,
  });

  final String url;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.black,
          width: 2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black,
            offset: Offset(-4, 4),
          ),
        ],
      ),
      child: CircleAvatar(
        backgroundImage: NetworkImage(
          url,
        ),
        radius: radius,
      ),
    );
  }
}
