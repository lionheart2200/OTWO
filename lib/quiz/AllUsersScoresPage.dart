import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:otwo/widgets/consts.dart';

class AllUsersScoresPage extends StatefulWidget {
  const AllUsersScoresPage({Key? key}) : super(key: key);

  @override
  _AllUsersScoresPageState createState() => _AllUsersScoresPageState();
}

class _AllUsersScoresPageState extends State<AllUsersScoresPage> {
  Map<String, Map<String, int>> _classScores = {}; // خريطة لتخزين الدرجات حسب الصف

  @override
  void initState() {
    super.initState();
    _fetchAndAggregateScores();
  }

  Future<void> _fetchAndAggregateScores() async {
    final snapshot = await FirebaseFirestore.instance.collection('studentScores').get();
    Map<String, Map<String, int>> aggregatedScores = {}; // خريطة لتجميع الدرجات

    for (var doc in snapshot.docs) {
      String username = doc['username'];
      int score = doc['score'] as int;
      String className = doc['className']; // الحصول على اسم الصف

      // تجميع الدرجات حسب الصف
      if (!aggregatedScores.containsKey(className)) {
        aggregatedScores[className] = {};
      }

      if (aggregatedScores[className]!.containsKey(username)) {
        aggregatedScores[className]![username] = aggregatedScores[className]![username]! + score;
      } else {
        aggregatedScores[className]![username] = score;
      }
    }

    setState(() {
      _classScores = aggregatedScores; // تحديث الحالة
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: myBackgroundColor,
      appBar: AppBar(
        backgroundColor: myBlackColor,
        actions: const [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "لوحة الأبطال",
              style: myBarFont,
            ),
          ),
        ],
      ),
      body: _classScores.isEmpty
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _classScores.keys.length,
              itemBuilder: (context, index) {
                final className = _classScores.keys.elementAt(index);
                final usersScores = _classScores[className];

                // ترتيب المستخدمين حسب النقاط تنازلياً
                final sortedUsersScores = usersScores!.entries.toList()
                  ..sort((a, b) => b.value.compareTo(a.value)); // ترتيب تنازلي

                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Container(color: myWhiteColor,
                  
                    child: Column(
                      children: [
                        ListTile(
                          title: Directionality(
                            textDirection: TextDirection.rtl,
                            child: Text(className, style: myCardTitleFont)),
                        ),
                        ...sortedUsersScores.asMap().entries.map((entry) {
                          final index = entry.key;
                          final userScore = entry.value;
                          final username = userScore.key;
                          final totalScore = userScore.value;
                    
                          // تعيين لون الكارد بناءً على ترتيب المستخدم
                          Color cardColor;
                          if (index == 0) {
                            cardColor = Colors.blue; // المستخدم الأول
                          } else if (index == 1) {
                            cardColor = Colors.green; // المستخدم الثاني
                          } else if (index == 2) {
                            cardColor = Colors.red; // المستخدم الثالث
                          } else {
                            cardColor = Colors.white; // المستخدم الرابع وما بعده
                          }
                    
                          return Card(
                            color: cardColor, // تعيين لون الكارد
                            child: ListTile(
                              title: Directionality(
                                textDirection: TextDirection.rtl, // تعيين اتجاه النص لليمين لليسار
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // توزيع المسافة بين العناصر
                                  children: [
                                    Text(username,style: myCardTitleFont,),
                                    Text("Total Score: $totalScore",style: myBottomBarFont,),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
