import 'package:flutter/material.dart';
import 'package:untitled/my_appbar.dart';
import 'package:untitled/sql_helper.dart';

class DetailsPage extends StatefulWidget {
  const DetailsPage({Key? key, required this.id, required this.title, required this.image, required this.author, required this.description, required this.genre, required this.year, required this.price}) : super(key: key);

  final int id;
  final String image;
  final String title;
  final String author;
  final String description;
  final String genre;
  final int year;
  final double price;

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {

  // All The Cart Items
  List<Map<String, dynamic>> _cart = [];
  late int _totalItems=0;

  // This Function Is Used To Fetch All The Data From The Database
  void _refreshCart() async {
    final data = await SQLHelper.getCart();
    setState(() {
      _cart = data;
    });
  }

  void itemCount()async{
    //Cart Information
    final cartCount = await SQLHelper.getCount();
    setState(() {
      _totalItems= cartCount;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshCart();
    itemCount();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        setState(() {

        });
        return true;
      },
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        appBar: MyAppBar(pageTitle: widget.title, items: _totalItems),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: const Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Image.network(widget.image, fit: BoxFit.cover,),
                ),

                const SizedBox(height: 15.0,),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("${widget.price} TND", style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w800, color: Colors.red),),
                    const SizedBox(width: 5,)
                  ],
                ),
                const SizedBox(height: 5.0,),

                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(widget.title, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w800),),
                ),
                const SizedBox(height: 5.0,),

                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text("Author: ${widget.author}", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.grey.shade700),),
                ),

                Padding(
                  padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Genre: ${widget.genre}", style: TextStyle(fontSize: 14, color: Colors.grey.shade700),),
                      Text("Year: ${widget.year}", style: TextStyle(fontSize: 14, color: Colors.grey.shade700),),
                    ],
                  ),
                ),

                const SizedBox(height: 10.0,),

                Card(
                    margin: const EdgeInsets.all(5.0),
                    elevation: 5.0,
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(width: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(widget.description, style: const TextStyle(fontSize: 16),textAlign: TextAlign.justify,),
                    )),

                const SizedBox(height: 70,)
              ],
            ),
          ),
        ),
        floatingActionButton: SizedBox(
          width: MediaQuery.of(context).size.width*0.9,
          child: FloatingActionButton.extended(
            isExtended: true,
            elevation: 5.0,
            tooltip: "Add To Cart",
            onPressed: () async {

              var queryResult = await SQLHelper.getCartItem(widget.id);
              if(queryResult.isNotEmpty){
                late int id;
                late int quantity;
                for (var element in queryResult) {
                  id= element["id"];
                  quantity=element["quantity"];
                }
                await SQLHelper.updateCart(id, widget.id, ++quantity);

              }else{
                await SQLHelper.insertToCart(widget.id, 1);
              }

              itemCount();
              setState(() {});

              //SHOW SNACK BAR
              ScaffoldMessenger.of(context)
                  .showSnackBar(const SnackBar(
                backgroundColor: Colors.green,
                content: Text("Item Added To Cart"),
                behavior: SnackBarBehavior.floating,))
                  .closed
                  .then((value) => ScaffoldMessenger.of(context)
                  .clearSnackBars());

              },
            icon: const Icon(Icons.add),
            hoverColor: Colors.orangeAccent,
            label: const Text("ADD TO CART",style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),),

          ),
        ),
      ),
    );
  }
}
