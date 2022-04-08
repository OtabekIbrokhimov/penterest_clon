import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest/models/pinterest_model.dart';
import 'package:pinterest/pages/home_page.dart';
import 'package:pinterest/pages/profile_page.dart';
import 'package:pinterest/pages/sms_page.dart';
import 'package:pinterest/servises/pinterst_servise.dart';

import 'detail_page.dart';


class Searchpage extends StatefulWidget {
  const Searchpage({Key? key}) : super(key: key);
static const String id = "/SearchPage";
  @override
  _SearchpageState createState() => _SearchpageState();
}

class _SearchpageState extends State<Searchpage> {
  TextEditingController searchController = TextEditingController();
  List<Pinterest> picture1 = [];
  int pageNum = 0;
  bool isLoading = false;
  String searcher = "all";
  int lengthOfPicture  = 0;
  ScrollController _scrollController = ScrollController();
  int select = 1;
  int pageNumber = 0;
 void _showResponse(String response) {
    setState(() {
      isLoading = false;
      picture1 = Network.parsePostList(response);
      picture1.shuffle;
      lengthOfPicture = picture1.length;
    });
  }
  void loadmorePosts() async {
    pageNumber++;
    String? response = await Network.GET(Network.API_LIST, Network.paramsEmpty2(pageNumber));
    List<Pinterest> newPosts = Network.parsePostList(response!);
    picture1.addAll(newPosts);
    setState(() {
      isLoading = false;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchPost();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          isLoading = true;
        });
        loadmorePosts();
      }
    });
  }
  void searchPost() async {
    if (searcher.isEmpty) {
      searchController.text = " ";
    }
    pageNum += 1;
    String? response = await Network.GET(
        Network.API_SEARCH, Network.paramsSearch(pageNum,searcher));
    List<Pinterest> newPosts = Network.parseSearchParse(response!);
    setState(() {
      isLoading = false;
      picture1 = newPosts;
    });
    _showResponse(response);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      appBar: AppBar(centerTitle: true,
      leadingWidth: 0.0,
      backgroundColor: Colors.transparent,
      elevation: 0.0,
      leading: Container(),
      title: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        height: 40,
        decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20)
        ),
        width: MediaQuery.of(context).size.width-10,
        child: TextField(
          onEditingComplete: () {
            FocusScope.of(context).requestFocus(FocusNode());
            setState(() {
              isLoading = true;
              if (searcher != searchController.text.trim()) pageNum = 0;
              searcher = searchController.text.trim();
            });
            searchPost();
          },
          controller: searchController,
          decoration: InputDecoration(
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
            hintText: "Search for ideas",
            hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),

          ),
        ), ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: (
          Column(
            children: [
              Stack(children:[
              Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: MasonryGridView.count(
                    controller: _scrollController,
                    itemCount: picture1.length,
                    crossAxisCount: 2,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    itemBuilder: (context, index) {
                      return buildingGRID(index);
                    },
                  ),
              ),
                Positioned(left: MediaQuery.of(context).size.width/2-10,child: isLoading
                    ? const CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                    strokeWidth: 6,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black))
                    : const SizedBox.shrink(),),
                Positioned(
                  child: Container(
                    height: 45,
                    width: MediaQuery.of(context).size.width / 2,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, HomePage.id);
                            setState(() {
                              select = 0;
                            });
                          },
                          icon: Icon(Icons.home),
                          color:Colors.grey ,
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
                          color:Colors.black,
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              select = 2;
                              Navigator.pushNamed(context, SmsPage.id);
                            });
                          },
                          icon: Icon(Icons.sms),
                          color:Colors.grey,
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
              ])
            ],
          )
          ),
        ),
      ),
    );
  }
  Widget buildingGRID(int index) {
    return InkWell(
        onTap: (){ Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => DetailPage(
                    picture: picture1[index])));
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
                  imageUrl: picture1[index].urls!.regular!,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => AspectRatio(
                    aspectRatio: picture1[index].width != null
                        ? picture1[index].width! / picture1[index].height!
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
                              picture1[index].likes!.toString(),
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




















