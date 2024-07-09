import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mad3_finals_tuba/utils/constants.dart';

class JournalCard extends StatefulWidget {
  final Map<String, dynamic> journal;
  final String journalId;

  JournalCard({required this.journal, required this.journalId});

  @override
  _JournalCardState createState() => _JournalCardState();
}

class _JournalCardState extends State<JournalCard> {
  late PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (_pageController.hasClients) {
        if (_currentPage < (widget.journal['images'] as List).length - 1) {
          _currentPage++;
        } else {
          _currentPage = 0;
        }
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 800),
          curve: Curves.easeIn,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final images = widget.journal['images'] as List<dynamic>;

    return GestureDetector(
      onTap: () {
        context.push('/viewjournal', extra: widget.journalId);
      },
      child: Container(
        height: 250.0,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 253, 241, 241),
          borderRadius: BorderRadius.circular(18.0),
        ),
        child: Column(
          children: [
            Expanded(
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  if (images.isNotEmpty)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18.0),
                        child: PageView.builder(
                          controller: _pageController,
                          itemCount: images.length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: MediaQuery.of(context).size.width -
                                  32, // Adjust width as needed
                              height: 250.0,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image:
                                      CachedNetworkImageProvider(images[index]),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  if (images.isEmpty)
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18.0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/images/placeholder.png'),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.journal['title'],
                            style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Flexible(
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 15.0,
                                color: Constants.secondaryColor,
                              ),
                              SizedBox(height: 5.0),
                              Text(
                                'Location: ',
                                style: TextStyle(
                                  fontSize: 13.0,
                                  color: Color(0xFF343434),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  widget.journal['location'] != null
                                      ? '(${widget.journal['location'].latitude}, ${widget.journal['location'].longitude})'
                                      : '',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    color: Constants.primaryColor,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.0),
                    Text(
                      widget.journal['description'],
                      style: TextStyle(
                        fontSize: 13.0,
                        color: Color(0xFF343434),
                      ),
                    ),
                    SizedBox(height: 5.0),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
