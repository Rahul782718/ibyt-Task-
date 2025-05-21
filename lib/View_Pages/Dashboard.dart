import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../Api_Response/Product_Response.dart';
import '../Provider/Service_Provider.dart';
import '../Provider/SharedPrefsService.dart';


class Dashboard_Screen extends StatelessWidget {
  const Dashboard_Screen({super.key});

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
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.7,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: provider.productResponse!.products.length,
              itemBuilder: (context, index) {
                final product = provider.productResponse!.products[index];
                return Stack(
                  children: [
                    Card(
                      elevation: 5,
                      color: Colors.white12,
                      margin: EdgeInsets.only(bottom: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: CachedNetworkImage(
                                imageUrl: product.images.first,
                                fit: BoxFit.fill,
                                // placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                                errorWidget: (context, url, error) => Icon(Icons.error),
                              ),
                            ),
                            Text(product.title, style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 16),),
                            Text(product.category.name,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w400,fontSize: 13),)
                          ],
                        ),
                      ),
                    ),

                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.blueAccent,
                        child:Text("₹ ${product.price.toString()}",style: TextStyle(color: Colors.white,fontSize: 12),),
                      ),
                    )
                  ],
                );
              },
            );
          } else {
            return Center(child: Text("No data available"));
          }
        },
      ),
    );
  }
}
