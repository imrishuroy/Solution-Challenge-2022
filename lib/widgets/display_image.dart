import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

const String _errorImage =
    'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTjMD6Pl7n4lSFFphlDlRz7o4ULYlNrAC9KJN4sfz9mRDDgU_FzGrA-DNgLL8keHh90KJg&usqp=CAU';

class DisplayImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final BoxFit? fit;
  final double? height;
  const DisplayImage({
    Key? key,
    required this.imageUrl,
    this.width,
    this.fit = BoxFit.cover,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      width: width ?? 1000.0,
      height: height,
      imageUrl: imageUrl ?? _errorImage,
      fit: fit,
      progressIndicatorBuilder: (context, url, downloadProgress) => Center(
        child: CircularProgressIndicator(
          strokeWidth: 2.0,
          value: downloadProgress.progress,
          color: Colors.white,
        ),
      ),
      errorWidget: (context, url, error) =>
          const Center(child: Icon(Icons.error)),
    );
  }
}


// import 'package:assignments/widgets/loading_indicator.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart

// class DisplayImage extends StatelessWidget {
//   final String? imageUrl;
//   final double errorIconSize;

//   const DisplayImage(
//     this.imageUrl, {
//     this.errorIconSize = 20.0,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return imageUrl!.isEmpty
//         ? Icon(Icons.image_not_supported_sharp)
//         : CachedNetworkImage(
//             fit: BoxFit.cover,
//             placeholder: (context, _) => const LoadingIndicator(
//               size: 10.0,
//             ),
//             // progressIndicatorBuilder: (context, url, downloadProgress) =>
//             //     SizedBox(
//             //   height: 10.0,
//             //   width: 10.0,
//             //   child: CircularProgressIndicator(
//             //     value: downloadProgress.progress,
//             //     strokeWidth: 3.0,
//             //   ),
//             // ),
//             imageUrl: imageUrl!,

//             errorWidget: (context, _, __) => Icon(
//               Icons.error,
//               size: errorIconSize,
//             ),
//           );
//   }
// }

