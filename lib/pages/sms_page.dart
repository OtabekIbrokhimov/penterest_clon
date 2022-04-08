import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest/models/collection%20Model.dart';
import 'package:pinterest/models/pinterest_model.dart';
import 'package:pinterest/servises/pinterst_servise.dart';

import 'detail_page.dart';

class SmsPage extends StatefulWidget {
  const SmsPage({Key? key}) : super(key: key);
static const String id = "/SmsPage";
  @override
  _SmsPageState createState() => _SmsPageState();
}

class _SmsPageState extends State<SmsPage> {
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
      }
    });
  }

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
    String? response = await Network.GET(Network.API_LIST, Network.paramsEmpty());
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
          ),
            width: MediaQuery.of(context).size.width-180,
            height: kToolbarHeight,
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      color: !selectAppBar ? Colors.grey : Colors.white,
                      onPressed: () {
                        setState(() {
                          selectAppBar = false;
                        });
                      },
                      child: Text(
                        "Updates",
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 17),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: !selectAppBar ? Colors.grey : Colors.white,
                      ),
                      width: 55,
                      height: 5,

                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(

                      color: selectAppBar ? Colors.grey : Colors.white,
                      onPressed: () {
                        setState(() {
                          selectAppBar = true;
                        });
                      },
                      child: Text(
                        "Messages",
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: PageView(
            children: [
              Column(
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height/3,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                        shrinkWrap: true,
                        controller: _scrollController,
                        itemCount: picture.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
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
                        },
                      )
                  )],
              )
            ],
          ),
        ),
      ),

    );
  }
}
