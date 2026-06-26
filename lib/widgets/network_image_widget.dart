import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:eztrack_rental/theme/color.dart';

class NetworkImageWidget extends StatefulWidget {
  final String imageUrl;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? placeholderColor;
  final Color? errorColor;
  final Widget? placeholder;
  final Widget? errorWidget;
  final int maxRetries;
  final Duration retryDelay;

  const NetworkImageWidget({
    Key? key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    this.placeholderColor,
    this.errorColor,
    this.placeholder,
    this.errorWidget,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 2),
  }) : super(key: key);

  @override
  State<NetworkImageWidget> createState() => _NetworkImageWidgetState();
}

class _NetworkImageWidgetState extends State<NetworkImageWidget> {
  int _retryCount = 0;
  bool _isRetrying = false;

  @override
  void initState() {
    super.initState();
  }

  void _retryLoad() {
    if (_retryCount < widget.maxRetries && mounted) {
      setState(() {
        _isRetrying = true;
        _retryCount++;
      });

      Future.delayed(widget.retryDelay, () {
        if (mounted) {
          setState(() {
            _isRetrying = false;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    
    // Validate URL
    if (widget.imageUrl.isEmpty) {
      return _buildErrorWidget('Invalid image URL');
    }
    
    final uri = Uri.tryParse(widget.imageUrl);
    if (uri == null || !uri.hasScheme) {
      return _buildErrorWidget('Invalid image URL');
    }

    return ClipRRect(
      borderRadius: widget.borderRadius ?? BorderRadius.zero,
      child: CachedNetworkImage(
        imageUrl: widget.imageUrl,
        width: widget.width,
        height: widget.height,
        fit: widget.fit,
        // maxWidthDiskCache: 2048,
        // maxHeightDiskCache: 2048,
        // memCacheWidth: widget.width?.toInt(),
        // memCacheHeight: widget.height?.toInt(),
        placeholder: (context, url) => widget.placeholder ?? _buildPlaceholder(),
        errorWidget: (context, url, error) {
          // Log error for debugging
          print('❌ NetworkImage Error: ${error.toString()}');
          print('📷 Image URL: $url');
          
          // Retry logic
          if (_retryCount < widget.maxRetries && !_isRetrying) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              _retryLoad();
            });
            return _buildRetryingWidget();
          }
          return widget.errorWidget ?? _buildErrorWidget('Failed to load image');
        },
        // fadeInDuration: const Duration(milliseconds: 300),
        // fadeOutDuration: const Duration(milliseconds: 100),
        // Add headers if needed for authentication
        // httpHeaders: {
        //   'Accept': 'image/*',
        // },
        // Increase timeout for slow networks
        cacheKey: widget.imageUrl,
        // Error listener for debugging
        errorListener: (exception) {
          print('❌ NetworkImage Error: ${exception.toString()}');
          print('📷 Image URL: ${widget.imageUrl}');
        },
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: widget.placeholderColor ?? const Color(0xFFF5F5F5),
      child: Center(
        child: CircularProgressIndicator(
          color: primary,
          strokeWidth: 2,
        ),
      ),
    );
  }

  Widget _buildRetryingWidget() {
    return Container(
      width: widget.width,
      height: widget.height,
      color: widget.errorColor ?? const Color(0xFFF5F5F5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: primary,
            strokeWidth: 2,
          ),
          const SizedBox(height: 8),
          Text(
            'Retrying... (${_retryCount}/${widget.maxRetries})',
            style: TextStyle(
              fontSize: 10,
              color: lightGray,
              fontFamily: 'BricolageGrotesque',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(String message) {
    return Container(
      width: widget.width,
      height: widget.height,
      color: widget.errorColor ?? const Color(0xFFF5F5F5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.broken_image_outlined,
            size: widget.height != null && widget.height! < 100 ? 30 : 40,
            color: lightGray,
          ),
          if (widget.height == null || widget.height! > 80) ...[
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  color: lightGray,
                  fontFamily: 'BricolageGrotesque',
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
