import 'package:flutter/material.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);
  static const String id = "/ProfilePage";

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            backgroundColor: Colors.transparent,
            elevation: 0.0,
            pinned: true,
            leadingWidth: 0,
            actions: [
              IconButton(onPressed: () {
                _modalBottomSheetMenu();
              },
                  icon: Icon(Icons.settings, color: Colors.black,))
            ],
            collapsedHeight: MediaQuery
                .of(context)
                .size
                .height / 3,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              title: Container(
                margin: EdgeInsets.only(left: 1),
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(20)
                ),
                width: MediaQuery
                    .of(context)
                    .size
                    .width - 10,
                child: TextField(

                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                    hintText: "Search for ideas",
                    hintStyle: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.w600),

                  ),
                ),),
              background: Container(
                  child: Center(
                    child: Column(
                      children: const [
                        SizedBox(height: 25,),
                        CircleAvatar(
                          backgroundImage: AssetImage(
                              "assets/images/image2.jpg"),
                          radius: 60,
                        ),
                        SizedBox(height: 5,),
                        Text("dsfd",
                          style: TextStyle(fontSize: 15, color: Colors.black),),
                        SizedBox(height: 5,),
                        Text("sdfdf",
                          style: TextStyle(fontSize: 15, color: Colors.grey),),
                      ],
                    ),
                  )

              ),
            ),
          ),
          //3
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (_, int index) {
                return Container(
                  width: double.infinity,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),),

                );
              },
              childCount: 10,
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
          return new Container(
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
              Text("Profile", style: TextStyle(fontSize: 18, color: Colors.black), ),
              TextButton(onPressed: (){_modalBottomSheetsettings();}, child: Text("Settings",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black),)),
              TextButton(onPressed: (){}, child: Text("Copy profile link",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black),)),
              TextButton(onPressed: (){}, child: Text("Share",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black),)),
              ],
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
            ),)
          ],
          )
          );
        }
    );
  }
  void _modalBottomSheetsettings() {
   showBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(30),topRight: Radius.circular(30)),
        ),
        context: context,
        builder: (builder) {
          return new Container(
              height: MediaQuery
                  .of(context)
                  .size
                  .height,
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
                        Text("Personal information", style: TextStyle(fontSize: 18, color: Colors.black), ),
                        TextButton(onPressed: (){}, child: Text("Public profile",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black),)),
                        TextButton(onPressed: (){}, child: Text("Account Settings",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black),)),
                        TextButton(onPressed: (){}, child: Text("Permissions",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black),)),
                        TextButton(onPressed: (){}, child: Text("Notifications",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black),)),
                        TextButton(onPressed: (){}, child: Text("Privacy and data",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black),)),
                        TextButton(onPressed: (){}, child: Text("Homefeed tuner",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black),)),
                        Text("Actions", style: TextStyle(fontSize: 18, color: Colors.black), ),
                        TextButton(onPressed: (){}, child: Text("Add account",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black),)),
                        TextButton(onPressed: (){}, child: Text("Log out",style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.black),)),

                      ],
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                    ),)
                ],
              )
          );
        }
    );
  }
}
