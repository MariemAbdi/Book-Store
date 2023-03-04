import 'package:flutter/material.dart';
import 'package:untitled/home_page.dart';
import 'package:untitled/my_appbar.dart';
import 'package:get/get.dart';
import 'package:untitled/sql_helper.dart';

class Cart extends StatefulWidget {
  const Cart({Key? key}) : super(key: key);

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {

  // All The Cart Items
  List<Map<String, dynamic>> _cart = [];

  // All The Books
  List<Map<String, dynamic>> _books = [];


  bool _isLoading = true;
  late int _itemsCount=0;
  late int _totalItems=0;
  late double _totalPrice=0;

  // This Function Is Used To Fetch All The Data From The Database
  void _refreshCart() async {
    _totalItems=0;
    _totalPrice=0;

    //Cart Information
    final cartData = await SQLHelper.getCart();
    setState(() {
      _cart = cartData;
      _isLoading = false;
    });

    final bookData = await SQLHelper.getBooks();
    setState(() {
      _books = bookData;
    });

    for (var element in _cart) {
      int q= element["quantity"] as int;
      _totalItems+=q;
      int pos= _books.indexWhere((b) => b["id"]==(element["book"])as int);
      _totalPrice+=_books[pos]["price"]*q.toDouble();
      //print(_totalPrice);
    }
  }

  void itemCount()async{
    //Cart Information
    final cartCount = await SQLHelper.getCount();
    setState(() {
      _itemsCount= cartCount;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshCart(); // Loading the diary when the app starts
    itemCount();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        appBar: MyAppBar(pageTitle: "My Cart", items: _itemsCount),
        body: SingleChildScrollView(
          child: Column(
            children: [

              Container(
                  margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                  child: const Text("My Order", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30),)
              ),

              _isLoading
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : ListView.builder(
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
                itemCount: _cart.length,
                itemBuilder: (BuildContext context, int index){

                  int pos= _books.indexWhere((element) => element["id"] as int ==(_cart[index]["book"] as int));
                  String image="";
                  String title="";
                  double price=0.0;
                  if(pos!=-1){
                     image= _books[pos]["image"];
                     title=_books[pos]["title"];
                     price= _books[pos]["price"];
                  }

                  return _cart.isEmpty?const Center(child: Text("Cart Is Empty", style: TextStyle(fontWeight: FontWeight.bold),),)
                      : Column(
                    children: [
                      Card(
                        elevation: 6,
                        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        shape: RoundedRectangleBorder(
                          side: const BorderSide(width: 0.3),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListTile(
                                dense: true,
                                visualDensity: const VisualDensity(vertical: 4), // to expand
                                leading:  CircleAvatar(backgroundImage: NetworkImage((image)),),
                                title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18.0), overflow: TextOverflow.ellipsis,),
                                subtitle: Text("Unit Price: $price TND\nTotal Price: ${price * (_cart[index]["quantity"]).toDouble()}"),
                                trailing: FittedBox(
                                  child: Row(
                                    children: [
                                      Container(
                                        width:20,
                                        height: 20,
                                        color: Colors.redAccent,
                                        child: IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: _cart[index]["quantity"]==1?null:()async{
                                              await SQLHelper.updateCart(_cart[index]["id"], _cart[index]["book"], _cart[index]["quantity"]-1);
                                              _refreshCart();
                                              itemCount();
                                            }, icon: const Icon(Icons.remove,color: Colors.white, size: 12,)),
                                      ),

                                      const SizedBox(width: 5,),
                                      Text("${_cart[index]["quantity"]}"),
                                      const SizedBox(width: 5,),

                                      Container(
                                        width:20,
                                        height: 20,
                                        color: Colors.green,
                                        child: IconButton(
                                            padding: EdgeInsets.zero,
                                            onPressed: () async{
                                              await SQLHelper.updateCart(_cart[index]["id"], _cart[index]["book"], _cart[index]["quantity"]+1);
                                              _refreshCart();
                                              itemCount();
                                            }, icon: const Icon(Icons.add, color: Colors.white, size: 12,)),
                                      ),

                                      IconButton(onPressed: () async{
                                        // Create AlertDialog
                                        AlertDialog alert = AlertDialog(
                                          title: const Text("Leave App"),
                                          content: const Text("Are You Sure You Want To Leave ?"),
                                          actions: [
                                            ElevatedButton(
                                                onPressed: (){Navigator.of(context).pop();}, child: const Text("NO")),
                                            ElevatedButton(onPressed: ()async{
                                              await SQLHelper.deleteItemFromCart(_cart[index]["id"]);
                                              _refreshCart();
                                              itemCount();
                                              Navigator.of(context).pop();
                                              //SHOW SNACK BAR
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(const SnackBar(
                                                backgroundColor: Colors.red,
                                                content: Text("Item Deleted Successfully"),
                                                behavior: SnackBarBehavior.floating,))
                                                  .closed
                                                  .then((value) => ScaffoldMessenger.of(context)
                                                  .clearSnackBars());
                                            }, child: const Text("YES")),
                                          ],
                                        );
                                        // show the dialog
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return alert;
                                          },);
                                      }, icon: const Icon(Icons.delete, color: Colors.red,)),
                                    ],
                                  ),
                                ),
                        )
                      ),
                    ],
                  );
                },
              ),


              const SizedBox(height: 120,),

            ],
          ),
        ),

        floatingActionButton: Container(
          width: double.infinity,
          height: 110,
          color: Colors.grey.withOpacity(0.9),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Items: $_totalItems", style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18.0)),
                    Text("$_totalPrice TND", style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18.0)),
                  ],
                ),
              ),


              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  FloatingActionButton.extended(
                    heroTag: "heroTag1",
                    onPressed: () => {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(
                    backgroundColor: Colors.green,
                    content: Text("Order Passed Successfully!"),
                    behavior: SnackBarBehavior.floating,))
                        .closed
                        .then((value) => ScaffoldMessenger.of(context)
                        .clearSnackBars())
                    },
                    backgroundColor: Colors.orangeAccent,
                    hoverColor:Colors.orange,
                    icon: const Icon(Icons.shopping_bag),
                    label: const Text("Order Now"),
                  ),
                  FloatingActionButton.extended(
                    heroTag: "heroTag2",
                    onPressed: () => {
                      //Get.back()
                      Get.to(()=>const HomePage())
                    },
                    hoverColor: Colors.blue,
                    icon: const Icon(Icons.book),
                    label: const Text("All The Books"),
                  ),
                ],
              ),

              const SizedBox(height: 15,),
            ],
          ),
        ),
      ),
    );
  }

  String calculateTotal() {
    double total=0;
    // List r = [];
    // for(int i=0; i<_prices.length; i++){
    //   r.add(_prices[i] * _quantities[i]);
    // }

    return "${total}TND";
  }
}
