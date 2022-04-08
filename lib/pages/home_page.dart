import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest/models/pinterest_model.dart';
import 'package:pinterest/models/settings_model.dart';
import 'package:pinterest/pages/detail_page.dart';
import 'package:pinterest/pages/profile_page.dart';
import 'package:pinterest/pages/search_page.dart';
import 'package:pinterest/servises/pinterst_servise.dart';
import 'package:pinterest/servises/setting_hive_servise.dart';

import 'sms_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String id = "/HomePage";

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Pinterest> picture = [];
  bool isLoading = false;
  bool isLastPage = false;
  int select = 0;
  bool selectAppBar = false;
  int lengthOfPicture  = 0;
  int pageNum = 0;
  int page =  0;

  final ScrollController _scrollController = ScrollController();
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiPostList();
    select = 0;
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          isLoading = true;
        });
        loadmorePosts();
       loadNoteList();
      }
    });
  }
  late List<Settings> listNote;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  void _apiPostList() async {
    isLoading = true;
    await Network.GET(Network.API_LIST, Network.paramsEmpty())
        .then((response) => {
              print(response!),
              _showResponse(response),
            });
  }

  void _showResponse(String response) {
    setState(() {
      isLoading = false;
      picture = Network.parsePostList(response);
      picture.shuffle;
      lengthOfPicture = picture.length;
    });
  }
  void loadmorePosts() async {
   int  pageNumber = ((lengthOfPicture~/lengthOfPicture)+1);
    String? response = await Network.GET(Network.API_LIST, Network.paramsEmpty2(pageNumber));
    List<Pinterest> newPosts = Network.parsePostList(response!);
    picture.addAll(newPosts);
    setState(() {
      isLoading = false;
    });
  }
  int selectedIndex = 0;
  Future<void> loadFirstData() async {
    await Future.delayed(const Duration(seconds: 2), () {
      setState(() {
       // pageNum++;
        isLastPage = false;
        page = 1;
      _apiPostList();
      lengthOfPicture = picture.length;
      });
    });
  }


  void loadNoteList() {
    setState(() {
      listNote = DBService.loadNotes();
    });
  }

  void _openDetailPage() async {
    var result = await Navigator.pushNamed(context, DetailPage.id);
    if (result != null && result == true) {
      loadNoteList();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () { DBService.storeMode(!DBService.loadMode());loadNoteList();},
            icon: Icon(DBService.loadMode() ? Icons.dark_mode : Icons.light_mode),),

        ],
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Container(
            width: MediaQuery.of(context).size.width / 2.75,
            height: kToolbarHeight,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectAppBar = false;
                        });
                      },
                      child: Text(
                        "Browse",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ),
                    Container(
                      width: 55,
                      height: 5,
                      color: !selectAppBar ? Colors.grey : Colors.white,
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          selectAppBar = true;
                        });
                      },
                      child: Text(
                        "Watch",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ),
                    Container(
                      width: 55,
                      height: 5,
                      color: selectAppBar ? Colors.grey : Colors.white,
                    )
                  ],
                ),
              ],
            )),
      ),
      resizeToAvoidBottomInset: false,
      extendBody: true,
      body:  SafeArea(
        child: Stack(children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Container(
                    height: MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).size.width,
                    child: !selectAppBar
                        ? MasonryGridView.count(
                      controller: _scrollController,
                      itemCount: picture.length,
                      crossAxisCount: 2,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                      itemBuilder: (context, index) {
                        return buildingGRID(index);
                      },
                    )
                        : ListView.builder(
                        itemCount: picture.length,
                        itemBuilder: (context, index) {
                          return buildingGRID(index);
                        })),
              ],
            ),
          ),
          Positioned(
            child: Container(
              height: 45,
              width: MediaQuery.of(context).size.width / 2,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        select = 0;
                      });
                    },
                    icon: Icon(Icons.home),
                    color:  Colors.black,
                  ),
                  IconButton(
                    splashRadius: 5,
                    onPressed: () {
                      setState(() {
                        Navigator.pushNamed(context, Searchpage.id);
                        select = 1;
                      });
                    },
                    icon: Icon(Icons.search),
                    color:  Colors.grey ,
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        Navigator.pushNamed(context, SmsPage.id);
                      });
                    },
                    icon: Icon(Icons.sms),
                    color: Colors.grey ,
                  ),
                  Container(
                    margin: EdgeInsets.only(left: 10),
                    child: CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: AssetImage("assets/images/image2.jpg"),
                      radius: 10,
                      child: MaterialButton(
                        onPressed: () {
                          Navigator.pushNamed(context, ProfilePage.id);
                          setState(() {
                            select = 3;
                          });
                        },
                      ),
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(40),
              ),
            ),
            left: MediaQuery.of(context).size.width / 4,
            top: MediaQuery.of(context).size.height * 0.80,
          ),
          Positioned(left: MediaQuery.of(context).size.width/2-10,child: isLoading
          ?const CircularProgressIndicator(
          backgroundColor: Colors.transparent,
          strokeWidth: 6,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.black))
              : const SizedBox.shrink(),),
          ///#navigation

        ]),
      ),
    );
  }

  Widget buildingGRID(int index) {
    return InkWell(
      onTap: (){ Navigator.push(
          context,
          MaterialPageRoute(
          builder: (context) => DetailPage(
          picture: picture[index])));
         },
     child: Container(
      color: Colors.transparent,
      margin: EdgeInsets.symmetric(vertical: 2),
      child:
      Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: CachedNetworkImage(
              imageUrl: picture[index].urls!.regular!,
              fit: BoxFit.cover,
              placeholder: (context, url) => AspectRatio(
                aspectRatio: picture[index].width != null
                    ? picture[index].width! / picture[index].height!
                    : 1000 / 500,
                child: Container(
                  color: Colors.red,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:[
                Container(
                    height: 15,
                    child: Row(

                      children: [
                        MaterialButton(
                          height: 10,
                          minWidth: 10,
                          child: Icon(
                            Icons.favorite,
                            size: 15,
                            color: Colors.red,
                          ),
                          onPressed: () {},
                        ),
                        Text(
                          picture[index].likes!.toString(),
                          style: TextStyle(fontSize: 11, color: Colors.black),

                        ),

                      ],
                    )),
                Container(height: 15, child:     MaterialButton(
                  height: 10,
                  minWidth: 10,
                  child: Icon(
                    Icons.more_horiz_outlined,
                    color: Colors.black,
                    size: 15,
                  ),
                  onPressed: () {},
                ),),
              ]),
        ],
      ),
      )
    );
  }
}


// bottomNavigationBar: BottomNavigationBar(
// items: [
// BottomNavigationBarItem(icon:   IconButton(
// onPressed: () {
// setState(() {
// select = 0;
// });
// },
// icon: Icon(Icons.home),
// color: (select != 0) ? Colors.grey : Colors.black,
// ),label: "Home"),
// BottomNavigationBarItem(icon:   IconButton(
// splashRadius: 5,
// onPressed: () {
// setState(() {
// Navigator.pushNamed(context, Searchpage.id);
// select = 1;
// });
// },
// icon: Icon(Icons.search),
// color: (select != 1) ? Colors.grey : Colors.black,
// ),label: "Search"),
// BottomNavigationBarItem(icon: IconButton(
// onPressed: () {
// setState(() {
// select = 2;
// });
// },
// icon: Icon(Icons.sms),
// color: (select != 2) ? Colors.grey : Colors.black,
// ),label: "Comment"),
// BottomNavigationBarItem(icon:  Container(
// margin: EdgeInsets.only(left: 10),
// child: CircleAvatar(
// backgroundColor: Colors.grey,
// backgroundImage: AssetImage("assets/images/image2.jpg"),
// radius: 10,
// child: MaterialButton(
// onPressed: () {
// Navigator.pushNamed(context, ProfilePage.id);
// setState(() {
// select = 3;
// });
// },
// ),
// ),
// ),label: "Account"),
// ],
// ),

