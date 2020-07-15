import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../paintings.dart';

class ForgotPass extends StatefulWidget{
  @override
  _ForgotPassState createState()=>_ForgotPassState();
}

class _ForgotPassState extends State<ForgotPass>{

  final _emailController=TextEditingController();
  var _emailError='';


  Widget _passIcon(){
    return Container(
        alignment: Alignment.center,
        child:Icon(
          Icons.lock,
          size:100,
          color:Color.fromRGBO(0, 174, 229, 1),
        )
    );
  }

  Widget _forgotPassText(){
    return Container(
        margin:EdgeInsets.only(top:20),
        child:Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:[
              Text(
                'Reset Password',
                style:TextStyle(color:Colors.black, fontSize:28, fontWeight:FontWeight.bold),
              ),
              Container(
                  margin:EdgeInsets.only(top:10),
                  child:Text(
                      'Please enter your email address',
                      style:TextStyle(color:Colors.black, fontSize:16)
                  )
              )
            ]
        )
    );
  }

  Widget _emailField() {
    return Container(
      margin:EdgeInsets.only(top:40),
      width: MediaQuery.of(context).size.width*.75,
      decoration: BoxDecoration(
  //      border:Border(bottom: BorderSide(color: Colors.grey, width:2)),
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey[350],
            blurRadius: 20.0,
            offset: Offset.fromDirection(0.9),
          ),
        ],
      ),
      child: TextField(
        controller:_emailController,
        onChanged: (s){
          setState(() {
            //_nameErr='';
          });
        },
        onEditingComplete: (){
          //nameFocusNode.nextFocus();
        },
        decoration: InputDecoration(
          labelText: "Email",
          hasFloatingPlaceholder: false,
          prefixIcon: _emailPrefix()
        ),
        //focusNode: nameFocusNode,
      ),
    );
  }

  Widget _emailPrefix() {
    return Container(
      margin: EdgeInsets.only(left: 25, right: 15),
      child: Icon(
        Icons.email,
        size: 20,
        color: Colors.black,
      ),
    );
  }

  Widget _errorCont(){
    return Container(
      child: Text(
          _emailError,
          style:TextStyle(color:Colors.red)
      ),
    );
  }
  Widget _submitCont(){
    return Container(
        margin:EdgeInsets.only(top:10),
        child:_submitContent()
    );
  }

  Widget _submitContent(){
//    if(canResend){
//      return GestureDetector(
//          onTap:(){
//            _resend();
//          },
//          child:_resendTxt()
//      );
//    }
    return Container(
        child:Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:[
              _submitTxt(),
              //_resendLoadInd()
            ]
        )
    );
  }

  Widget _submitTxt(){
    return Text(
        'Submit',
        style:TextStyle(color:Color.fromRGBO(0, 174, 229, 1), fontSize:14, fontWeight: FontWeight.bold)
    );
  }

//  Widget _resendLoadInd(){
//    if(resendLoading){
//      return Container(
//          margin:EdgeInsets.only(left:18),
//          child:SizedBox(
//              width:12,
//              height:12,
//              child:CircularProgressIndicator(
//                  strokeWidth:2,
//                  valueColor: _loadingAn
//              )
//          )
//      );
//    }
//    return Container();
//  }

  Widget _mainBodyContainer(){
    return Container(
        child:Column(
          children: <Widget>[
            Container(
                margin: EdgeInsets.only(top:MediaQuery.of(context).size.height*.2),
                width:MediaQuery.of(context).size.width*.85,
                padding:EdgeInsets.fromLTRB(
                    MediaQuery.of(context).size.width*.07,
                    40,
                    MediaQuery.of(context).size.width*.07,
                    50
                ),
                decoration:BoxDecoration(
                    color:Colors.grey[100],
                    borderRadius:BorderRadius.circular(15),
                    boxShadow: [BoxShadow(color:Colors.grey, offset:Offset.fromDirection(.9),blurRadius:10)]
                ),
                child:Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      _passIcon(),
                      _forgotPassText(),
                      _emailField(),
                      _errorCont(),
                      _submitCont()
                    ]
                )
            ),
            //_resetPassword(),
          ],
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child:SafeArea(
        child:CustomPaint(
          painter: HomePaint(),
          child: SingleChildScrollView(
            child:_mainBodyContainer()
          )
        )
      )
    );
  }

}