// ignore: import_of_legacy_library_into_null_safe
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../theme/theme.dart';
import 'package:truyen_chu/common/common.dart';

class CachedImageNetworkWidget extends StatelessWidget {
  final String url;
  final BoxFit? fit;

  CachedImageNetworkWidget({required this.url, this.fit});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      placeholder: (context, url) => _buildPlaceHolder(),
      errorWidget: (context, url, error) => _buildErrorWidget(),
      fit: fit ?? BoxFit.cover,
      width: double.infinity,
      height: double.infinity,
    );
  }

  Widget _buildPlaceHolder() {
    return Shimmer.fromColors(
      baseColor: AssetColors.shimmerBaseColor,
      highlightColor: AssetColors.shimmerHighlightColor,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.white,
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Container(
      alignment: Alignment.center,
      width: double.infinity,
      height: double.infinity,
      color: AssetColors.shimmerBaseColor,
      child: Image.asset('img_splash'.assetPathPNG,fit: BoxFit.cover,),
    );
  }
}
