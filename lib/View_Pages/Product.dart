import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Provider/Service_Provider.dart';

class Product_Screen extends StatefulWidget {
  const Product_Screen({super.key});

  @override
  State<Product_Screen> createState() => _Product_ScreenState();
}

class _Product_ScreenState extends State<Product_Screen> {

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Consumer<ServiceProvider>(
        builder: (context, provider, _) {
          if (provider.isLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (provider.errorMessage.isNotEmpty) {
            return Center(child: Text(provider.errorMessage));
          } else if (provider.productResponse != null) {

            /// this is fetch data
            final allProduct = provider.productResponse!.products;

            /// this is search Query
            final query = _searchController.text.toLowerCase();

            /// this is filter Product
            final filteredProducts = query.isEmpty
                ? []
                : allProduct.where((product) {
              return product.title.toLowerCase().contains(query);
            }).toList();

            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [


                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.sizeOf(context).width * 0.8,
                          child: TextFormField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Search',
                              hintStyle: TextStyle(color: Colors.white),
                              contentPadding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                              prefixIcon: Icon(Icons.search, color: Colors.white),
                              filled: true,
                              fillColor: Colors.grey.shade300,
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(color: Colors.white, width: 2),
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                        ),
                        Icon(Icons.filter_1, color: Colors.white,)
                      ],
                    ),

                    SizedBox(height: 12,),

                    ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: _searchController.text.isEmpty ?  provider.productResponse!.products.length : filteredProducts.length,
                      itemBuilder: (context, index) {
                        final product = _searchController.text.isEmpty ? provider.productResponse!.products[index] : filteredProducts[index];
                        return Card(
                          elevation: 5,
                          color: Colors.white12,
                          margin: EdgeInsets.only(bottom: 20),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: MediaQuery.sizeOf(context).width * 0.30,
                                  height: MediaQuery.sizeOf(context).width * 0.30,
                                  child: CachedNetworkImage(
                                    imageUrl: product.images.first,
                                    fit: BoxFit.fill,
                                    // placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) => Icon(Icons.error),
                                  ),
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(product.title, style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 16),),
                                      Text(product.description,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 13),),
                                      Text("₹ ${product.price.toString()}",style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Center(child: Text("No data available"));
          }
        },
      ),
    );
  }
}
