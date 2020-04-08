import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'paintings.dart';
import 'login.dart';

class Home extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin{
  int _selectedIndex = 0;
  AnimationController controller;
  Animation<Offset> animation;
  Animation<Offset> animationB;
  Animation<Offset> animationC;
  double drawDuration = 2.0;

  void initState(){
    super.initState();

    controller = AnimationController(vsync: this, duration: Duration(seconds: drawDuration.toInt()));

    animation = Tween<Offset>(
      begin: Offset(-1.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.fastLinearToSlowEaseIn,
    ));

    animationB = Tween<Offset>(
      begin: Offset(1.0, -1.5),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.fastLinearToSlowEaseIn,
    ));

    animationC = Tween<Offset>(
      begin: Offset(1.0, 1.5),
      end: Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.fastLinearToSlowEaseIn,
    ));


    Future<void>.delayed(Duration(milliseconds: 0), () {
      controller.forward();
    });

  }


  Widget _charityContainer(){
    return AspectRatio(
      aspectRatio: 3/2,
      child: Container(
        margin: EdgeInsets.fromLTRB(40,0,40,30),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          color: Colors.orange[400],
          boxShadow: [BoxShadow(
            color: Colors.grey[500],
            blurRadius: 20.0,
            offset: Offset.fromDirection(0.9),
          ),],
        ),
        child: Column(
          children: <Widget>[
          ],
        ),
      ),
    );
  }

  Widget _transactionsText() {
    return Container (
      margin: EdgeInsets.fromLTRB(15,30,0,10),
      alignment: Alignment.centerLeft,
      child: Text(
        'Transactions',
        style: TextStyle(
          fontSize: 16,
          color: Colors.grey[600],
        ),
      ),
    );
  }

  Widget _transactionContainer() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height / 2.4,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(25), topRight: Radius.circular(25),),
        color: Colors.grey[100],
        boxShadow: [BoxShadow(
          color: Colors.grey[350],
          blurRadius: 10.0,
          offset: Offset.fromDirection(5, 7),
        ),],
      ),
      child: _transactions(),
    );
  }

  Widget _transactions() {
    return ListView.separated(
      separatorBuilder: (context, i){
        return Divider(
          thickness: 1.0,
          indent: 50,
          endIndent: 50,
        );
      },
      itemCount: 10,
      itemBuilder: (context, i) {
        return Container(
          margin: EdgeInsets.fromLTRB(10,10,0,10),
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: <Widget>[
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.green,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _bottomNavBar() {
    return BottomNavigationBar(
      elevation: 0,
      backgroundColor:Colors.grey[100],
      showUnselectedLabels: false,
      showSelectedLabels: false,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.perm_identity),
          title: Text('Home'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          title: Text('search'),
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.settings),
          title: Text('settings'),
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: Colors.lightBlue[600],
      onTap: _onItemTapped,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SlideTransition(
          position: animation,
          child: CustomPaint(
            painter: HomePaint(),
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  SlideTransition(position: animationB,child: _charityContainer()),
                  SlideTransition(position: animation,child: _transactionsText()),
                  SlideTransition(position: animationC,child: _transactionContainer()),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: _bottomNavBar(),
      extendBody: true,
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Login()));
  }
}