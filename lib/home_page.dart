import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:untitled/details_page.dart';
import 'package:untitled/my_appbar.dart';
import 'package:untitled/sql_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  // All The Books
  List<Map<String, dynamic>> _books = [];

  bool _isLoading = true;
  late int _totalItems=0;


  // This Function Is Used To Fetch All The Data From The Database
  void _refreshBooks() async {
    final data = await SQLHelper.getBooks();
    setState(() {
      _books = data;
      _isLoading = false;
    });
  }

  // Insert a new Book to the database
  Future<void> _addItems() async {
    await SQLHelper.createBook("Goodnight Moon", "Goodnight Moon is an American children's book written by Margaret Wise Brown and illustrated by Clement Hurd. It was published on September 3, 1947, and is a highly acclaimed bedtime story. This book is the second in Brown and Hurd's \"classic series\", which also includes The Runaway Bunny and My World.", "kids book", 1947, "Margaret Wise Brown", 20.5, "https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcQdKBbALUAgHqMnZepX2ra6coOfTu9g-3w_CgPmE58muFoCsYAK");
    await SQLHelper.createBook("The Very Hungry Caterpillar", "The Very Hungry Caterpillar is a 1969 children’s picture book designed, illustrated, and written by Eric Carle. The book features a hungry caterpillar that eats a variety of foods before pupating and emerging as a butterfly. It has won many children’s literature awards and major graphic design awards.", "kids book", 1969, "Eric Carle", 13.25, "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSWKI-EPezZq6jdjG9IPQaDfDm6f8vBJCLEPbSyYsjgN8Ig_5iu");
    await SQLHelper.createBook("The Cat in the Hat", "The Cat in the Hat is a 1957 children's book written and illustrated by the American author Theodor Geisel, using the pen name Dr. Seuss. The story centers on a tall anthropomorphic cat who wears a red and white-striped top hat and a red bow tie.", "kids book", 1957, "Theodor Geisel", 24.5, "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcSNrGIzWlxnhbsA7mpEqTaY3G3xB5AqzhfV4Vn9CuNMnJGJhznV");
    await SQLHelper.createBook("Where the Wild Things Are", "Where the Wild Things Are is a 1963 children's picture book written and illustrated by American writer and illustrator Maurice Sendak, originally published in hardcover by Harper & Row.", "kids book", 1963, "Maurice Sendak", 28, "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTmpQnO2AxpFXeDZafGtAP8NTj4zvve2h_FrDSAaEWJK5BlPdpm");
    await SQLHelper.createBook("Guess How Much I Love You", "Guess How Much I Love You is a British children's book written by Sam McBratney and illustrated by Anita Jeram, published in 1994, in the United Kingdom by Walker Books and in 1995, in the United States by its subsidiary Candlewick Press. The book was a 1996 ALA Notable Children's Book.", "kids book", 1994, "Sam McBratney", 12.5, "https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcS9oFGzJE-3Q_DB3-8AnLzsyhSZOGgFgCClDMiH0UpZB3Tu0Ml7");
    await SQLHelper.createBook("Matilda", "Matilda is a children's novel written by British writer Roald Dahl and illustrated by Quentin Blake. It was published in 1988 by Jonathan Cape. The story features Matilda Wormwood, a precocious child with an uncaring mother and father, and her time in school run by the tyrannical headmistress Miss Trunchbull.", "kids book", 1988, "Roald Dahl", 10.5, "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcR4MqxJvifTKlajnsYUqk36zDwFeNxQPq6eF2aOJUx0-odatQnb");
    await SQLHelper.createBook("Harry Potter and the Prisoner of Azkaban", "Harry Potter and the Prisoner of Azkaban is a fantasy novel written by British author J. K. Rowling and is the third in the Harry Potter series. The book follows Harry Potter, a young wizard, in his third year at Hogwarts School of Witchcraft and Wizardry", "kids book", 1999, "J. K. Rowling", 14.0, "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcRDQUcqEVnm1TSGF_Mejt9_Tctl8Wh0rUcRRs_Icr2YlUTv6lZB");
    await SQLHelper.createBook("Tales of a Fourth Grade Nothing", "Tales of a Fourth Grade Nothing is a children's novel written by American author Judy Blume and published in 1972. It is the first in the Fudge series and was followed by Otherwise Known as Sheila the Great, Superfudge, Fudge-a-Mania, and Double Fudge.", "kids book", 1972, "Judy Blume", 15.25, "https://encrypted-tbn1.gstatic.com/images?q=tbn:ANd9GcSRB6A9meFF5zFv0dHSC7FUqUHoHeB6oKy_hql5896xJc8v-xpt");
    await SQLHelper.createBook("If Animals Kissed Good Night", "With its whimsical art and playful rhymed verse, this bedtime favorite from author Ann Whitford Paul and illustrator David Walker If Animals Kissed Good Night is sure to delight time and again.What if animals did what YOU do?", "kids book", 2008, "Ann Whitford Paul", 16.0, "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTGJ_OPWsiuh8z2qrbMbersxSK07OTw6zcRZL1_viO1q08Tfs2M");
    await SQLHelper.createBook("Brown Bear, Brown Bear, What Do You See?", "Brown Bear, Brown Bear, What Do You See? is a children's picture book published in 1967 by Henry Holt and Company, Inc. Written and illustrated by Bill Martin Jr. and Eric Carle, the book is designed to help toddlers associate colors and meanings to objects.", "kids book", 1967, "Henry Holt", 11.25, "https://encrypted-tbn3.gstatic.com/images?q=tbn:ANd9GcQu3sOjYxRV1sVGOEfBEB1_MXyEbI6NlgLSoYYgeNI7LeKTHNXg");
    _refreshBooks();
  }

  void itemCount()async{
    //Cart Size
    final cartCount = await SQLHelper.getCount();
    setState(() {
      _totalItems= cartCount;
    });
  }

  @override
  void initState() {
    super.initState();
    //_addItems();
    _refreshBooks(); // Loading the diary when the app starts
    itemCount();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        onRefresh: () async{
          _refreshBooks();
          itemCount();
        },
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
          appBar: MyAppBar(pageTitle: "Home Page", items: _totalItems),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                    margin: const EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                    child: const Text("Books' List", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30),)),

                _isLoading
                    ? const Center(
                  child: CircularProgressIndicator(),
                )
                    :  ListView.builder(
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  itemCount: _books.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
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
                            visualDensity: const VisualDensity(vertical: 2), // to expand
                            leading:  CircleAvatar(backgroundImage: NetworkImage(_books[index]["image"],),),
                            title: Text(_books[index]["title"], style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18.0),),
                            subtitle: Text(_books[index]["author"]),
                            trailing: const Icon(Icons.arrow_forward_ios_rounded),
                            onTap: (){
                              Get.to(()=>DetailsPage(id: _books[index]["id"],title:_books[index]["title"], image: _books[index]["image"], author: _books[index]["author"], description: _books[index]["description"], genre: _books[index]["genre"], year: _books[index]["year"], price: _books[index]["price"],));
                            },
                          ),
                        ),
                      ],
                    );
                  },
                ),

                const SizedBox(height: 20,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
