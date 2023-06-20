import 'package:chatbox/data/data_repository.dart';
import 'package:chatbox/message.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class Chat extends HookWidget {
  const Chat({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = useTextEditingController();

    final repository = context.read<DataRepository>();

    return Scaffold(
      body: Scaffold(
        bottomNavigationBar: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(12) + const EdgeInsets.only(bottom: 16),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  autocorrect: false,
                  maxLines: 1,
                  style: const TextStyle(fontSize: 28),
                  textAlignVertical: TextAlignVertical.top,
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.symmetric(horizontal: 8),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                icon: const Icon(Icons.send),
                color: Colors.black,
                onPressed: () {
                  if (controller.text.isEmpty) {
                    return;
                  }

                  repository.send(controller.text);

                  controller.clear();
                },
              ),
            ],
          ),
        ),
        body: SafeArea(
          minimum: const EdgeInsets.symmetric(horizontal: 16),
          child: StreamBuilder<Object>(
              stream: repository.onMessages(),
              builder: (context, snapshot) {
                final messages = snapshot.data as List<String>?;

                return ListView(
                  reverse: true,
                  children: (messages ?? [])
                      .map((message) => Message(text: message))
                      .toList(),
                );
              }),
        ),
      ),
    );
  }
}
