import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:squash_archiver/common/helpers/display_helper.dart';
import 'package:squash_archiver/constants/colors.dart';
import 'package:squash_archiver/utils/utils/files.dart';
import 'package:squash_archiver/utils/utils/functs.dart';
import 'package:squash_archiver/utils/utils/math.dart';
import 'package:squash_archiver/utils/utils/strings.dart';
import 'package:squash_archiver/widget_extends/sf_widget.dart';

class Img extends StatefulWidget {
  final String url;
  final double height;
  final double width;
  final bool fullWidth;
  final bool fullHeight;
  final bool fullFit;
  final bool isSvg;
  final BoxFit fit;

  const Img(
    this.url, {
    Key key,
    this.height,
    this.width,
    this.fit,
    this.isSvg = false,
    this.fullWidth = false,
    this.fullHeight = false,
    this.fullFit = false,
  }) : super(key: key);

  @override
  _ImgState createState() => _ImgState();
}

class _ImgState extends SfWidget<Img> {
  String get url => widget.url;

  double get height => widget.height;

  double get width => widget.width;

  bool get fullWidth => widget.fullWidth;

  bool get fullHeight => widget.fullHeight;

  bool get fullFit => widget.fullFit;

  BoxFit get fit => widget.fit;

  bool get isSvg => widget.isSvg;

  double get _displayHeight => Display.getHeight(context);

  double get _displayWidth => Display.getWidth(context);

  double get _height {
    if (fullFit) {
      return height ?? _displayWidth;
    }

    return fullHeight ? _displayHeight : height;
  }

  double get _width {
    if (fullFit) {
      return _displayWidth;
    }

    return fullWidth ? _displayWidth : width;
  }

  double get _placeholderSize {
    const _placeholderSize = 20.0;

    final _heightWidthList = <double>[];

    if (_height != null) {
      _heightWidthList.add(_height);
    }

    if (_width != null) {
      _heightWidthList.add(_width);
    }

    final _allowedPlaceholderSize =
        getDoubleMin([_placeholderSize, ..._heightWidthList]);

    if (_heightWidthList.isNotEmpty) {
      final _minAppliedSize = getDoubleMin(_heightWidthList);

      final _minOfTwo =
          getDoubleMin([_allowedPlaceholderSize, _minAppliedSize / 2]);

      if (_placeholderSize <= _allowedPlaceholderSize) {
        return _minOfTwo;
      }

      var _computedSize = _allowedPlaceholderSize;

      if (_computedSize >= 2) {
        _computedSize /= 2;
      } else {
        _computedSize = 0;
      }

      return _computedSize;
    }

    return _allowedPlaceholderSize;
  }

  Widget _buildSizedContainer({
    @required Widget child,
    @required BuildContext context,
  }) {
    return SizedBox(
      width: _width,
      height: _height,
      child: Center(child: child),
    );
  }

  Widget _buildFullFitImage(
    BuildContext context,
    ImageProvider imageProvider,
    BoxFit fix,
  ) {
    return Container(
      width: _width,
      height: _height,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: imageProvider,
          fit: fit,
        ),
      ),
    );
  }

  Widget _buildImage(BuildContext context) {
    final _fit = fit ?? BoxFit.fill;
    final _url = url;

    if (isNullOrEmpty(url)) {
      return Container();
    }

    if (isSvg || getFileExtension(_url) == 'svg') {
      return _buildSvg(url: _url);
    }

    return _buildPng(url: _url, fit: _fit);
  }

  Widget _buildSvg({
    @required String url,
  }) {
    final _isNetworkUrl = isUrl(
      url,
    );

    if (!_isNetworkUrl) {
      return _buildSizedContainer(
        context: context,
        child: SvgPicture.asset(
          url,
          height: _height,
          width: _width,
        ),
      );
    }

    return _buildSizedContainer(
      context: context,
      child: SvgPicture.network(
        url,
        placeholderBuilder: (BuildContext context) {
          return _buildPlaceholder(context);
        },
        height: _height,
        width: _width,
      ),
    );
  }

  Widget _buildPng({
    @required String url,
    @required BoxFit fit,
  }) {
    final _isNetworkUrl = isUrl(
      url,
    );

    if (!_isNetworkUrl) {
      return _buildSizedContainer(
        context: context,
        child: Image.asset(
          url,
          height: _height,
          width: _width,
        ),
      );
    }

    return _buildSizedContainer(
      child: CachedNetworkImage(
        imageBuilder: fullFit
            ? (context, imageProvider) {
                return _buildFullFitImage(context, imageProvider, fit);
              }
            : null,
        imageUrl: url,
        placeholder: (context, _url) {
          return _buildPlaceholder(context);
        },
        errorWidget: (context, _url, error) {
          return const Icon(
            Icons.error,
          );
        },
        fadeOutDuration: const Duration(milliseconds: 100),
        fadeInDuration: const Duration(milliseconds: 100),
        height: _height,
        width: _width,
      ),
      context: context,
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    return SizedBox(
      height: _placeholderSize,
      width: _placeholderSize,
      child: Padding(
        padding: const EdgeInsets.all(0),
        child: CircularProgressIndicator(
          backgroundColor: AppColors.white,
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.blue),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildImage(context);
  }
}
