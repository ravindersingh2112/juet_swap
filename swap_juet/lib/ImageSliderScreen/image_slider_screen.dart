import 'package:flutter/material.dart';
import 'package:flutter_image_slider/carousel.dart';
import 'package:swap_juet/HomeScreen/home_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageSliderScreen extends StatefulWidget {

  final String title, urlImage1,urlImage2,urlImage3,urlImage4,urlImage5;
  final String itemColor, userNumber, description, address, itemPrice;
  final double lat,lng;

  ImageSliderScreen({
    required this.title,
    required this.urlImage1,
    required this.urlImage2,
    required this.urlImage3,
    required this.urlImage4,
    required this.urlImage5,
    required this.itemColor,
    required this.userNumber,
    required this.description,
    required this.address,
    required this.itemPrice,
    required this.lat,
    required this.lng,
});



  @override
  State<ImageSliderScreen> createState() => _ImageSliderScreenState();
}

class _ImageSliderScreenState extends State<ImageSliderScreen> with SingleTickerProviderStateMixin{

  static List<String> links = [];
  TabController? tabController;
  getLinks(){
    links.add(widget.urlImage1);
    links.add(widget.urlImage2);
    links.add(widget.urlImage3);
    links.add(widget.urlImage4);
    links.add(widget.urlImage5);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLinks();
    tabController = TabController(length: 5, vsync: this);
  }

  String? url;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent,Colors.cyanAccent,],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: [0.0,1.0],
            tileMode: TileMode.clamp,
          )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent,Colors.cyanAccent,],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [0.0,1.0],
                tileMode: TileMode.clamp,
              ),
            ),
          ),
          title: Text(
            widget.title,
            style: const TextStyle(
              fontFamily: 'Varela',
              letterSpacing: 2.0,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            onPressed: ()
            {
            Navigator.pushReplacement(
              context,MaterialPageRoute(
                builder: (context)=>HomeScreen()));
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20.0,left: 6.0,right: 12.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.location_pin,
                    color: Colors.black54,),
                    const SizedBox(width: 4.0,),
                    Expanded(
                        child: Text(
                          widget.address,
                          textAlign: TextAlign.justify,
                          overflow: TextOverflow.fade,
                          style: const TextStyle(
                            fontFamily: 'Varela',
                            letterSpacing: 2.0,
                          ),
                        )
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0,),
              SizedBox(
                height: size.height * 0.5,
                width: size.width,
                child: Padding(
                  padding: EdgeInsets.all(2),
                  child: Carousel(
                    indicatorBarColor: Colors.black.withOpacity(0.0),
                    autoScrollDuration: const Duration(seconds: 2),
                    animationPageDuration: const Duration(seconds: 500),
                    activateIndicatorColor: Colors.black,
                    animationPageCurve: Curves.easeIn,
                    indicatorBarHeight: 30,
                    indicatorHeight: 10,
                    indicatorWidth: 10,
                    unActivatedIndicatorColor: Colors.grey,
                    stopAtEnd: false,
                    autoScroll: true,
                    items: [
                      Image.network(widget.urlImage1),
                      Image.network(widget.urlImage2),
                      Image.network(widget.urlImage3),
                      Image.network(widget.urlImage4),
                      Image.network(widget.urlImage5),
                    ],

                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 2.0),
                child: Center(
                  child: Text(
                    '\₹ ${widget.itemPrice}',
                    style: const TextStyle(
                      fontSize: 24,
                      letterSpacing: 2.0,
                      fontFamily: 'Bebas',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10,),
               Padding(padding: const EdgeInsets.only(left: 15.0,right: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.brush_outlined),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text(widget.itemColor),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        const Icon(Icons.phone_android),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Align(
                            alignment: Alignment.topRight,
                            child: Text(widget.userNumber),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20.0,),
              Padding(
                padding: const EdgeInsets.only(left: 15,right: 15),
                child: Text(widget.description,
                textAlign: TextAlign.justify,
                style: TextStyle(
                  color: Colors.black.withOpacity(0.6),
                ),
                ),
              ),
              const SizedBox(height: 20,),
              Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints.tightFor(width: 368,),
                  child: ElevatedButton(
                    onPressed: ()
                    async
                    {
                      double latitude = widget.lat;
                      double longitude = widget.lng;

                    url = 'https://www.google.com/maps/search/?api=1&query=$latitude, $longitude';
                    if(await canLaunchUrl(Uri.parse(url!)))
                    {
                      await launchUrl(Uri.parse(url!));
                    }
                    else{
                      throw 'Could Not open the map';
                    }
                    },
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.transparent),
                    ),
                    child: const Text(
                      'Check Seller Location'
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20,),
            ],
          ),
        ),
      ),
    );
  }
}
