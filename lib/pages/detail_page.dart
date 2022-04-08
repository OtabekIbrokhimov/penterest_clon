import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pinterest/models/pinterest_model.dart';
import 'package:pinterest/servises/pinterst_servise.dart';

// ignore: must_be_immutable
class DetailPage extends StatefulWidget {
  Pinterest? picture;
  String? search;

  DetailPage({Key? key, this.picture, this.search}) : super(key: key);
  static const String id = "/DetailPage";

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool isLoading = false;
  List<Pinterest> list = [];
  int? lengthOfPicture;
  final ScrollController _scrollController = ScrollController();
  List  imageOfApps =["assets/images/instagramm.png","assets/images/sms.png",
  "assets/images/telegram.png","assets/images/whatsapp.jpg", "assets/images/facebook.png","assets/images/more.png",

  ];
  List  nameOfItems = ["instagramm","sms","telegramm","whatsapp","facebook","more"];
  @override
  void initState() {
    list.add(widget.picture!);
    super.initState();
    _apiPostList();
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
      list = Network.parsePostList(response);
      list.shuffle;
      lengthOfPicture = list.length;
    });
  }

  void loadmorePosts() async {
    int pageNumber = ((lengthOfPicture! ~/ lengthOfPicture!) + 1);
    String? response =
        await Network.GET(Network.API_LIST, Network.paramsEmpty2(pageNumber));
    List<Pinterest> newPosts = Network.parsePostList(response!);
    list.addAll(newPosts);
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: ListView.builder(
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return buildingGRID(index);
                      }),
                ),
              ],
            ),
          ),
          Positioned(
            left: MediaQuery.of(context).size.width / 2 - 10,
            child: isLoading
                ? const CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                    strokeWidth: 6,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black))
                : const SizedBox.shrink(),
          ),
        ]),
      ),
    );
  }

  Widget buildingGRID(int index) {
    return InkWell(
      onTap: () {},
      child: Column(
        children: [
          index < 1
              ? Container(
                  child: Column(children: [
                  ClipRRect(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
                    child: CachedNetworkImage(
                      imageUrl: widget.picture!.urls!.regular!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => AspectRatio(
                        aspectRatio: widget.picture!.urls!.regular != null
                            ? widget.picture!.width! / widget.picture!.height!
                            : 1000 / 500,
                        child: Container(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                    Container(
                      margin: EdgeInsets.only(bottom: 5),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30), ),color: Colors.grey),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                child: Row(children: [
                                  CircleAvatar(
                                    backgroundImage: NetworkImage(
                                        widget.picture!.user!.profileImage!.large!),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Column(children: [
                                    Text(
                                      widget.picture!.user!.name!,
                                      style: TextStyle(fontWeight: FontWeight.bold),
                                      maxLines: 10,
                                      textAlign: TextAlign.start,
                                    ),
                                    widget.picture!.user!.totalLikes != null
                                        ? Text(
                                      "Total likes: " +
                                          widget.picture!.user!.totalLikes!.toString(),
                                      style: TextStyle(color: Colors.black54),
                                      maxLines: 10,
                                      textAlign: TextAlign.start,
                                      textHeightBehavior: TextHeightBehavior(),
                                    )
                                        : Text(""),
                                  ]),
                                ]),
                                width: MediaQuery.of(context).size.width - 200,
                              ),
                              Container(
                                  margin: EdgeInsets.only(right: 10),
                                  height: 35,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.blueAccent,
                                  ),
                                  child: MaterialButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Follow",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ))
                            ],
                          ),
                          SizedBox(height: 5,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(onPressed: (){}, icon: Icon(Icons.comment_outlined)),
                              SizedBox(width: 55,),
                              Container(
                                  margin: EdgeInsets.only(right: 10),
                                  height: 35,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.blueAccent,
                                  ),
                                  child: MaterialButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Visit",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  )),
                              Container(
                                  margin: EdgeInsets.only(right: 10),
                                  height: 35,
                                  width: 80,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.blueAccent,
                                  ),
                                  child: MaterialButton(
                                    onPressed: () {},
                                    child: Text(
                                      "Save",
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  )),
                              SizedBox(width: 55,),
                              IconButton(onPressed: (){_modalBottomSheetMenu();}, icon: Icon(Icons.share)),
                            ],
                          )
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
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
                                  widget.picture!.likes!.toString(),
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.black),
                                ),
                              ],
                            )),
                        Container(
                          height: 15,
                          child: MaterialButton(
                            height: 10,
                            minWidth: 10,
                            child: Icon(
                              Icons.more_horiz_outlined,
                              color: Colors.black,
                              size: 15,
                            ),
                            onPressed: () {},
                          ),
                        ),
                      ]),
                ]))
              : Container(
                  height: 0,
                  width: 0,
                ),
          ClipRRect(
            borderRadius: BorderRadius.only(topRight: Radius.circular(30),topLeft: Radius.circular(30)),
            child: CachedNetworkImage(
              imageUrl: list[index].urls!.raw!,
              fit: BoxFit.cover,
              placeholder: (context, url) => AspectRatio(
                aspectRatio: list[index].width != null
                    ? list[index].width! / list[index].height!
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
          Container(
            margin: EdgeInsets.only(bottom: 5),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30), ),color: Colors.grey),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Row(children: [
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              list[index].user!.profileImage!.large!),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Column(children: [
                          Text(
                            list[index].user!.username!,
                            style: TextStyle(fontWeight: FontWeight.bold),
                            maxLines: 10,
                            textAlign: TextAlign.start,
                          ),
                          list[index].likes != null
                              ? Text(
                                  "likes: " +
                                      list[index].likes!.toString(),
                                  style: TextStyle(color: Colors.black54),
                                  maxLines: 10,
                                  textAlign: TextAlign.start,
                                  textHeightBehavior: TextHeightBehavior(),
                                )
                              : Text(""),
                        ]),
                      ]),
                      width: MediaQuery.of(context).size.width - 200,
                    ),
                    Container(
                        margin: EdgeInsets.only(right: 10),
                        height: 35,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blueAccent,
                        ),
                        child: MaterialButton(
                          onPressed: () {},
                          child: Text(
                            "Follow",
                            style: TextStyle(color: Colors.black),
                          ),
                        ))
                  ],
                ),
                SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   IconButton(onPressed: (){_modalBottomSheetMenu();}, icon: Icon(Icons.comment_outlined)),
                   SizedBox(width: 55,),
                    Container(
                        margin: EdgeInsets.only(right: 10),
                        height: 35,
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blueAccent,
                        ),
                        child: MaterialButton(
                          onPressed: () {},
                          child: Text(
                            "Visit",
                            style: TextStyle(color: Colors.black),
                          ),
                        )),
                    Container(
                        margin: EdgeInsets.only(right: 10),
                        height: 35,
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.blueAccent,
                        ),
                        child: MaterialButton(
                          onPressed: () {},
                          child: Text(
                            "Save",
                            style: TextStyle(color: Colors.black),
                          ),
                        )),
                    SizedBox(width: 55,),
                    IconButton(onPressed: (){_modalBottomSheetMenu();}, icon: Icon(Icons.share)),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
  void _modalBottomSheetMenu() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
        ),
        context: context,
        builder: (builder) {
          return  Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height / 3,
              decoration: BoxDecoration(borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30), topRight: Radius.circular(30)
              ), color: Colors.transparent,),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(margin: EdgeInsets.all(20),
                    child: Column(
                      children:[
                        Row(children: [
                          IconButton(onPressed: (){Navigator.pop(context);} ,icon: Icon(Icons.one_x_mobiledata)),
                          Text("Send Pin"),
                        ],),
                        SizedBox(height:100,width: MediaQuery.of(context).size.width,
                        child:  ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: imageOfApps.length,
                          itemBuilder: (context, index){
                            return Column(
                              children:[
                                CircleAvatar(
                                  backgroundImage: AssetImage(imageOfApps[index],),
                                  radius:  35,
                                  child: MaterialButton(
                                    onPressed: (){},
                                  ),
                                ),
                                SizedBox(height: 5,),
                                Text(nameOfItems[index])
                              ],
                            );
                          },
                        ),
                        ),
                        Container(
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

                            },

                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(Icons.comment),
                              hintText: "add comment",
                              hintStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.w600),

                            ),
                          ), ),
                         ],
                    ),)
                ],
              )
          );
        }
    );
  }
}
