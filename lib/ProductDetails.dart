import 'package:flutter/material.dart';

class ProductDetails extends StatelessWidget{

  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Restaurant App',
      theme: ThemeData(

      ),
      home:
      Scaffold(
      body:ListView(
        children: [
  Center(
          child:Container(
            width:350,
            height: 350,

            decoration: BoxDecoration(
             color: Colors.white,
             borderRadius: BorderRadius.circular(10),

             boxShadow: [
                BoxShadow(
                  color: Colors.yellow.withOpacity(0.2),
                  spreadRadius: 2.5,
                  blurRadius: 3,
                  offset: Offset(0, 4),
                ),
              ]
            ),

            child:Image.asset(
              "salta3burger.png",
            fit:BoxFit.cover,
            )
          ),
  ),
          Center(

          child:Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.only(top:20),
            width: 350,
            height: 210,
            decoration: BoxDecoration(
              color:Colors.white,
                boxShadow: [
                BoxShadow(
                  color:Colors.red.withOpacity(0.3),
                  spreadRadius: 1.5,
                  blurRadius: 5,
                  offset: Offset(0,4),
                ),
              ]
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,

              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                      Text("The classic",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight:FontWeight.bold,
                      ),),
                      Text("49,5",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight:FontWeight.bold,
                          decoration:TextDecoration.lineThrough,
                        ),
                      ),
                  ],

                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:[
                    Container(
                      height:50,
                      width:90,
                      padding:EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color:Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color:Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 3,
                            offset: Offset(0,4),


                          ),
                        ]
                      ),
                      child:Column(

                        children: [
                          Icon(Icons.fire_extinguisher),
                          Text("245 Calories",
                            style: TextStyle(
                              fontSize:10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding:EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color:Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow:[
                          BoxShadow(
                            color:Colors.black.withOpacity(0.2),
                            spreadRadius:2,
                            blurRadius:3,
                            offset:Offset(0,4),
                          ),
                        ],
                      ),
                      child:Column(
                        children: [
                          Icon(Icons.monitor_weight_rounded),
                          Text("24g Protein",
                          style:TextStyle(
                            fontSize:10,
                            fontWeight: FontWeight.bold,
                          ),),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        borderRadius:BorderRadius.circular(10),
                          color:Colors.white,
                          boxShadow:[
                            BoxShadow(
                              color:Colors.black.withOpacity(0.2),
                              spreadRadius :2,
                              blurRadius:3,
                              offset:Offset(0,4),

                            )
                          ]
                      ),
                      child:Column(
                        children: [
                          Icon(Icons.shield_rounded),
                          Text("18g Fat",
                          style:TextStyle(
                            fontSize:10,
                            fontWeight:FontWeight.bold,
                          )),
                        ],
                      ),
                    ),
                    Container(
                      padding:EdgeInsets.all(10),
                      decoration:BoxDecoration(
                        color:Colors.white,
                        borderRadius:BorderRadius.circular(10),
                        boxShadow:[BoxShadow(
                          color:Colors.black.withOpacity(0.2),
                          spreadRadius:2,
                          blurRadius:3,
                          offset:Offset(0,4),
                        ),
            ],
                      ),
                      child:Column(

                        children: [
                          Icon(Icons.network_wifi_2_bar_outlined),
                          Text("26g Carbs",
                          style:TextStyle(
                            fontSize:11,
                            fontWeight:FontWeight.bold,
                          ),),
                        ],
                      ),
                    ),

                  ],
                ),
                Column(
                  children: [
                    Center(
                      child:
                    Container(
                      alignment: Alignment.center,

                      width:double.infinity,
                      padding:EdgeInsets.all(10),
                      decoration:BoxDecoration(
                        color:Colors.black,
                        borderRadius:BorderRadius.circular(10),

                      ),
                    child:Text("Buy Now",
                    style:TextStyle(
                      fontSize:18,
                      fontWeight:FontWeight.bold, 
                      color:Colors.white,

                    )),
                    ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          ),

        ],
      ),
      ),

    );
  }
}
