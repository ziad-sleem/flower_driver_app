import 'package:flutter/material.dart';
import 'package:tracking_app/core/widgets/app_sizebox.dart';
import 'package:tracking_app/core/widgets/cached_network_image.dart';

class AddressTile extends StatelessWidget {
  final String title;
  final String address;
  final String? image;

  const AddressTile({
    super.key,
    required this.title,
    required this.address,
    this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          image != null && image!.isNotEmpty
              ? ClipOval(
                  child: CachedNetworkImageWidget(
                    urlToImage: image!,
                    width: 36,
                    height: 36,
                  ),
                )
              : const CircleAvatar(
                  radius: 18,
                  child: Icon(Icons.person),
                ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title),
                const AppSizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 15),
                    const AppSizedBox(width: 4),
                    Expanded(
                      child: Text(address, overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
