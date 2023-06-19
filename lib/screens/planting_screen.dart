import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../buttons/buttons.dart';

class PlantingScreen extends StatefulWidget {
  const PlantingScreen({Key? key});

  @override
  _PlantingScreenState createState() => _PlantingScreenState();
}

class _PlantingScreenState extends State<PlantingScreen> {
  final databaseReference = FirebaseDatabase.instance.ref();
  Reference ref = FirebaseStorage.instance.ref().child('data');
  List<String> imageUrls = [];
  List<DateTime> createdTimes = [];
  bool isLoading = true;
  DateTime? selectedDate;
  var _time = '';
  int visibleImageCount = 10;

  @override
  void initState() {
    super.initState();
    loadImages();
    databaseReference.child('ESP32/RTC1307/Time').onValue.listen((event) {
      var time = event.snapshot.value;
      if (mounted) {
        setState(() {
          _time = time.toString();
        });
      }
    });
  }

  Future<void> loadImages() async {
    ListResult result = await ref.list();
    List<Map<String, dynamic>> imageList = [];

    await Future.forEach(result.items, (Reference ref) async {
      String url = await ref.getDownloadURL();
      FullMetadata metadata = await ref.getMetadata();
      DateTime createdTime = metadata.timeCreated!;
      imageList.add({
        'url': url,
        'createdTime': createdTime,
      });
    });

    imageList.sort((a, b) => b['createdTime'].compareTo(a['createdTime']));
    List<String> loadedImageUrls = List<String>.from(
        imageList.map((e) => e['url']).take(visibleImageCount));
    List<DateTime> loadedCreatedTimes = List<DateTime>.from(
        imageList.map((e) => e['createdTime']).take(visibleImageCount));

    setState(() {
      imageUrls = loadedImageUrls;
      createdTimes = loadedCreatedTimes;
      isLoading = false;
    });
  }

  void _onImageTap(String url, DateTime createdTime) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ImageScreen(
          imageUrl: url,
          createdTime: createdTime,
        ),
      ),
    );
  }

  void _selectDate() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void _loadMoreImages() {
    setState(() {
      visibleImageCount += 10;
      if (visibleImageCount >= imageUrls.length) {
        visibleImageCount = imageUrls.length;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<String> filteredImageUrls = [];
    List<DateTime> filteredCreatedTimes = [];

    if (selectedDate != null) {
      for (int i = 0; i < createdTimes.length; i++) {
        if (createdTimes[i].year == selectedDate!.year &&
            createdTimes[i].month == selectedDate!.month &&
            createdTimes[i].day == selectedDate!.day) {
          filteredImageUrls.add(imageUrls[i]);
          filteredCreatedTimes.add(createdTimes[i]);
        }
      }
    } else {
      filteredImageUrls = imageUrls;
      filteredCreatedTimes = createdTimes;
    }

    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      body: SafeArea(
        child: Container(
          margin: const EdgeInsets.only(top: 18, left: 24, right: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(
                      Icons.arrow_back_ios,
                      color: Colors.indigo,
                    ),
                  ),
                  const Text(
                    "Planting",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  GestureDetector(
                    child: Text(
                      "$_time น.",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                        color: Colors.black54,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Expanded(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 30,
                        ),
                        Text(
                          selectedDate != null
                              ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                              : DateFormat('yyyy-MM-dd').format(DateTime.now()),
                          style: const TextStyle(
                            fontSize: 20,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        elevatedButton(
                          onPressed: _selectDate,
                          text: 'Select Date',
                          colors: [
                            Colors.indigo,
                            Colors.indigo,
                          ],
                        ),
                      ],
                    ),
                    isLoading
                        ? const Center(
                            child: CircularProgressIndicator(),
                          )
                        : Expanded(
                            child: GridView.count(
                              crossAxisCount: 2,
                              children:
                                  List.generate(visibleImageCount, (index) {
                                return GestureDetector(
                                  onTap: () => _onImageTap(
                                    filteredImageUrls[index],
                                    filteredCreatedTimes[index],
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: Image.network(
                                          filteredImageUrls[index],
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                    if (visibleImageCount < imageUrls.length)
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: elevatedButton(
                          onPressed: _loadMoreImages,
                          text: 'Load More',
                          colors: [
                            Colors.indigo,
                            Colors.indigo,
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ImageScreen extends StatelessWidget {
  final String imageUrl;
  final DateTime createdTime;

  const ImageScreen({
    Key? key,
    required this.imageUrl,
    required this.createdTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Large Image'),
      ),
      body: Column(
        children: [
          Center(
            child: Image.network(
              imageUrl,
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'เวลาบันทึก: ${DateFormat('yyyy-MM-dd HH:mm').format(createdTime)} น.',
            style: const TextStyle(fontSize: 24),
          ),
        ],
      ),
    );
  }
}
