import 'dart:convert';
import 'dart:ui'; 
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:news/pages/model.dart';
import 'package:http/http.dart';

class Home extends StatefulWidget {

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = new TextEditingController();
  List<NewsQueryModel> newsModelList = <NewsQueryModel>[];
  List<NewsQueryModel> newsModelListCarousel = <NewsQueryModel>[];
  List<String> navBarItem = ["Top News","India", "America" , "Finance" , "Politics", "Health"];
  bool isLoading = true;
  
  
  getNewsByQuery(String query) async {
    String url =
        "https://newsapi.org/v2/everything?q=tesla&from=2023-03-11&sortBy=publishedAt&apiKey=5c1a1c7bad7c40a88e598294cd511d51";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element) {
        NewsQueryModel newsQueryModel = new NewsQueryModel();
        newsQueryModel = NewsQueryModel.fromMap(element);
        newsModelList.add(newsQueryModel);
        setState(() {
          isLoading = false;
        });

      });
    });

  }

  getNewsofIndia() async {
    String url = "https://newsapi.org/v2/top-headlines?country=us&category=business&apiKey=5c1a1c7bad7c40a88e598294cd511d51";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element) {
        NewsQueryModel newsQueryModel = new NewsQueryModel();
        newsQueryModel = NewsQueryModel.fromMap(element);
        newsModelListCarousel.add(newsQueryModel);
        setState(() {
          isLoading = false;
        });

      });
    });


  }


  @override
  void initState() {

    super.initState();
    getNewsByQuery("corona");
    getNewsofIndia();
  }

  @override
  Widget build(BuildContext context) {
    var city_name =["gorakhpur", "delhi", "mumbai" , "punjab", "noida" , "kolkata" , "lucknow" , "london" ,"america" ] ;

    
    return SafeArea(
      child: Scaffold(
        
          drawer: const Drawer( ),
          appBar: AppBar(
            
          
         title: const Text('ताज़ा ख़बर', style: TextStyle(fontWeight: FontWeight.bold,  fontSize: 25),),
         centerTitle: true,
         
         actions: const [Icon(Icons.event_sharp),
          Padding(padding: EdgeInsets.symmetric(horizontal: 10)),
          Icon(Icons.notifications),
           
           Padding(padding: EdgeInsets.symmetric(horizontal: 9)),],
            foregroundColor: Colors.black,
            backgroundColor: Colors.transparent,
              
                 toolbarHeight: 50,
           
       flexibleSpace: Container(
        height: 48,
        
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30),bottomRight: Radius.circular(20)),
                gradient: LinearGradient(
                    colors: [Color.fromARGB(255, 239, 202, 202),Color.fromARGB(255, 210, 249, 70)],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter
                
                 ),
               ),
             )
             ),
            
          body: Container(
            height: 1000,
            child: SingleChildScrollView(
              
              child: Column(
                
                    children: [
              Container(
                height: 40,
                
                margin: EdgeInsets.symmetric(horizontal: 28, vertical: 12),
               
                padding: EdgeInsets.symmetric(horizontal: 5),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 224, 225, 222),
                  borderRadius: BorderRadius.circular(35)
                  
                ),
                child: Row(
                  children: [
                    GestureDetector(
                       onTap: (){ if ((searchController.text).replaceAll(" ", "") ==
                      "") {
                    print("Blank search");
                  } else {
                  }
                  },
                
                       child: Container(
                        margin: EdgeInsets.only(right: 20),
                        child: Icon(Icons.search , color: Colors.blue),
                        ),
                    ),
                    
                      const Expanded( 
                         child: TextField(
                        
                        textInputAction: TextInputAction.search,
                       
                        decoration: InputDecoration(
                          
                          border: InputBorder.none,
                          
                          hintText: "search the city name "
                        ),
                       ),
                     )
                  ],
                ),
                
              ),
              Container(
                height: 40,
                 child: Container(
                  height: 40,
                   child: ListView.builder(
                    
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal ,
                    itemCount: navBarItem.length , itemBuilder: (context, index){
                    return InkWell(
                      onTap: (){
                        print("soon it will come");
                        
                      },
                      child: Container(
                         height: 30,
                         decoration: BoxDecoration(
                          color: Color.fromARGB(255, 210, 249, 70),borderRadius: BorderRadius.circular(60),
                          
                         ),
                        padding: EdgeInsets.symmetric(horizontal: 17 , vertical: 10),
                        child: Center(
                          child: Text(
                              navBarItem[index] , style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold
                              ),),
                        ),
                      ),
                    );
                   }),
                 ),
              ),
              SizedBox(
                height: 10,
              ),
              CarouselSlider(
                
                options : CarouselOptions(
                  
                  height : 210,
                  autoPlay : true,
                    enlargeCenterPage : true
                ),
                items :  newsModelListCarousel.map((instance) {
                  return Builder(
                    
                    builder: (BuildContext context){
                      return Container(
                        margin: EdgeInsets.symmetric(vertical: 0),
                        child: Card(
                          child: Stack(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child:Image.network(instance.newsImg , height: double.infinity,),
                              ),
                              Positioned(
                                left: 9,
                                right: 0,
                                bottom: 8,
                                child: Container(
          
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [Text("" ,style: TextStyle(
                                    color: Colors.white , fontWeight: FontWeight.bold,fontSize: 17
                                  ),),
                                   Text(instance.newsHead ,style: TextStyle(
                                    color: Colors.white , fontWeight: FontWeight.bold
                                  ),   )],
                                ),
                              )
                              )
                            ],
                          ),
                        ),
                      );
                    }
                  );
                }).toList(),
               
              ),
              SizedBox(
                height: 10,
              ),
              Container(
              child: Column(
                children: [
                  Container(
                    margin : EdgeInsets.fromLTRB(15, 25, 0, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [

                        Text("LATEST NEWS " , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 28
                        ),),
                      ],
                    ),
                  ),
                  ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: newsModelList.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              elevation: 1.0,
                              child: Stack(
                                children: [
                                  ClipRRect(
                                      borderRadius: BorderRadius.circular(15),
                                      child: Image.network(newsModelList[index].newsImg)),

                                  Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Container(

                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(15),
                                          gradient: LinearGradient(
                                            colors: [
                                              Colors.black12.withOpacity(0),
                                              Colors.black
                                            ],
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter
                                          )
                                        ),
                                        padding: EdgeInsets.fromLTRB(15, 15, 10, 8),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                newsModelList[index].newsHead,
                                                
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Text(newsModelList[index].newsDes.length >50 ? "${newsModelList[index].newsDes.substring(0,5)}...." : newsModelList[index].newsDes ,  style: TextStyle(color: Colors.white , fontSize: 12)
                                                ,)
                                            ],
                                          )))
                                ],
                              )),
                        );
                      }),
             
              Container(
                padding: EdgeInsets.fromLTRB(0,10,0,5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: (){}, child: Text("SHOW MORE")),
                  ],
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ),
      )
    );

  }
 final List items = [ Image.network("https://www.shutterstock.com/image-vector/breaking-news-background-world-global-260nw-719766118.jpg") ];
  }
