import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// Interactive Google map (Maps JS) rendered in a WebView — dependency-free vs
/// the native Google Maps SDK. A fixed centre pin marks the chosen point; when
/// the map settles the centre coordinate is posted back via [onCenterChanged]
/// so the caller can reverse-geocode it.
class MapWebView extends StatefulWidget {
  final String apiKey;
  final double lat;
  final double lon;
  final void Function(double lat, double lon) onCenterChanged;

  const MapWebView({super.key, required this.apiKey, required this.lat, required this.lon, required this.onCenterChanged});

  @override
  State<MapWebView> createState() => _MapWebViewState();
}

class _MapWebViewState extends State<MapWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel('PinChannel', onMessageReceived: (msg) {
        final parts = msg.message.split(',');
        if (parts.length == 2) {
          final lat = double.tryParse(parts[0]);
          final lon = double.tryParse(parts[1]);
          if (lat != null && lon != null) widget.onCenterChanged(lat, lon);
        }
      })
      ..loadHtmlString(_html);
  }

  String get _html => '''
<!doctype html><html><head><meta name="viewport" content="width=device-width, initial-scale=1">
<style>html,body,#map{height:100%;margin:0;padding:0}
#pin{position:absolute;left:50%;top:50%;transform:translate(-50%,-100%);font-size:32px;z-index:5}</style></head>
<body><div id="map"></div><div id="pin">📍</div>
<script>
function init(){
  var map = new google.maps.Map(document.getElementById('map'), {
    center: {lat: ${widget.lat}, lng: ${widget.lon}}, zoom: 17,
    disableDefaultUI: true, gestureHandling: 'greedy'
  });
  map.addListener('idle', function(){
    var c = map.getCenter();
    if (window.PinChannel) PinChannel.postMessage(c.lat()+','+c.lng());
  });
}
</script>
<script async src="https://maps.googleapis.com/maps/api/js?key=${widget.apiKey}&callback=init"></script>
</body></html>''';

  @override
  Widget build(BuildContext context) => WebViewWidget(controller: _controller);
}

/// Street View panorama in a WebView, shown when coverage exists.
class StreetViewWebView extends StatefulWidget {
  final String apiKey;
  final double lat;
  final double lon;

  const StreetViewWebView({super.key, required this.apiKey, required this.lat, required this.lon});

  @override
  State<StreetViewWebView> createState() => _StreetViewWebViewState();
}

class _StreetViewWebViewState extends State<StreetViewWebView> {
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadHtmlString(_html);
  }

  String get _html => '''
<!doctype html><html><head><meta name="viewport" content="width=device-width, initial-scale=1">
<style>html,body,#pano{height:100%;margin:0;padding:0}</style></head>
<body><div id="pano"></div>
<script>
function init(){
  new google.maps.StreetViewPanorama(document.getElementById('pano'), {
    position: {lat: ${widget.lat}, lng: ${widget.lon}}, pov: {heading: 0, pitch: 0}, zoom: 1,
    addressControl: false, fullscreenControl: false, motionTracking: false, motionTrackingControl: false
  });
}
</script>
<script async src="https://maps.googleapis.com/maps/api/js?key=${widget.apiKey}&callback=init"></script>
</body></html>''';

  @override
  Widget build(BuildContext context) => WebViewWidget(controller: _controller);
}
