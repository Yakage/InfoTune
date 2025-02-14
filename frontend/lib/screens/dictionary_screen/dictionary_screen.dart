import 'package:flutter/material.dart';
import 'package:infotune/blocs/dictionary_bloc.dart';
import 'package:infotune/blocs/dictionary_event.dart';
import 'package:infotune/blocs/dictionary_state.dart';
import 'package:infotune/widgets/app_bar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DictionaryScreen extends StatefulWidget {
  final DictionaryBloc dictionaryBloc;
  const DictionaryScreen({super.key, required this.dictionaryBloc});

  @override
  DictionaryScreenState createState() => DictionaryScreenState();
}

class DictionaryScreenState extends State<DictionaryScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    widget.dictionaryBloc.add(DictionaryLoadingEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarWidget(title: "Dictionary"),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.blue.shade800,
              Colors.blue.shade600,
              Colors.blue.shade400,
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Search Bar
              Container(
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          style: const TextStyle(color: Colors.white),
                          decoration: const InputDecoration(
                            hintText: 'Enter a word...',
                            hintStyle: TextStyle(color: Colors.white54),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.search, color: Colors.white),
                        onPressed: () {
                          if (_controller.text.isNotEmpty) {
                            widget.dictionaryBloc.add(
                              FetchDefiniionEvent(word: _controller.text),
                            );
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // BlocBuilder for Definition Card
              Expanded(
                child: BlocBuilder<DictionaryBloc, DictionaryState>(
                  builder: (context, state) {
                    if (state is DictionaryLoadingState) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: Colors.white,
                        ),
                      );
                    } else if (state is DictionaryLoadedSuccessState) {
                      return SingleChildScrollView(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _controller.text,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                state.definition,
                                style: const TextStyle(
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else if (state is DictionaryErrorState) {
                      return Center(
                        child: Text(
                          state.message,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    }
                    return const Center(
                      child: Text(
                        "Search for a word to see its definition.",
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
