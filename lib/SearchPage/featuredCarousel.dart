import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class FeaturedCarousel extends StatelessWidget{

  final _orgImages = [
    NetworkImage("https://images.shulcloud.com/1450/logo/1550604879.img"),
    NetworkImage("http://www.jsn.info/uploads/1/9/1/2/19123279/published/1393271267.png?1513880506"),
    NetworkImage("https://www.meiraacademy.org/uploads/1/9/1/2/19123279/download_orig.png"),
    NetworkImage("https://www.torahanytime.com/static/images/logo.png"),
    NetworkImage("https://www.boneiolam.org/images/bonei_olam_logo.jpg"),
    NetworkImage( "http://www.firstnonprofit.org/wp-content/uploads/2019/07/Olami-logo.jpg"),
    NetworkImage("https://www.partnersintorah.org/wp-content/uploads/2017/12/partners-in-torah-white-logomark.png"),
    NetworkImage("https://upload.wikimedia.org/wikipedia/en/a/a4/Zaka01.png"),
  ];

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return _imageCarousel();
  }

  Widget _imageCarousel(){
    return CarouselSlider.builder(
      options:CarouselOptions(
        viewportFraction: .5,
        initialPage: 0,
        enableInfiniteScroll: true,
        reverse: false,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 5),
        autoPlayAnimationDuration: Duration(seconds:1),
        autoPlayCurve: Curves.fastOutSlowIn,
        enlargeCenterPage: true,
        scrollDirection: Axis.horizontal,
      ),
      itemCount: _orgImages.length,
      itemBuilder: (BuildContext context, int itemIndex) =>
          Container(
            //width:MediaQuery.of(context).size.width*.65,
           // margin:EdgeInsets.symmetric(horizontal:10),
            decoration: BoxDecoration(
              borderRadius:BorderRadius.circular(25),
              image:DecorationImage(
                image:_orgImages[itemIndex],
                fit:BoxFit.cover
              )
            ),
          ),
    );

  }
}